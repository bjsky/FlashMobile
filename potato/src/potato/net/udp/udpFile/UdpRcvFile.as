package potato.net.udp.udpFile
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import core.filesystem.File;
	import core.filesystem.FileStream;
	import core.net.UdpSocket;
	
	import potato.net.udp.manager.UdpDataManager;
	import potato.net.udp.udpConfig.UdpConfig;
	import potato.net.udp.udpConst.UdpMessageConst;
	import potato.net.udp.udpData.UdpSendClientData;
	import potato.net.udp.udpUtil.UdpUtils;

	public class UdpRcvFile
	{
		public static const DOWN_STATE_READY:int=0;			//准备下载
		public static const DOWN_STATE_COMPLETE:int=200;	//下载完成
		public static const DOWN_STATE_LOADING:int=100;	 	//正在下载
		public static const DOWN_STATE_ERROR:int=400;		//下载错误

		private static const CHUNK_STATE_COMPLETE:int=0;


		public var downState:int=DOWN_STATE_READY; //下载状态  200下载完成；100正在下载；400下载错误（md5校验）   /////，1正在发送下载请求

		public var usableClients:Object; 			//当前使用的客户端
		public var usableClinetNum:int=0;			//当前使用的客户端数量

		private var _msgId:uint;
		private var _url:String;
		private var _md5:String;
		private var _fileSize:int=0;
		private var udpSocket:UdpSocket;

		private var updateFileStream:FileStream;

		///// 快和包的下载状态
		private var chunkArr:Vector.<int>; // 文件的所有块索引数组，0==该块下载完成，非0正数==还没有下载的包数
		private var chunkDic:Vector.<Vector.<int>>; // key--块索引， value--每块的下载状态数组。1表示下载完，0还没下载
		private var loadChunkTime:Vector.<uint>; // 文件块的下载开始时间，为0表示还没开始下载。用来计算重下

		private var chunkDataArr:Vector.<ByteArray>; //块数据

		///// 文件下载时块划分策略为  region > chunk > datagram
		///// 当文件大小小于minRegionSize，则只会用1个线程下载所有块，否则用多个线程以区域为大小依次下载
		private static const MIN_REGION_SIZE:int=8;

		//// 计算循环时间
		private var lastTime:uint;
		private var now:uint; //时间

		private var retryArr:Vector.<int>; //需要重发的数据报

		private var sendBuf:ByteArray; //发送buffer

		private var chunkByteSize:int; //块字节数


		////////////////////////////////
		private var chunkNum:int; 		//总分块数
		private var requestedId:int; 	//已请求的块索引
		private var loadedChunk:int=0;  //已完整下载的块数


		public function UdpRcvFile(url:String, md5:String, msgId:uint, udpSocket:UdpSocket)
		{
			_url=url;
			_md5=md5;
			_msgId=msgId;
			this.udpSocket=udpSocket;

			usableClients=new Object();

			// 发送buffer和包头
			sendBuf=new ByteArray();
			sendBuf.writeByte(UdpConfig.HEXS); // S
			sendBuf.writeByte(UdpConfig.HEXF); // F

			updateFileStream=new FileStream();
			updateFileStream.open(url, FileStream.UPDATE);
		}

		public function get msgId():uint
		{
			return _msgId;
		}

		public function get md5():String
		{
			return _md5;
		}

		public function get url():String
		{
			return _url;
		}

		public function get fileSize():int
		{
			return _fileSize;
		}

		/**
		 * 设置文件大小，只有这个之后才会开始下载
		 * @param size
		 */
		public function set fileSize(size:int):void
		{
			_fileSize=size;
			chunkByteSize=UdpConfig.chunkSize << 9; // * UdpConfig.PACK_SIZE;

			// 初始化块数组
			var len:int=Math.ceil(Number(_fileSize) / chunkByteSize);
			chunkNum=len;

			chunkDataArr=new Vector.<ByteArray>(len);
			loadChunkTime=new Vector.<uint>(len);
			chunkDic=new Vector.<Vector.<int>>(len);
			retryArr=new Vector.<int>();

			chunkArr=new Vector.<int>(len);
			var i:int=0;
			len--;
			while (true)
			{
				chunkArr[i]=UdpConfig.chunkSize;
//				i += UdpConfig.chunkSize << 9;// * UdpConfig.PACK_SIZE;
				if(len <= 0)
				{
					break;
				}
				if (i == len)
				{
					var lastChunkSize:int=fileSize - UdpConfig.PACK_SIZE * UdpConfig.chunkSize * i;
					chunkArr[i]=Math.ceil(lastChunkSize / UdpConfig.PACK_SIZE);
					break;
				}
				i++;
			}
		}

		/**
		 * 写入收到的数据
		 * @param chunkIndex
		 * @param packIndex
		 * @param byteArr
		 * @param len
		 * @param clientAddr
		 */
		public function writeData(chunkIndex:int, packIndex:int, byteArr:ByteArray, len:int, clientAddr:String):void
		{
			trace("======写入到的数据=======");
			if (chunkArr[chunkIndex] == CHUNK_STATE_COMPLETE)
			{
				trace("这个块已经下载完成", chunkIndex);
				return;
			}
			var client:UdpSendClientData=usableClients[clientAddr];
			if (client == null)
			{
				trace("没使用的客户端", clientAddr);
				return;
			}
			var vc:Vector.<int>=chunkDic[chunkIndex];
			if (vc == null || vc[packIndex] == 1)
			{
				trace("这个块还没请求过或已经写完", chunkIndex, packIndex, vc);
				return;
			}
//			if (vc[packIndex] == 1) {
//				trace("这个包已经被写过", packIndex);
//				return;		//这个包已经被写过
//			}

			// 开始下载时间和下载速度
//			now = getTimer();
			client.gramNumArr[UdpSendClientData.RECORD_NUM - 1]++;
			client.rcvAllGram++;
			client.lastRcvTime=getTimer();
//			trace("rcvAllGram:", chunkIndex, packIndex, client.rcvAllGram);
			var ba:ByteArray=chunkDataArr[chunkIndex];
			if (ba == null)
			{
				ba=new ByteArray();
				chunkDataArr[chunkIndex]=ba;
			}
			////// 写入包数据到块
			ba.position=packIndex << 9; //* UdpConfig.PACK_SIZE;
			ba.writeBytes(byteArr, byteArr.position, len);
			trace("=byteArr=:"+byteArr+"=byteArr.position="+byteArr.position+"=len="+len);
			vc[packIndex]=1;
			chunkArr[chunkIndex]--; //减少一个包数
			// 减少客户端记录的发送块
			var ckd:Dictionary=client.chunkDic;
			if (ckd[chunkIndex] && ckd[chunkIndex] >= 0)
			{
				ckd[chunkIndex]--;
			}
			else
			{ 
				// 请求的包经过长时间后返回，这个包已经向另一个客户端请求重发(超时重发)，这时客户端记录会对应不上
				// 查找所有客户端
				for each (var tc:UdpSendClientData in usableClients)
				{
					ckd=tc.chunkDic;
					if (ckd[chunkIndex] && ckd[chunkIndex] >= 0)
					{
						ckd[chunkIndex]--;
					}
				}
			}
			if (chunkArr[chunkIndex] > 0)
			{
				trace("该块还有没收到的包");
				return; //该块还有没收到的包
			}

			// 该块下载完成，写入文件
			updateFileStream.position=chunkByteSize * chunkIndex; //chunkArr[chunkIndex];
			trace("=position="+updateFileStream.position+"=ba="+ba);
			updateFileStream.writeBytes(ba);
			// 清理
			ba.clear();
			chunkDataArr[chunkIndex]=null;
			chunkDic[chunkIndex]=null;
			delete ckd[chunkIndex];

			////// 检查整个文件是否下载完成
			loadedChunk++;
			if (loadedChunk < chunkNum)
			{
				trace("还有没完成的块");
				return; //还有没完成的块
			}
				
			trace("文件下载完成"+"==url=="+url+"==_md5=="+_md5);
			//文件全部下载完成，校验md5
			if (UdpUtils.checkMd5(updateFileStream, _md5))
			{
				trace("文件md5正确", url);
				updateFileStream.close();
				updateFileStream=null;
				downState=DOWN_STATE_COMPLETE;
			}
			else
			{
				trace("文件md5出错！！！", url);
				updateFileStream.close();
				updateFileStream=null;
				// 文件下载错误，重新下载
//				File.deleteFile(url);
				downState=DOWN_STATE_ERROR;
			}
			trace("下载完成时间：", getTimer() - loadStartTime);
			//发送接收完毕消息
			for each (var comClient:UdpSendClientData in usableClients)
			{
				sendRcvComplete(comClient);
			}
		}

		private var loadStartTime:int;

		public function startDown():void
		{
			downState=DOWN_STATE_LOADING; //正在下载
			lastTime=getTimer();
			loadStartTime=lastTime;
		}

		/**
		 * 检查该客户端是否可以开启新下载，并剔除超时和低速(丢包多)客户端
		 * @param c
		 * @return true=剔除这个客户端
		 */
		private function checkClient(c:UdpSendClientData):Boolean
		{
			///// 后5秒内的收包平均值
			var sumGram:int=0;
			for each (var ig:int in c.gramNumArr)
			{
				sumGram+=ig;
			}

			/////// 超时时间内未收到数据  //todo
			if (sumGram == 0 && now - c.lastReqTime > UdpConfig.OUT_TIME && now - c.lastRcvTime > UdpConfig.OUT_TIME)
			{
//				c.reset();
//				c.statue = Client.STATE_DISCARD;	//-1;	//标记为废弃

				sendRcvComplete(c); //  向发送端发送完成消息
				//TODO 向服务器发送废弃该发送端消息

				delete usableClients[c.address];
				UdpDataManager.getInstance().udpClientData.delClient(c); //从列表中删除
				return false;
			}

			////// 根据收包平均值来计算2秒内可能发包数， 以此为基数计算该客户端应该在什么时候发送请求
			var averageGram:int=sumGram / UdpSendClientData.RECORD_NUM;
			if (c.getRemainGramNum() > averageGram << 1)
			{ //还未收到的包预计接收时间 > 2秒
				return false;
			}

			return true;
		}

		private function retrySendCheck():void
		{
			// 重发计算
			var time:uint;
			var num:int=0;
			var isAdd:Boolean;
			for (var i:int=0; i < requestedId; i++)
			{
				time=loadChunkTime[i];
//				if (chunkArr[i] == CHUNK_STATE_COMPLETE) continue;
				if ( /*time > 0 && */chunkArr[i] != CHUNK_STATE_COMPLETE && now - time > UdpConfig.RESEND_OUT_TIME)
				{
					isAdd=false;
					// RESEND_OUT_TIME 时间内该块还没下载完，重发还没下载的包
					var vc1:Vector.<int>=chunkDic[i];
					for (var j:int=0; j < vc1.length; j++)
					{
						if (vc1[j] == 0)
						{
							retryArr.push(i); //块索引
							retryArr.push(j); //包索引
							isAdd=true;
						}
					}
					if (isAdd)
					{
						num++;
						loadChunkTime[i]=now;
						// 查找所有客户端中有该块索引的删除
						for each (var tc:UdpSendClientData in usableClients)
						{
							if (tc.chunkDic[i])
							{
								delete tc.chunkDic[i];
							}
						}
					}
					if (num > 1)
					{ //以原始块为单位，每次最多发两个
						break;
					}
				}
			}
		}

		/**
		 * 主处理循环
		 * 1. 计算传输速度
		 * 2. 下载区域，如果当前有空闲客户端，就开启一个下载区域
		 * 3. 重下处理
		 * @return
		 */
		public function handleLoop():void
		{
			var clen:int=0;
			for each (var cc:Object in usableClients)
			{
				clen++;
			}
			if (clen == 0)
				return;

			now=getTimer();
			var dt:Number=now - lastTime;
			if (dt >= 1000)
			{
				lastTime=now;
				retrySendCheck(); //重发检测
			}
			
			var gn:int;
			var ga:Vector.<int>;
			for each (var c:UdpSendClientData in usableClients)
			{
				
				if (dt >= 1000)
				{
					c.rcvAllTime+=dt;
					sendNetStatue(c, dt);

					ga=c.gramNumArr;
					ga.shift();
					ga.push(0);

					trace("总收到包：", c.rcvAllGram);
				}
				// 是否发送下一个请求
				if (c.statue == UdpSendClientData.STATE_REQUEST || checkClient(c))
				{ 
					//存在空闲的客户端
					if (retryArr.length > 0)
					{
						//先发送需重发的包
						gn=retryArr.length;
						c.statue=UdpSendClientData.STATE_SEND;
						c.reqAllGram+=gn;
						//						c.reqGram = gn;
						//						c.rcvGram = 0;
						c.lastReqTime=now;
						
						sendRetryGetData(c);
						//						retryArr = new Vector.<int>();
						retryArr.length=0;
						continue;
					}
					if (requestedId < chunkNum)
					{ 
						trace("还有没请求过的数据")
						//还有没请求过的数据
						var len:int=sendGetData(c);
						gn=len * UdpConfig.chunkSize;
						c.statue=UdpSendClientData.STATE_SEND;
						c.reqAllGram+=gn;
//						c.reqGram = gn;
//						c.rcvGram = 0;
						c.lastReqTime=now;
					}
				}
			}
		}

		/**
		 * 给客户端发送“请求发送文件连接”消息  S_GETFILE
		 * @param url
		 * @param md5
		 */
		public function sendGetFile(clt:UdpSendClientData):void
		{
			sendBuf.position=2;
			sendBuf.writeByte(UdpMessageConst.S_GETFILE); // 请求发送文件
			sendBuf.writeUnsignedInt(msgId); 			  // 消息序号
			sendBuf.writeUTF(UdpConfig.gameid);
			sendBuf.writeByte(UdpConfig.uploadFlag);
			sendBuf.writeUTF(url);
			sendBuf.writeUTF(md5);
			
			udpSocket.send(sendBuf, 0, sendBuf.position, clt.ip, clt.port);
			
			UdpDataManager.getInstance().udpReSendData.addReSendDic(UdpMessageConst.S_GETFILE,msgId,sendBuf, 0, sendBuf.position, clt.ip, clt.port);
			trace("请求发送文件连接"+"=对方=ip=="+clt.ip+"=对方=port=="+clt.port);
		}
		/**
		 *请求打洞消息 
		 * @param clt
		 * 
		 */
		public function sendHole(ip:String,port:uint):void
		{
			sendBuf.writeByte(UdpConfig.HEXS); // S
			sendBuf.writeByte(UdpConfig.HEXF); // F
			sendBuf.writeByte(UdpMessageConst.S_HOLE); // 请求打洞消息 
			sendBuf.writeUnsignedInt(msgId);		   // 消息序号
			sendBuf.writeUTF(ip);				   	   //请求方ip
			sendBuf.writeShort(port);			   	   //请求方端口
			trace("请求方ip:"+ip+",请求方端口:"+port);
			udpSocket.send(sendBuf, 0, 0, UdpConfig.serverIp, UdpConfig.serverPort);
		}
		/**
		 *请求打洞完成消息 
		 * 
		 */
		public function sendHoleEnd():void
		{
			sendBuf.writeByte(UdpConfig.HEXS); // S
			sendBuf.writeByte(UdpConfig.HEXF); // F
			sendBuf.writeByte(UdpMessageConst.S_HOLEEND); // 请求打洞完成消息 
			sendBuf.writeUnsignedInt(msgId);		   // 消息序号
			udpSocket.send(sendBuf, 0, 0, UdpConfig.serverIp, UdpConfig.serverPort);
		}
		/**
		 * 请求发送数据  S_GETDATA
		 * @param ip
		 * @param port
		 * @return 发送的块数
		 */
		private function sendGetData(clientData:UdpSendClientData):int
		{
			sendBuf.position=2;
			sendBuf.writeByte(UdpMessageConst.S_GETDATA); //请求发送文件
			sendBuf.writeUnsignedInt(msgId); 			  //消息序号
			sendBuf.writeUTF(_url);						  //文件ur
			var len:int=MIN_REGION_SIZE;
			
			trace("=sendGetData="+"=len="+len+"=requestedId="+requestedId+"=chunkNum="+chunkNum);
			if (requestedId + MIN_REGION_SIZE > chunkNum)
			{
				len=chunkNum - requestedId;
			}
			trace("=sendGetData="+"=len="+len);
			sendBuf.writeInt(len); 						 //数据块索引数

			if (clientData.chunkDic == null) 
			{
				clientData.chunkDic = new Dictionary();
			}

			//顺序请求
			for (var i:int=0; i < len; i++)
			{
				// 创建每个块中的包数组
				chunkDic[requestedId]=new Vector.<int>(chunkArr[requestedId]);
				clientData.chunkDic[requestedId]=chunkArr[requestedId]; //每个客户端都记录发送的块
				loadChunkTime[requestedId]=now;				   //初次请求时间
				sendBuf.writeInt(requestedId++); 			   //数据块数索引
			}
			
			udpSocket.send(sendBuf, 0, sendBuf.position, clientData.ip, clientData.port);
			trace("请求发送数据="+"=requestedId="+requestedId+"=len="+len+"=ip="+clientData.ip+"=port="+clientData.port+"=msgId="+msgId+"=url="+_url);
			return len;
		}

		/**
		 * 请求重发数据包  S_RETRYGETDATA
		 * @param ip
		 * @param port
		 * @param rcvFile
		 */
		private function sendRetryGetData(c:UdpSendClientData):void
		{
			sendBuf.position=2;
			sendBuf.writeByte(UdpMessageConst.S_RETRYGETDATA); // 请求重发
			sendBuf.writeUnsignedInt(_msgId); 				   // 消息序号
			var len:int=retryArr.length;
			sendBuf.writeInt(len); 							   //数据块索引数，2个数表示一个包
			for (var i:int=0; i < len; i+=2)
			{
				if (c.chunkDic[retryArr[i]])
				{
					c.chunkDic[retryArr[i]]++;
				}
				else
				{
					c.chunkDic[retryArr[i]]=1;
				}
				sendBuf.writeInt(retryArr[i]); //数据块索引
				sendBuf.writeInt(retryArr[i + 1]); //数据包索引
			}
			udpSocket.send(sendBuf, 0, sendBuf.position, c.ip, c.port);
			trace("请求重发数据包:", retryArr);
		}

		/**
		 * 发送网络状态  S_NETSTATUE
		 */
		private function sendNetStatue(c:UdpSendClientData, dt:int):void
		{
			sendBuf.position=2;
			sendBuf.writeByte(UdpMessageConst.S_NETSTATUE);
			sendBuf.writeInt(c.gramNumArr[UdpSendClientData.RECORD_NUM - 1]); //数据块数
			sendBuf.writeInt(dt); //时间差 ms
//			sendBuf.writeInt(c.rcvAllGram / c.rcvAllTime / 1000);		//发送文件的平均速度 总包数/总时间
			udpSocket.send(sendBuf, 0, sendBuf.position, c.ip, c.port);
//			trace("发送状态：", c.gramNumArr[UdpSendClient.RECORD_NUM - 1], dt);
		}

		/**
		 * 文件接收完毕消息
		 * @param udpSocket
		 * @param c
		 */
		private function sendRcvComplete(c:UdpSendClientData):void
		{
			sendBuf.position=2;
			sendBuf.writeByte(UdpMessageConst.S_COMPLETE); // 文件接收完毕
			sendBuf.writeUnsignedInt(_msgId); // 消息序号
			udpSocket.send(sendBuf, 0, sendBuf.position, c.ip, c.port);
		}


		public function dispose():void
		{
			if (updateFileStream)
			{
				updateFileStream.close();
				updateFileStream=null;
			}

			for each (var c:UdpSendClientData in usableClients)
			{
				c.reset();
			}
			usableClients=null;
		}
	}
}

