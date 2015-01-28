package potato.net.udp.udpConst
{
	public class UdpMessageOrderConst
	{
		/**
		 *登陆序号 
		 */
		public static var LOGIN_MSG:int = msgId;
		
		private static var _msgId:int =0;
		
		public static function get msgId():int
		{
			return _msgId++;
		}
	}
}