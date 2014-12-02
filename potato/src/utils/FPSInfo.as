package potato.utils
{
	import flash.utils.getTimer;
	
	import core.display.Image;
	import core.display.Stage;
	import core.events.Event;
	import core.system.System;

	public class FPSInfo
	{
		public function FPSInfo()
		{
			Stage.getStage().addChild(_img);
			_img.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private var _img:Image=new Image(null);
		private var last:uint;
		private var ticks:uint;

		private var _privateMemory:Number;
		private var _totalMemory:Number;
		private var _freeMemory:Number;
		private var _version:String;
		private var _fps:Number;
		
		public function get fps():Number
		{
			return _fps;
		}

		public function set fps(value:Number):void
		{
			_fps = value;
		}

		public function get version():String
		{
			return _version;
		}

		public function set version(value:String):void
		{
			_version = value;
		}

		public function get freeMemory():Number
		{
			return _freeMemory;
		}

		public function set freeMemory(value:Number):void
		{
			_freeMemory = value;
		}

		public function get totalMemory():Number
		{
			return _totalMemory;
		}

		public function set totalMemory(value:Number):void
		{
			_totalMemory = value;
		}

		public function get privateMemory():Number
		{
			return _privateMemory;
		}

		public function set privateMemory(value:Number):void
		{
			_privateMemory = value;
		}
		
		public function toString():String{
			return "fps:"+fps+" priv:"+privateMemory+" total:"+totalMemory+" free:"+freeMemory+" ver:"+version;
		}
		
		public function onFrame(e:Event):void
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
		
		
		public function dispose():void {
			_img.removeEventListener(Event.ENTER_FRAME, onFrame);
			 Stage.getStage().removeChild(_img);
		}
	}
}