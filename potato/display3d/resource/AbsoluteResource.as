package potato.display3d.resource
{
	import core.events.EventDispatcher;

	/** 抽象资源**/
	public class AbsoluteResource extends EventDispatcher implements IResource
	{
		public function AbsoluteResource(path:String="",args:Array=null)
		{
			_path=path;
			_args=args;
		}
		
		
		protected var _path:String;
		protected var _args:Array;
		private var _data:Object;
		
		public function get path():String
		{
			return _path;
		}
		
		public function set path(value:String):void
		{
			_path=value;
		}
		
		public function get args():Array
		{
			return _args;
		}
		
		public function set args(value:Array):void
		{
			_args=value;
		}
		
		
		public function get data():Object{
			return _data;
		}
		
		public function load():void
		{
		}
		
	}
}