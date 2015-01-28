package potato.net.udp.udpData
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import potato.net.udp.udpConfig.UdpConfig;
	import potato.net.udp.vo.UdpReSendVo;

	/**
	 *延时的时候 需要重新发送的数据 
	 * @author sunchao
	 * 
	 */
	public class UdpReSendData
	{
		private var _reSendDic:Dictionary = new Dictionary();
		public function UdpReSendData()
		{
		}

		public function get reSendDic():Dictionary
		{
			return _reSendDic;
		}

		public function set reSendDic(value:Dictionary):void
		{
			_reSendDic = value;
		}

		/**
		 *添加需要重发的数据 
		 * @param ip
		 * @param port
		 * @param cmd
		 * @param msgId
		 * @param data
		 * 
		 */
		
		public function addReSendDic(cmd:int,msgId:int,bytes:ByteArray,offset:uint,length:int,address:String,port:int):void
		{
			var vo:UdpReSendVo=new UdpReSendVo(cmd,msgId,bytes,offset,length,address,port);
			vo.resendCyc=UdpConfig.retryCyc;
			vo.isResend=true;
			_reSendDic[cmd]=vo;
		}
		public function deleteReSendDic(cmd:int):void
		{
			_reSendDic[cmd]=null;
			delete _reSendDic[cmd];
		}
	}
}