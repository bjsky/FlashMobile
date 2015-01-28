package potato.net.udp.udpData
{
	import flash.utils.Dictionary;
	
	import core.net.UdpSocket;
	
	import potato.net.udp.udpFile.UdpRcvFile;

	/**
	 *文件数据 
	 * @author sunchao
	 * 
	 */
	public class UdpFileData
	{
		private var _loadFileDic:Dictionary = new Dictionary();
		
		public function UdpFileData()
		{
		}

		public function get loadFileDic():Dictionary
		{
			return _loadFileDic;
		}

		public function set loadFileDic(value:Dictionary):void
		{
			_loadFileDic = value;
		}
		/**
		 * 需要下载的文件下载文件
		 * @param msgId		
		 * @param url		
		 * @param md5
		 * @param udpSocket
		 * 
		 */
		public function addNeedDownLoadFile(msgId:int,url:String, md5:String,udpSocket:UdpSocket):void
		{
			trace("need Download file:"+"=msgId="+msgId+"=url="+url+"=md5="+md5);
			if (_loadFileDic[msgId] == null)
			{
				_loadFileDic[msgId]=new UdpRcvFile(url, md5, msgId, udpSocket);
			}
		}
	}
}