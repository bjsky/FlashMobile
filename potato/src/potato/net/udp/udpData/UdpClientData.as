package potato.net.udp.udpData
{
	import flash.utils.Dictionary;

	/**
	 *客户端数据 
	 * @author sunchao
	 * 
	 */
	public class UdpClientData
	{
		private var _clientList:Dictionary=new Dictionary(); 	//推荐的下载客户端列表
		
		public function UdpClientData()
		{
		}
		public function get clientList():Dictionary
		{
			return _clientList;
		}
		
		public function set clientList(value:Dictionary):void
		{
			_clientList = value;
		}
		/**
		 * 添加客户端
		 * @param ip
		 * @param port
		 * @param uid
		 */
		public function addClient(ip:String, port:int, uid:int, upSpeed:int):void
		{
			var address:String=ip + ":" + port;
			if (_clientList[address] == null)
			{
				//已有的就不加
				var client:UdpSendClientData=new UdpSendClientData(ip, port, uid, upSpeed);
				_clientList[address]=client;
			}
		}
		
		/**
		 *删除一个客户端 
		 * @param c
		 * 
		 */
		public function delClient(client:UdpSendClientData):void
		{
			delete _clientList[client.address];
		}
	}
}