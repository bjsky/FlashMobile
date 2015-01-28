package potato.editor.fileBox
{
	import core.events.Event;
	
	public class FileEvent extends Event
	{
		/**
		 * 打开文件文件
		 */		
		public static const OPEN_FOLDER:String = "Open_Folder";
		
		/**
		 * 打开文件 
		 */		
		public static const OPEN_FILE:String = "Open_File";
		
		/**
		 * 文件/文件夹打开错误
		 */
		public static const OPEN_ERROR:String = "Open_Error";
		
		public var path:String;
		
		public function FileEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
		
		override public function clone():Event
		{
			var event:FileEvent = new FileEvent(type, bubbles);
			event.path = path;
			return event;
		}
	}
}