package potato.net.udp.udpRcv
{
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import core.net.UdpSocket;
	
	import potato.net.udp.manager.UdpDataManager;
	import potato.net.udp.manager.UdpMessageManager;
	import potato.net.udp.udpConfig.UdpConfig;
	import potato.net.udp.udpConst.UdpMessageConst;
	import potato.net.udp.udpData.UdpRcvClientData;
	import potato.net.udp.udpData.UdpSendClientData;
	import potato.net.udp.udpFile.UdpRcvFile;
	import potato.net.udp.udpFile.UdpSendFile;

	/**
	 *接收客户端发来的消息 
	 * @author sunchao
	 * 
	 */
	public class UdpRcvClient
	{
		private var _udpSocket:UdpSocket;
		private var _currSendFile:UdpSendFile;
		private var _currRcvClientData:UdpRcvClientData;
		private var _rcvFileLoopCyc:int=16; 							//循环周期
		private var _loadFileNum:int=0; 								//并行下载的文件数
		private const LOAD_FILE_NUM_MAX:int = 1;						//并行下载的最大文件数
		public function UdpRcvClient($udpSocket:UdpSocket)
		{
			this._udpSocket = $udpSocket;
		}
		/**
		 *收客户端发来的消息 
		 * 
		 */
		public function rcvClient(cmd:int,len:int,rcvBuf:ByteArray):void
		{
			switch(cmd)
			{
				case UdpMessageConst.R_GETDATA://文件数据
					fileDataFromSend(len,rcvBuf);
					break;
				case UdpMessageConst.R_GETFILE: //请求发送文件连接返回消息
					getFileFromSend(rcvBuf);
					break;
				case UdpMessageConst.S_GETFILE://请求发送文件连接
					getFileFromRcv(rcvBuf);
					break;
				case UdpMessageConst.S_GETDATA://请求发送数据
					fileDataFromRcv(rcvBuf);
					break;
				case UdpMessageConst.S_NETSTATUE://发送网络状态
					netStatueRcv(rcvBuf);
					break;
				case UdpMessageConst.S_RETRYGETDATA://请求重发数据
					retryGetData(rcvBuf);
					break;
				case UdpMessageConst.S_COMPLETE://文件接收完毕
					fileComplete(rcvBuf);
					break;
				default:
//					trace("client error cmd:", cmd);
					break;
			}
				
		}
		/**
		 * 接收传送来的数据包， 并保存到响应的文件中  R_GETDATA
		 */
		private function fileDataFromSend(len:int,rcvBuf:ByteArray):void
		{
			
			var msgId:uint=rcvBuf.readUnsignedInt();
			var rcvFile:UdpRcvFile=UdpDataManager.getInstance().udpFileData.loadFileDic[msgId];
			trace("收到文件数据发送"+"=msgId="+msgId+"=rcvFile="+rcvFile+"=rcvBuf="+rcvBuf);
			if (rcvFile && rcvFile.downState == UdpRcvFile.DOWN_STATE_LOADING)
			{
				var chunkInd:int=rcvBuf.readInt();
				var packInd:int=rcvBuf.readInt();
				rcvFile.writeData(chunkInd, packInd, rcvBuf, len - 12, _udpSocket.remoteAddress + ":" + _udpSocket.remotePort);
			}
		}
		/**
		 * 请求发送文件连接返回消息  R_GETFILE
		 */
		private function getFileFromSend(rcvBuf:ByteArray):void
		{
			var msgId:uint=rcvBuf.readUnsignedInt();
			var udpRcvFile:UdpRcvFile=UdpDataManager.getInstance().udpFileData.loadFileDic[msgId];
			trace("=msgId="+msgId+"=udpRcvFile="+udpRcvFile+"=udpRcvFile.downState="+udpRcvFile.downState);
			if (udpRcvFile == null || udpRcvFile.downState == UdpRcvFile.DOWN_STATE_COMPLETE || udpRcvFile.downState == UdpRcvFile.DOWN_STATE_ERROR)
			{
				return;
			}
			var suc:int=rcvBuf.readInt();
			trace("=suc="+suc);
			if (suc > 0)
			{ 
				//有错误  1当前正在上传其他文件 2不可下载
				trace("请求发送文件连接返回消息，错误=", suc+",remoteAddress:"+_udpSocket.remoteAddress+",remotePort:"+_udpSocket.remotePort);
			}
			else
			{
				var url:String=rcvBuf.readUTF();
				var fileSize:int=rcvBuf.readInt();
				if (udpRcvFile!=null)
				{
					if(udpRcvFile.fileSize == 0 && udpRcvFile.url == url)
					{
						udpRcvFile.fileSize=fileSize;
					}
				}
				for each (var clt:UdpSendClientData in UdpDataManager.getInstance().udpClientData.clientList)
				{
					clt.rcvAllGram++;
					
					if (clt.statue == UdpSendClientData.STATE_REQUEST && clt.ip == _udpSocket.remoteAddress && clt.port == _udpSocket.remotePort && udpRcvFile.usableClients[clt.address] == null)
					{
						udpRcvFile.usableClients[clt.address]=clt;
						trace("收到请求发送文件链接返回"+"=url="+url+"=fileSize="+fileSize+"=ip="+clt.address+"=port="+clt.port);
					}
				}
				
				// 请求发送数据
				if (udpRcvFile.downState == UdpRcvFile.DOWN_STATE_READY)
				{
					udpRcvFile.startDown();
				}
			}
			
		}
		/**
		 * 处理接收到的“请求发送文件连接”消息    S_GETFILE
		 */
		private function getFileFromRcv(rcvBuf:ByteArray):void
		{
			var errid:int=0;
			var fileSize:int = 0;
			var sdf:UdpSendFile;
			var msgId:uint=rcvBuf.readUnsignedInt();
			if (_currSendFile)
			{
				// 当前正在上传其他文件
				errid=1;
			}
			else
			{
				var gameid:String=rcvBuf.readUTF();
				var shareFlag:int=rcvBuf.readByte();
				var url:String=rcvBuf.readUTF();
				var md5:String=rcvBuf.readUTF();
				sdf=new UdpSendFile(url, md5, msgId);
				fileSize = sdf.fileSize;
				if (!sdf.isLoadable)//不能下载 md5不一样？
				{
					errid=2;
				}
			}
			
			trace("收到发送文件连接"+"==msgId=="+msgId+"==url=="+url+"==md5=="+md5+"==gameid=="+gameid+"==shareFlag=="+shareFlag+"==errid=="+errid);
			
			UdpDataManager.getInstance().udpReSendData.deleteReSendDic(UdpMessageConst.S_GETFILE);
			
			if (errid == 0)
			{
				_currSendFile=sdf;
				if (_currRcvClientData == null || _udpSocket.remoteAddress != _currRcvClientData.address || _udpSocket.remotePort != _currRcvClientData.port)
				{
					_currRcvClientData=new UdpRcvClientData(_udpSocket.remoteAddress, _udpSocket.remotePort);
				}
			}
			
			UdpMessageManager.getInstance().udpSendClient.sendRgetfile(msgId,errid,url,fileSize,_udpSocket.remoteAddress, _udpSocket.remotePort);
			
		}
		/**
		 * 处理接收到的“请求发送数据”消息   S_GETDATA
		 */
		private function fileDataFromRcv(rcvBuf:ByteArray):void
		{
			var msgId:uint=rcvBuf.readUnsignedInt();
			var url:String=rcvBuf.readUTF();
			if (_currSendFile == null || url != _currSendFile.url)
			{
				//请求的数据有问题
				//TODO 返回错误消息 
				return;
			}
			var chunkNum:int=rcvBuf.readInt();
			var chunkArr:Vector.<int>=_currSendFile.sendChunkIds;
			// 只标记发送的数据信息， 实际的发送在帧循环中
			var len:int=chunkArr.length + chunkNum;
			for (var i:int=chunkArr.length; i < len; i++)
			{
				chunkArr[i]=rcvBuf.readInt();
				//				chunkArr.push(rcvBuf.readInt());
			}
			// 只标记发送的数据信息， 实际的发送在帧循环中
			//			currSendFile.sendChunkIds.concat(chunkArr);
			_currSendFile.lastReqTime=getTimer();
			trace("收到发送数据请求"+"=msgId="+msgId+"=chunkArr="+chunkArr+"=remoteAddress="+_udpSocket.remoteAddress+"=port="+_udpSocket.remotePort);
		}
		/**
		 * 根据客户端接收网速调整发送速度    S_GETFILE
		 */
		private function netStatueRcv(rcvBuf:ByteArray):void
		{
			var gramNum:int=rcvBuf.readInt(); //上一段时间接收到的包数
			var dt:Number=rcvBuf.readInt() / 1000.0; //上一时间段
			
			if (_currRcvClientData.lastRcvTime > 0)
			{
				_currRcvClientData.rcvGramArr.push(gramNum);
				_currRcvClientData.rcvTimeArr.push(dt);
				//8秒内的平均速度
				_currRcvClientData.totalGram+=gramNum;
				_currRcvClientData.totalTime+=dt;
				_currRcvClientData.totalGram-=_currRcvClientData.rcvGramArr.shift();
				_currRcvClientData.totalTime-=_currRcvClientData.rcvTimeArr.shift();
				
				var sendGain:int =_currRcvClientData.gps * 0.2;
				_currRcvClientData.gps=_currRcvClientData.totalGram / _currRcvClientData.totalTime + sendGain;
			}
			
			if (gramNum > 0)
				_currRcvClientData.lastRcvTime=getTimer();
			
			trace("收到网络状态", _currRcvClientData.gps, _currRcvClientData.gps / UdpConfig.sendFps + 1, gramNum, dt, _currRcvClientData.totalGram, _currRcvClientData.totalTime);
		}
		/**
		 * 接收重发请求
		 */
		private function retryGetData(rcvBuf:ByteArray):void
		{
			var rid:uint=rcvBuf.readUnsignedInt();
			trace("接收到重发请求:", rid);
			if (_currSendFile && _currSendFile.msgId == rid)
			{
				var num:int=rcvBuf.readInt();
				var chunkArr:Vector.<int>=_currSendFile.resendIds;
				var len:int=chunkArr.length + num;
				for (var i:int=chunkArr.length; i < len; i++)
				{
					chunkArr[i]=rcvBuf.readInt();
				}
				
				_currSendFile.lastReqTime=getTimer();
			}
		}
		/**
		 * 文件接收完成消息
		 */
		private function fileComplete(rcvBuf:ByteArray):void
		{
			var rid:uint=rcvBuf.readUnsignedInt();
			trace("文件接收完成消息:","==rid==", rid);
			if (_currSendFile && _currSendFile.msgId == rid)
			{
				_currSendFile.complete();
				_currSendFile=null;
			}
		}
		/**
		 * 循环发送文件数据，要限制发送速度
		 */
		public function sendFileLoop():void
		{
			//发送
			if (_currSendFile && _currSendFile.sendChunkIds != null)
			{
				//计算本次应发udp包数量
				var sendGramNum:int=_currRcvClientData.gps / UdpConfig.sendFps + 1; // +1可以保证速度不会降到0
				//				trace("发送数据率："+sendGramNum);
				_currSendFile.sendDatagram(_udpSocket, _currRcvClientData, sendGramNum);
			}
		}
		/**
		 *接收文件 
		 * 
		 */
		public function rcvFileLoop():void
		{
			if (--_rcvFileLoopCyc > 0)
				return;
			for each (var file:UdpRcvFile in UdpDataManager.getInstance().udpFileData.loadFileDic)
			{
				switch (file.downState)
				{
					case UdpRcvFile.DOWN_STATE_LOADING: //正在下载
						//TODO 下载该文件可用的客户端数少于3时，则增加
						//开启新的下载区域
						file.handleLoop();
						//						trace("正在下载");
						break;
					case UdpRcvFile.DOWN_STATE_COMPLETE: //下载完成
						_loadFileNum--;
						delete UdpDataManager.getInstance().udpFileData.loadFileDic[file.msgId];
						//TODO 通知主线程下载完成
						trace("下载完：", file.url);
						file.dispose();
						break;
					case UdpRcvFile.DOWN_STATE_READY://准备下载
						if (_loadFileNum < LOAD_FILE_NUM_MAX)
						{ 
							for each (var clt:UdpSendClientData in UdpDataManager.getInstance().udpClientData.clientList)
							{
								if (clt.statue == UdpSendClientData.STATE_READY)
								{
									trace("准备下载新文件：", file.url);
									file.sendGetFile(clt);
									_loadFileNum++;
									clt.statue=UdpSendClientData.STATE_REQUEST; //正在发送下载请求
									clt.lastReqTime=getTimer();
									clt.reqAllGram++;
									break; //每次只开启一个
								}
							}
						}
						//这里进行打洞  
						break;
				}
			}
			_rcvFileLoopCyc=15;
		}
	}
}