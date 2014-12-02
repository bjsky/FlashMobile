package potato.utils
{
	public class UrlInfo
	{
		public function UrlInfo()
		{
		}
		
		public static function parseUrl(url:String):UrlInfo{
			var info:UrlInfo=new UrlInfo();
			info.url=url;
			info.name=url.replace(/.*(\/|\\)/, "");
			if(/[.]/.exec(info.name))
				info.extension=/[^.]+$/.exec(info.name.toLowerCase());
			else
				info.extension="";
			return info;
		}
		
		
		private var _url:String;
		private var _name:String;
		private var _extension:String;

		/**
		 * 扩展名 
		 * @return 
		 * 
		 */
		public function get extension():String
		{
			return _extension;
		}

		public function set extension(value:String):void
		{
			_extension = value;
		}

		/**
		 * 文件名 
		 * @return 
		 * 
		 */
		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		/**
		 * 路径 
		 * @return 
		 * 
		 */
		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}

	}
}