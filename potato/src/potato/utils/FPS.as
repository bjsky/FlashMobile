package potato.utils
{
	import flash.utils.getTimer;
	
	import core.display.DisplayObject;
	import core.events.Event;
	import core.system.System;

	/**
	 * 性能测试工具 
	 * @author win7
	 * 
	 */
	public class FPS
	{
		public function FPS()
		{
		}
		
		private static var _display:DisplayObject;
		
		public static function test(display:DisplayObject):void{
			_display=display;
			_display.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		public static function stop():void{
			_display.removeEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private static var last:uint;
		private static var ticks:uint;

		private static var privateMemory:Number;
		private static var totalMemory:Number;
		private static var freeMemory:Number;
		private static var version:String;
		private static var fps:Number;
		
		public static function toString():String{
			return "fps:"+fps+" priv:"+privateMemory+" total:"+totalMemory+" free:"+freeMemory+" ver:"+version;
		}
		
		public static function onFrame(e:Event):void
		{
			if (last == 0)
			{
				last = getTimer();
				ticks = 0;
				return;
			}
			ticks++;
			var now:uint = getTimer();
			if (now - last >= 1000)
			{
				fps=uint((ticks * 1000 / (now - last)) * 10 + 0.5) / 10 ;
				privateMemory=System.privateMemory >> 20;
				totalMemory=System.totalMemory >> 20;
				freeMemory=System.freeMemory >> 20;
				version=System.getVersion();
				
				last = now;
				ticks = 0;
			}
		}
	}
}