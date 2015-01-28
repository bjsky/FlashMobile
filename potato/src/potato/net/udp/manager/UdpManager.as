package potato.net.udp.manager
{
	/**
	 *udp管理类 
	 * @author sunchao
	 * 
	 */
	public class UdpManager
	{
		private static var _instance:UdpManager;
		public function UdpManager(single:Singletoner)
		{
			if(!single)
			{
				throw new Error("UdpManager singletoner create failed");
			}
		}
		public static function getInstance():UdpManager
		{
			if(_instance == null)
			{
				_instance = new UdpManager(new Singletoner());
			}
			return _instance;
		}
	}
}
internal class Singletoner{
	
}