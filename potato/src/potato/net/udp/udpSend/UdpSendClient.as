package potato.net.udp.udpSend
{
	import flash.utils.ByteArray;
	
	import core.net.UdpSocket;
	
	import potato.net.udp.manager.UdpDataManager;
	import potato.net.udp.udpConfig.UdpConfig;
	import potato.net.udp.udpConst.UdpMessageConst;
	import potato.net.udp.vo.UdpReSendVo;

	/**
	 *向客户端发送消息 
	 * @author sunchao
	 * 
	 */
	public class UdpSendClient
	{
		private var _udpSocket:UdpSocket;
		private var _resendCyc:int=UdpConfig.RETRY_CHECK_CYC;
		private static var MAX_RESEND_COUTN:int = 5;//重发的最大次数
		public function UdpSendClient($udpSocket:UdpSocket)
		{
			_udpSocket = $udpSocket;
		}
		/**
		 * 尝试重发消息
		 */
		public function reSend():void
		{
			if (--_resendCyc > 0)
				return;
			for each (var vo:UdpReSendVo in UdpDataManager.getInstance().udpReSendData.reSendDic)
			{
				if (vo != null)
				{
					vo.resendCyc-=UdpConfig.RETRY_CHECK_CYC;
					if (vo.resendCyc <= 0)
					{
						if (vo.isResend)
						{
							if(vo.resendCnt >= MAX_RESEND_COUTN)
							{
								UdpDataManager.getInstance().udpReSendData.deleteReSendDic(vo.cmd);
								return;
							}
							_udpSocket.send(vo.bytes, vo.offset, vo.length, vo.address, vo.port);
							vo.resendCyc=UdpConfig.retryCyc;
							vo.resendCnt++;
							trace("重发次数:"+vo.resendCnt+"=cmd="+vo.cmd+"=address="+vo.address+"=port="+vo.port);
						} 
						else 
						{
							UdpDataManager.getInstance().udpReSendData.deleteReSendDic(vo.cmd);
						}
					}
				}
			}
			_resendCyc=UdpConfig.RETRY_CHECK_CYC;
		}
		/**
		 * 发送文件连接返回消息 
		 * @param msgId		
		 * @param succId	
		 * @param url
		 * @param fileSize
		 * @param address
		 * @param port
		 * 
		 */
		public function sendRgetfile(msgId:int,succId:int,url:String,fileSize:int,address:String,port:int):void
		{
			var sendBuf:ByteArray=new ByteArray();
			sendBuf.writeByte(UdpConfig.HEXS); 			  // S
			sendBuf.writeByte(UdpConfig.HEXF); 			  // F
			sendBuf.writeByte(UdpMessageConst.R_GETFILE); // 请求发送文件连接返回消息
			sendBuf.writeUnsignedInt(msgId); 			  // 消息序号
			sendBuf.writeInt(succId);					  //结果，成功为0，其他都为错误号
			sendBuf.writeUTF(url);						  //文件url
			sendBuf.writeInt(fileSize);					  //文件字节大小
			_udpSocket.send(sendBuf, 0, 0, address, port);
			
			trace("请求发送文件连接返回消息"+"=msgId="+msgId+"=succId="+succId+"=url="+url+"=size="+fileSize+"=对方ip="+address+"=对方port="+port);
		}
	}
}