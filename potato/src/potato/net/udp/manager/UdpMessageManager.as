package potato.net.udp.manager
{
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import core.net.UdpSocket;
	import core.system.System;
	
	import potato.net.udp.udpConfig.UdpConfig;
	import potato.net.udp.udpRcv.UdpRcvClient;
	import potato.net.udp.udpRcv.UdpRcvServer;
	import potato.net.udp.udpSend.UdpSendClient;
	import potato.net.udp.udpSend.UdpSendServer;

	/**
	 *消息管理类 
	 * @author sunchao
	 * 
	 */
	public class UdpMessageManager
	{
		private static var _instance:UdpMessageManager;
		
		private var _rcvBuf:ByteArray = new ByteArray(); 						//接收数据byteArray
		private var _udpSocket:UdpSocket = new UdpSocket();						//udp sockte链接
		private var _udpRcvClient:UdpRcvClient = new UdpRcvClient(_udpSocket);	//收客户端消息
		private var _udpRcvServer:UdpRcvServer = new UdpRcvServer(_udpSocket);	//收服务器消息
		private var _udpSendServer:UdpSendServer = new UdpSendServer(_udpSocket);//向服务器发消息
		private var _udpSendClient:UdpSendClient = new UdpSendClient(_udpSocket);//向客户端发消息
		
		public function UdpMessageManager(single:Singletoner)
		{
			if(!single)
			{
				throw("udpMessageManager create error")
			}
		}

		public function get udpRcvClient():UdpRcvClient
		{
			return _udpRcvClient;
		}

		public function set udpRcvClient(value:UdpRcvClient):void
		{
			_udpRcvClient = value;
		}

		public function get udpRcvServer():UdpRcvServer
		{
			return _udpRcvServer;
		}

		public function set udpRcvServer(value:UdpRcvServer):void
		{
			_udpRcvServer = value;
		}

		public function get udpSendServer():UdpSendServer
		{
			return _udpSendServer;
		}

		public function set udpSendServer(value:UdpSendServer):void
		{
			_udpSendServer = value;
		}

		public function get udpSendClient():UdpSendClient
		{
			return _udpSendClient;
		}

		public function set udpSendClient(value:UdpSendClient):void
		{
			_udpSendClient = value;
		}

		public static function getInstance():UdpMessageManager
		{
			if(_instance == null)
			{
				_instance = new UdpMessageManager(new Singletoner());
			}
			return _instance;
		}
		/**
		 *绑定ip和端口 
		 * @param localPort
		 * @param localAddress
		 * 
		 */
		public function bind(localPort:int=0,localAddress:String = "0.0.0.0"):void
		{
			_udpSocket.bind(localPort);
		}
		/**
		 *收消息 
		 * 
		 */
		private function receiveMessage():void
		{
			var sleep:int;
			var startTime:uint=getTimer();
			var endTime:uint;
			while (true)
			{
				readMessage(); 			//接收消息
				_udpSendClient.reSend();//重发判断
				fileLoop();
				
				endTime=getTimer();
				sleep=UdpConfig.SLEEP - (endTime - startTime);
				if (sleep <= 0)
					sleep=1;
				startTime=endTime;
				
				System.sleep(sleep);
			}
		}
		/**
		 *读取消息 
		 * 
		 */
		private function readMessage():void
		{
			var r:int;
			do
			{
				r=_udpSocket.receive(_rcvBuf);
				
				if(r<0)return;
				
				_rcvBuf.position=0;
				// 消息俩个字节头SF，一个字节cmd，4字节消息id
				if (r > 6 && _rcvBuf.readByte() == UdpConfig.HEXS && _rcvBuf.readByte() == UdpConfig.HEXF)
				{
					rcvHandler(r - 2);
				}
			} 
			while (r > 0);
		}
		/**
		 *文件的发送和接收 
		 * 
		 */
		private function fileLoop():void
		{
			_udpRcvClient.sendFileLoop(); //作为发送端  	循环处理
			_udpRcvClient.rcvFileLoop();  //作为接收端    循环处理
		}
		/**
		 * 接收消息处理
		 */
		private function rcvHandler(len:int):void
		{
			var cmd:int=_rcvBuf.readByte();
			len--;
			trace("===消息==="+cmd);
			_udpRcvServer.rcvServer(cmd,len,_rcvBuf);//收服务器消息
			_udpRcvClient.rcvClient(cmd,len,_rcvBuf);//收客户端消息
		}
		/**
		 *临时的  可能会修改 
		 * @param url
		 * @param md5
		 * 
		 */
		public function startConnect(url:String, md5:String):void
		{
			bind(UdpConfig.localPort);
			_udpSendServer.sendLogin();
			UdpDataManager.getInstance().udpFileData.addNeedDownLoadFile(5,url,md5,_udpSocket);
			receiveMessage();
		}
	}
}
internal class Singletoner
{
	
}