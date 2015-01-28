package potato.utils
{
	import flash.utils.Dictionary;
	
	import core.events.TimerEvent;
	import core.utils.Timer;

	/**
	 * 延迟触发逻辑<br>
	 * 用来间隔一定时间回调指定的函数及其参数；
	 * @author SuperFlash
	 * @time 2014/03/11
	 */
	public final class DelayTrigger
	{
		private static var _FPPool:Array=new Array();
		private static var _timerPool:Array=new Array();
		private static var _timerToFP:Dictionary=new Dictionary();

		private static function getTimer(delay:int):Timer
		{
			var tm:Timer=_timerPool.pop();
			tm == null ? tm=new Timer(delay) : tm.delay=delay;
			tm.addEventListener(TimerEvent.TIMER, onTimerCompleteHandler);
			tm.start();
			return tm;
		}

		private static function addToTmPool(tm:Timer):void
		{
			tm.stop();
			tm.removeEventListener(TimerEvent.TIMER, onTimerCompleteHandler);
			_timerPool.push(tm);
		}

		private static function getFp():FnParam
		{
			var fp:FnParam=_FPPool.pop();
			if (fp == null)
			{
				fp=new FnParam();
			}
			return fp;
		}

		private static function addToFPPool(fp:FnParam):void
		{
			fp.cbFn=null;
			fp.cbParam=null;
			_FPPool.push(fp);
		}


		/**
		 *
		 * @param delay		延迟时间(ms);
		 * @param cbFn		回调函数；
		 *
		 */
		public static function addDelayTrigger(delay:int, cbFn:Function, cbParam:Object=null):void
		{
			if(delay<=0){
				cbParam == null ? cbFn() : cbFn(cbParam);
			}else{
				var fp:FnParam=getFp();
				fp.cbFn=cbFn;
				fp.cbParam=cbParam;
				var tm:Timer=getTimer(delay);
				_timerToFP[tm]=fp;
			}
		}

		private static function onTimerCompleteHandler(e:TimerEvent):void
		{
			var tm:Timer=e.currentTarget as Timer;
			var fp:FnParam=_timerToFP[tm] as FnParam;
			fp.cbParam == null ? fp.cbFn() : fp.cbFn(fp.cbParam);
			delete _timerToFP[tm];
			addToTmPool(tm);
			addToFPPool(fp);

		}

		public static function dispose():void
		{
			//TODO:dispose all ;
		}

	}
}

class FnParam
{
	public var cbFn:Function;
	public var cbParam:Object;
}
