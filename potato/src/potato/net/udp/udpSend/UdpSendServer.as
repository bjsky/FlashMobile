package potato.net.udp.udpSend
{
	import flash.utils.ByteArray;
	
	import core.net.UdpSocket;
	
	import potato.net.udp.manager.UdpDataManager;
	import potato.net.udp.udpConfig.UdpConfig;
	import potato.net.udp.udpConst.UdpMessageConst;
	import potato.net.udp.udpConst.UdpMessageOrderConst;

	/**
	 *向服务器发送消息 
	 * @author sunchao
	 * 
	 */
	public class UdpSendServer
	{
		private var _udpSocket:UdpSocket;
		public function UdpSendServer($udpSocket:UdpSocket)
		{
			_udpSocket = $udpSocket;
		}
		
		/**
		 *想服务器发送登陆请求 
		 * @param udpSocket
		 * 
		 */
		public function sendLogin():void
		{
			var msgId:int = UdpMessageOrderConst.LOGIN_MSG;
			var ba:ByteArray=new ByteArray();
			ba.writeByte(UdpConfig.HEXS); 			//S消息头
			ba.writeByte(UdpConfig.HEXF); 			//F消息头
			ba.writeByte(UdpMessageConst.S_LOGIN);  //客户端登录
			ba.writeUnsignedInt(msgId); 			//消息序号
			ba.writeUTF(UdpConfig.userid);			//用户id
			ba.writeUTF(UdpConfig.gameid);			//游戏id
			ba.writeUTF(UdpConfig.oxver);			//系统版本
			ba.writeUTF(UdpConfig.restype);			//资源类型
			ba.writeUTF(UdpConfig.resVer);			//资源版本
			ba.writeByte(UdpConfig.downCom);		//资源更新下载的完成度
			ba.writeByte(UdpConfig.shareFlag);		//共享资源标记
			ba.writeShort(UdpConfig.upGramSpeed);	//上传最大速度（K）
			
			_udpSocket.send(ba, 0, 0, UdpConfig.serverIp, UdpConfig.serverPort);
			
			//记录
			UdpDataManager.getInstance().udpReSendData.addReSendDic(UdpMessageConst.R_LOGIN,msgId,ba, 0, 0, UdpConfig.serverIp, UdpConfig.serverPort);
			
			trace("发送登陆请求");
			
		}
	}
}