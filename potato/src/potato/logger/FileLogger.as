package potato.logger
{
	import core.filesystem.File;
	
	/**
	 * 文件日志
	 * Jun 11, 2012
	 */
	public class FileLogger implements ILogWriter
	{
		private var log:String = "";
		
		private const LOGO_PATH:String = "log.txt";
		
		
		public function FileLogger()
		{
//			if(File.exists(LOGO_PATH))
//			{
//				log = File.read(LOGO_PATH);
//			}
			
		}
		
		public function print(msg:String):void
		{
			log = log + msg + "\n";
			File.write(LOGO_PATH, log);
//			trace(msg);///
			
		}
	}
}