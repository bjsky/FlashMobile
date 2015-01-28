package potato.net.udp.udpLoader
{
	

	public class UdpLoader
	{
		/**
		 * 接收端处理循环
		 * 1. 去除废弃的客户端
		 * 2. 遍历所有要下载的文件，发送数据传输请求
		 * 3. 判断是否开启新文件下载
		 * 4. 处理下载完成的文件，并发送完成消息
		 */
		
		
//		private var _rcvBuf:ByteArray = new ByteArray(); 						//接收数据byteArray
//		private var _udpSocket:UdpSocket = new UdpSocket();						//udp sockte链接
//		private var _udpRcvClient:UdpRcvClient = new UdpRcvClient(_udpSocket);	//收客户端消息
//		private var _udpRcvServer:UdpRcvServer = new UdpRcvServer(_udpSocket);	//收服务器消息
//		private var _udpSendServer:UdpSendServer = new UdpSendServer(_udpSocket);//向服务器发消息
//		private var _udpSendClient:UdpSendClient = new UdpSendClient(_udpSocket);//向客户端发消息
//		private var _currRcvClientData:UdpRcvClientData; 						 //当前接收文件的客户端
//		private var _currSendFile:UdpSendFile; 									 //当前正在上传的文件
//		private var _rcvFileLoopCyc:int=16; 									 //循环周期
//		private var _loadFileNum:int=0; 										 //并行下载的文件数
//		private var _resendCyc:int=UdpConfig.RETRY_CHECK_CYC;
		public function UdpLoader()
		{
//			_udpSocket.bind(UdpConfig.localPort);
		}
		/**
		 * 文件传输相关的消息处理
		 */
//		private function rcv(cmd:int, len:int):void
//		{
//			switch (cmd)
//			{
//				/////////////// 作为接收端，接收请求命令的返回消息 /////////////////
////				case UdpMessageConst.R_GETDATA:
////					fileDataFromSend(len);
////					break;
//				case UdpMessageConst.R_GETFILE: //接收到文件数据
////					getFileFromSend();
//					break;
//				//////////////// 作为发送端，接收请求发送命令 ///////////////
//				case UdpMessageConst.S_GETFILE:
////					getFileFromRcv();
//					break;
//				case UdpMessageConst.S_GETDATA:
////					fileDataFromRcv();
//					break;
//				case UdpMessageConst.S_NETSTATUE:
////					netStatueRcv();
//					break;
//				case UdpMessageConst.S_RETRYGETDATA:
////					retryGetData();
//					break;
//				case UdpMessageConst.S_COMPLETE:
//					fileComplete();
//					break;
//				default:
//					trace("Error cmd:", cmd);
//					break;
//			}
//		}

//		/**
//		 * 文件接收完成消息
//		 */
//		private function fileComplete():void
//		{
//			var rid:uint=rcvBuf.readUnsignedInt();
//			trace("文件接收完成消息:","==rid==", rid);
//			if (_currSendFile && _currSendFile.msgId == rid)
//			{
//				_currSendFile.complete();
//				_currSendFile=null;
//			}
//		}

//		/**
//		 * 处理接收到的“请求发送数据”消息   S_GETDATA
//		 */
//		private function fileDataFromRcv():void
//		{
//			var rid:uint=rcvBuf.readUnsignedInt();
//			var url:String=rcvBuf.readUTF();
//			if (_currSendFile == null || url != _currSendFile.url)
//			{
//				//请求的数据有问题
//				//TODO 返回错误消息 
//				return;
//			}
//			var chunkNum:int=rcvBuf.readInt();
//			var chunkArr:Vector.<int>=_currSendFile.sendChunkIds;
//			//// 只标记发送的数据信息， 实际的发送在帧循环中
//			var len:int=chunkArr.length + chunkNum;
//			for (var i:int=chunkArr.length; i < len; i++)
//			{
//				chunkArr[i]=rcvBuf.readInt();
////				chunkArr.push(rcvBuf.readInt());
//			}
//			// 只标记发送的数据信息， 实际的发送在帧循环中
////			currSendFile.sendChunkIds.concat(chunkArr);
//			_currSendFile.lastReqTime=getTimer();
//			trace("收到发送数据请求"+"=rid="+rid+"=chunkArr="+chunkArr+"=remoteAddress="+udpSocket.remoteAddress+"=port="+udpSocket.remotePort);
//		}

//		/**
//		 * 接收传送来的数据包， 并保存到响应的文件中  R_GETDATA
//		 */
//		private function fileDataFromSend(len:int):void
//		{
//			
//			var rid:uint=rcvBuf.readUnsignedInt();
//			var rcvFile:UdpRcvFile=UdpDataManager.getInstance().udpFileData.loadFileDic[rid];
//			trace("收到文件数据发送"+"=rid="+rid+"=rcvFile="+rcvFile);
//			if (rcvFile && rcvFile.downState == UdpRcvFile.DOWN_STATE_LOADING)
//			{
//				var chunkInd:int=rcvBuf.readInt();
//				var packInd:int=rcvBuf.readInt();
//				rcvFile.writeData(chunkInd, packInd, rcvBuf, len - 12, udpSocket.remoteAddress + ":" + udpSocket.remotePort);
//			}
//		}

//		/**
//		 * 处理接收到的“请求发送文件连接”消息    S_GETFILE
//		 */
//		private function getFileFromRcv():void
//		{
//			var errid:int=0;
//			var sdf:UdpSendFile;
//			var rid:uint=rcvBuf.readUnsignedInt();
//			if (_currSendFile)
//			{
//				// 当前正在上传其他文件
//				errid=1;
//			}
//			else
//			{
//				var gameid:String=rcvBuf.readUTF();
//				var shareFlag:int=rcvBuf.readByte();
//				var url:String=rcvBuf.readUTF();
//				var md5:String=rcvBuf.readUTF();
//				sdf=new UdpSendFile(url, md5, rid);
//				if (!sdf.isLoadable)//不能下载 md5不一样？
//				{
//					errid=2;
//				}
//			}
//
//			trace("收到发送文件连接"+"==rid=="+rid+"==url=="+url+"==md5=="+md5+"==gameid=="+gameid+"==shareFlag=="+shareFlag+"==errid=="+errid);
//
//			// 发送文件连接返回消息
//			var ba:ByteArray=new ByteArray();
//			ba.writeByte(UdpConfig.HEXS); // S
//			ba.writeByte(UdpConfig.HEXF); // F
//			ba.writeByte(UdpMessageConst.R_GETFILE); // 请求发送文件连接返回消息
//			ba.writeUnsignedInt(rid); // 消息序号
//			ba.writeInt(errid);
//			if (errid == 0)
//			{
//				ba.writeUTF(sdf.url);
//				ba.writeInt(sdf.fileSize);
//
//				_currSendFile=sdf;
//				if (_currRcvClientData == null || udpSocket.remoteAddress != _currRcvClientData.address || udpSocket.remotePort != _currRcvClientData.port)
//				{
//					_currRcvClientData=new UdpRcvClientData(udpSocket.remoteAddress, udpSocket.remotePort);
//				}
//			}
//			udpSocket.send(ba, 0, 0, udpSocket.remoteAddress, udpSocket.remotePort);
//			trace("发送文件连接返回消息"+"=rid="+rid+"=errid="+errid+"=url="+sdf.url+"=size="+sdf.fileSize+"=ip="+udpSocket.remoteAddress+"=port="+udpSocket.remotePort);
//			
////			var sendBuf:ByteArray = new ByteArray();
////			sendBuf.writeByte(UdpConfig.HEXS); // S
////			sendBuf.writeByte(UdpConfig.HEXF); // F
////			sendBuf.writeByte(UdpMessageConst.S_HOLE); // 
////			sendBuf.writeUnsignedInt(rid); // 消息序号
////			sendBuf.writeUTF(udpSocket.remoteAddress);				   	   //请求方ip
////			sendBuf.writeShort(udpSocket.remotePort);			   	   //请求方端口
////			udpSocket.send(sendBuf, 0, 0, udpSocket.remoteAddress, udpSocket.remotePort);
//			//每次开始发送文件就重置速度
//		}

		/**
		 * 请求发送文件连接返回消息  R_GETFILE
		 */
//		private function getFileFromSend():void
//		{
//			var rid:uint=rcvBuf.readUnsignedInt();
//			var udpRcvFile:UdpRcvFile=UdpDataManager.getInstance().udpFileData.loadFileDic[rid];
//			trace("=rid="+rid+"=udpRcvFile="+udpRcvFile+"=udpRcvFile.downState="+udpRcvFile.downState);
//			if (udpRcvFile == null || udpRcvFile.downState == UdpRcvFile.DOWN_STATE_COMPLETE || udpRcvFile.downState == UdpRcvFile.DOWN_STATE_ERROR)
//			{
//				return;
//			}
//			var suc:int=rcvBuf.readInt();
//			trace("=suc="+suc);
//			if (suc > 0)
//			{ 
//				//有错误
//				//TODO 打洞等
//				trace("请求发送文件连接返回消息，错误=", suc+",remoteAddress:"+udpSocket.remoteAddress+",remotePort:"+udpSocket.remotePort);
////				delete rcvClients[udpSocket.remoteAddress + ":" + udpSocket.remotePort];
//				
//				//开始打洞
////				var sendBuf:ByteArray = new ByteArray();
////				sendBuf.writeByte(UdpConfig.HEXS); // S
////				sendBuf.writeByte(UdpConfig.HEXF); // F
////				sendBuf.writeByte(UdpMessageConst.S_HOLE); // 
////				sendBuf.writeUnsignedInt(++msgId); // 消息序号
////				sendBuf.writeUTF(udpSocket.remoteAddress);				   	   //对方ip
////				sendBuf.writeInt(udpSocket.remotePort);			   	  	 //对方端口
////				trace("msgId:"+msgId+"对方ip:"+udpSocket.remoteAddress+"对方端口:"+udpSocket.remotePort);
////				udpSocket.send(sendBuf, 0, 0, UdpConfig.serverIp, UdpConfig.serverPort);
//				
//				
////				udpRcvFile.sendHole(udpSocket.remoteAddress,udpSocket.remotePort);
//				
//			}
//			else
//			{
//				var url:String=rcvBuf.readUTF();
//				var size:int=rcvBuf.readInt();
//				if (udpRcvFile!=null)
//				{
//					if(udpRcvFile.fileSize == 0 && udpRcvFile.url == url)
//					{
//						udpRcvFile.fileSize=size;//这里做修改
//					}
//				}
//				for each (var clt:UdpSendClientData in UdpDataManager.getInstance().udpClientData.clientList)
//				{
//					clt.rcvAllGram++;
//
//					if (clt.statue == UdpSendClientData.STATE_REQUEST && clt.ip == udpSocket.remoteAddress && clt.port == udpSocket.remotePort && udpRcvFile.usableClients[clt.address] == null)
//					{
//						udpRcvFile.usableClients[clt.address]=clt;
//					}
//				}
////				rcvClients[udpSocket.remoteAddress + ":" + udpSocket.remotePort] = client;	//记录到正在使用的客户端字典
//
//				trace("请求发送文件连接返回url=", url, clt.address);
//
//				// 请求发送数据
//				if (udpRcvFile.downState == 0)
//				{
//					udpRcvFile.startDown();
//				}
//			}
//			trace("收到请求发送文件链接返回"+"=url="+url+"=size="+size+"=address="+clt.address);
//		}

		/**
		 * 根据客户端接收网速调整发送速度    S_GETFILE
		 */
//		private function netStatueRcv():void
//		{
//			var gramNum:int=rcvBuf.readInt(); //上一段时间接收到的包数
//			var dt:Number=rcvBuf.readInt() / 1000.0; //上一时间段
//
//			if (_currRcvClientData.lastRcvTime > 0)
//			{
//				_currRcvClientData.rcvGramArr.push(gramNum);
//				_currRcvClientData.rcvTimeArr.push(dt);
//				//8秒内的平均速度
//				_currRcvClientData.totalGram+=gramNum;
//				_currRcvClientData.totalTime+=dt;
//				_currRcvClientData.totalGram-=_currRcvClientData.rcvGramArr.shift();
//				_currRcvClientData.totalTime-=_currRcvClientData.rcvTimeArr.shift();
//
//				var sendGain:int =_currRcvClientData.gps * 0.2;
//				_currRcvClientData.gps=_currRcvClientData.totalGram / _currRcvClientData.totalTime + sendGain;
//			}
//
//			if (gramNum > 0)
//				_currRcvClientData.lastRcvTime=getTimer();
//
//			trace("收到网络状态", _currRcvClientData.gps, _currRcvClientData.gps / UdpConfig.sendFps + 1, gramNum, dt, _currRcvClientData.totalGram, _currRcvClientData.totalTime);
//		}
		/**
		 //		 * 接收重发请求
		 //		 */
		//		private function retryGetData():void
		//		{
		//			var rid:uint=rcvBuf.readUnsignedInt();
		//			trace("接收到重发请求:", rid);
		//			if (_currSendFile && _currSendFile.msgId == rid)
		//			{
		//				var num:int=rcvBuf.readInt();
		//				var chunkArr:Vector.<int>=_currSendFile.resendIds;
		//				var len:int=chunkArr.length + num;
		//				for (var i:int=chunkArr.length; i < len; i++)
		//				{
		//					chunkArr[i]=rcvBuf.readInt();
		//				}
		//
		//				_currSendFile.lastReqTime=getTimer();
		//			}
		//		}
//		private function rcvFileLoop():void
//		{
//			if (--_rcvFileLoopCyc > 0)
//				return;
//			for each (var file:UdpRcvFile in UdpDataManager.getInstance().udpFileData.loadFileDic)
//			{
//				switch (file.downState)
//				{
//					case UdpRcvFile.DOWN_STATE_LOADING: //正在下载
//						//TODO 下载该文件可用的客户端数少于3时，则增加
//						//开启新的下载区域
//						file.handleLoop();
////						trace("正在下载");
//						break;
//					case UdpRcvFile.DOWN_STATE_COMPLETE: //下载完成
//						_loadFileNum--;
//						delete UdpDataManager.getInstance().udpFileData.loadFileDic[file.msgId];
//						//TODO 通知主线程下载完成
//						trace("下载完：", file.url);
//						file.dispose();
//						break;
//					case UdpRcvFile.DOWN_STATE_READY://准备下载
//						if (_loadFileNum < 1)
//						{ 
//							//开启下载新文件
//							for each (var clt:UdpSendClientData in UdpDataManager.getInstance().udpClientData.clientList)
//							{
//								if (clt.statue == UdpSendClientData.STATE_READY)
//								{
//									trace("开始下载新文件：", file.url);
//									file.sendGetFile(clt);
//									_loadFileNum++;
//									clt.statue=UdpSendClientData.STATE_REQUEST; //正在发送下载请求
//									clt.lastReqTime=getTimer();
//									clt.reqAllGram++;
//									break; //每次值开启一个
//								}
//							}
//						}
//						break;
//				}
//			}
//			_rcvFileLoopCyc=15;
//		}

/////////////////////////---- 发送文件数据---- //////////////////////////////////
//		/**
//		 * 循环发送文件数据，要限制发送速度
//		 */
//		private function sendFileLoop():void
//		{
//			//发送
//			if (_currSendFile && _currSendFile.sendChunkIds != null)
//			{
//				//计算本次应发udp包数量
//				var sendGramNum:int=_currRcvClientData.gps / UdpConfig.sendFps + 1; // +1可以保证速度不会降到0
////				trace("发送数据率："+sendGramNum);
//				_currSendFile.sendDatagram(udpSocket, _currRcvClientData, sendGramNum);
//			}
//		}
		
///////////////////////// 接收文件数据完 ////////////////////////////////	
		
//		private function receive():void
//		{
//			var sleep:int;
//			var startTime:uint=getTimer();
//			var endTime:uint;
//			while (true)
//			{
//				rcvMessage(); //接收消息
////				_udpSendClient.reSend();//重发判断
//				fileLoop();
//				
//				endTime=getTimer();
//				sleep=UdpConfig.SLEEP - (endTime - startTime);
//				if (sleep <= 0)
//					sleep=1;
//				startTime=endTime;
//				
//				System.sleep(sleep);
//			}
//		}
//		private function rcvMessage():void
//		{
//			var r:int;
//			do
//			{
//				r=_udpSocket.receive(_rcvBuf);
//				
//				if(r<0)return;
//				
//				_rcvBuf.position=0;
//				// 消息俩个字节头SF，一个字节cmd，4字节消息id
//				if (r > 6 && _rcvBuf.readByte() == UdpConfig.HEXS && _rcvBuf.readByte() == UdpConfig.HEXF)
//				{
//					rcvHandler(r - 2);
//				}
//			} 
//			while (r > 0);
//		}
//		private function fileLoop():void
//		{
//			_udpRcvClient.sendFileLoop(); //作为发送端，循环处理
//			_udpRcvClient.rcvFileLoop();  //作为接收端
//		}
//		/**
//		 * 接收消息处理
//		 */
//		private function rcvHandler(len:int):void
//		{
//			var cmd:int=_rcvBuf.readByte();
//			len--;
//			
//			trace("===消息==="+cmd);
//			_udpRcvServer.rcvServer(cmd,len,_rcvBuf);//收服务器消息
//			_udpRcvClient.rcvClient(cmd,len,_rcvBuf);//收客户端消息
//			
////			if (cmd < UdpMessageConst.S_GETFILE)
////			{ 
//				
////				//udp服务器交互命令
////				UdpRcvClient.rcvClient(cmd,len,rcvBuf);//收客户端消息
////				UdpRcvServer.rcvServer(cmd,len,rcvBuf);//收服务器消息
////				switch (cmd)
////				{
////					/////////////// 从服务器接收 ///////////////
////					case UdpMessageConst.R_LOGIN:
////						UdpRcvServer.getClientListFromServer(rcvBuf);
////						trace("从服务器接收客户端列表");
////						//只要当前接收到一次列表，则清除所有历史发送记录，并重置“请求刷新推荐列表”计时
////						UdpUtils.reSendDic[cmd]=null;
////						break;
////					case UdpMessageConst.R_GETSHARE:
////						trace("兑换共享奖励返回消息");
////						break;
////					case UdpMessageConst.R_HOLE:
//////						holeFromServer();
////						break;
////					case UdpMessageConst.R_HOLEEND:
//////						holeEndFromeServer();
////						break;
////					case UdpMessageConst.S_HOLEEND:
//////						holeEndFromeClent();
////						break;
////					case UdpMessageConst.S_SEND_MESSAGE:
//////						messageHandler();
////						break;
////					default:
////						trace("Error cmd:", cmd);
////				}
////			}
////			else if (cmd < 0x40)
////			{ 
////				//文件传输	
////				rcv(cmd, len);
////			}
////			else
////			{
////				trace("主线程交互命令");
////				//主线程交互命令
////			}
//			
//		}
//		/**
//		 * 尝试重发消息，文件数据传输不使用这个
//		 */
//		private function reSend():void
//		{
//			if (--_resendCyc > 0)
//				return;
//			for each (var msg:UdpMessage in UdpUtils.reSendDic)
//			{
//				if (msg != null)
//				{
//					msg.resendCyc-=UdpConfig.RETRY_CHECK_CYC;
//					if (msg.resendCyc <= 0)
//					{
//						if (msg.isResend)
//						{
//							//TODO 重发  没有计算重发次数
//							trace("重发 ");
//							_udpSocket.send(msg.sendData, 0, 0, msg.ip, msg.port);
//							msg.resendCyc=UdpConfig.retryCyc;
//							msg.resendCnt++;
//						} 
//						//						else 
//						//						{
//						// 							//不需要重发，则直接删除。之后即使接收到响应消息，也不会处理了
//						//							sndArr[msg.msgId] = null;
//						//							delete sndArr[msg.msgId];
//						//						}
//					}
//				}
//			}
//			_resendCyc=UdpConfig.RETRY_CHECK_CYC;
//		}
//		public function startLoad(url:String, md5:String):void
//		{
//			_udpSendServer.sendLogin();
//			UdpDataManager.getInstance().udpFileData.addNeedDownLoadFile(5,url,md5,_udpSocket);
//			receive();
//		}
	}
}