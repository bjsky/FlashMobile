package potato.net.udp.udpRcv
{
	import flash.utils.ByteArray;
	
	import core.net.UdpSocket;
	
	import potato.net.udp.manager.UdpDataManager;
	import potato.net.udp.udpConfig.UdpConfig;
	import potato.net.udp.udpConst.UdpMessageConst;

	/**
	 *接收服务器发来的消息 
	 * @author sunchao
	 * 
	 */
	public class UdpRcvServer
	{
		private var _udpSocket:UdpSocket;
		public function UdpRcvServer($udpSocket:UdpSocket)
		{
			this._udpSocket = $udpSocket;
		}
		/**
		 *收服务发来的消息 
		 * 
		 */
		public function rcvServer(cmd:int,len:int,rcvBuf:ByteArray):void
		{
			switch(cmd)
			{
				case UdpMessageConst.R_LOGIN:
					getClientListFromServer(rcvBuf);
					UdpDataManager.getInstance().udpReSendData.deleteReSendDic(cmd);
					break;
				case UdpMessageConst.R_GETSHARE:
					trace("兑换共享奖励返回消息");
					break;
				default:
//					trace("server error cmd:", cmd);
					break;
			}
		}
		/**
		 * 推荐的连接客户端列表
		 */
		private function getClientListFromServer(rcvBuf:ByteArray):void
		{
			var rid:uint=rcvBuf.readUnsignedInt();
			if (!UdpDataManager.getInstance().udpReSendData.reSendDic[UdpMessageConst.R_LOGIN] || UdpDataManager.getInstance().udpReSendData.reSendDic[UdpMessageConst.R_LOGIN].msgId != rid)
			{
				return;
			}
			UdpConfig.chunkSize=rcvBuf.readInt();
			UdpConfig.uid=rcvBuf.readInt();
			var cnum:int=rcvBuf.readByte();
			for (var i:int=0; i < cnum; i++)
			{
				var ip:String=rcvBuf.readUTF();
				var port:int=rcvBuf.readUnsignedShort();
				var uid:uint=rcvBuf.readUnsignedInt();
				var upSpeed:int=rcvBuf.readInt();
				UdpDataManager.getInstance().udpClientData.addClient(ip, port, uid, upSpeed);
			}
			UdpConfig.status=UdpConfig.ST_UDP_READY;
			trace("推荐的连接客户端列表："+cnum);
		}
	}
}