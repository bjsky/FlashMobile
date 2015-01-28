package potato.net.udp.manager
{
	import potato.net.udp.udpData.UdpClientData;
	import potato.net.udp.udpData.UdpFileData;
	import potato.net.udp.udpData.UdpReSendData;

	/**
	 *udp数据管理中心 
	 * @author sunchao
	 * 
	 */
	public class UdpDataManager
	{
		private static var _instance:UdpDataManager;
		
		private var _udpClientData:UdpClientData = new UdpClientData();	//服务器返回的所有客户端数据
		private var _udpFileData:UdpFileData = new UdpFileData();		//文件数据
		private var _udpReSendData:UdpReSendData = new UdpReSendData(); //需要重新发送的数据
		public function UdpDataManager(single:Singletoner)
		{
			if(!single)
			{
				throw("udpDataManager create faile")
			}
		}

		public function get udpReSendData():UdpReSendData
		{
			return _udpReSendData;
		}

		public function set udpReSendData(value:UdpReSendData):void
		{
			_udpReSendData = value;
		}

		public function get udpFileData():UdpFileData
		{
			return _udpFileData;
		}

		public function set udpFileData(value:UdpFileData):void
		{
			_udpFileData = value;
		}

		public function get udpClientData():UdpClientData
		{
			return _udpClientData;
		}

		public function set udpClientData(value:UdpClientData):void
		{
			_udpClientData = value;
		}

		public static function getInstance():UdpDataManager
		{
			if(_instance == null)
			{
				_instance = new UdpDataManager(new Singletoner());
			}
			return _instance;
		}
	}
}
internal class Singletoner
{
	
}