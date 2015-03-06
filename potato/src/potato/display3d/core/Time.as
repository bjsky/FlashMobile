package potato.display3d.core
{
	import flash.utils.getTimer;
	
	import core.display.DisplayObjectContainer;
	import core.events.Event;
	import core.events.TimerEvent;
	import core.utils.Timer;
	
	import potato.potato_internal;
	import potato.display3d.Behaviour;

	/**
	 * 时间管理. 
	 * @author liuxin
	 * 
	 */
	public class Time
	{
		public function Time()
		{
		}
		use namespace potato_internal;
		
		private static var _fixedTimer:Timer;
		//固定计时频率
		private static var _fixedDeltaTime:Number=50;
		
		//真实的开始时间
		private static var _realBeginTime:Number;
		//真实的当前时间
		private static var _realCurTime:Number;
		//真实的上一帧时间
		private static var _realPrevTime:Number;
		//真实的帧时间差
		private static var _realDeltaTime:Number;
		//上一帧游戏时间差
		private static var _deltaTime:Number;
		//当前游戏时间
		private static var _curTime:Number=0;
		
		/**
		 * 主程序 
		 */
		private static var _main:DisplayObjectContainer;
		
		
		
		private static var _timeScale:Number=1;
		public static function set timeScale(value:Number):void{
			_timeScale=value;
			resetFixedTimer();
		}
		public static function get timeScale():Number{
			return _timeScale;
		}
		
		/**
		 * 总游戏时间(受timeScale影响)
		 * @return 
		 * 
		 */
		public static function get time():Number{
			return _curTime;
		}
		
		/**
		 * 上一帧游戏时间增量(受timeScale影响)单位毫秒
		 * @return 
		 * 
		 */
		public static function get deltaTime():Number{
			return _deltaTime;
		}
		
		/**
		 * 总运行时间 (不受timeScale影响)
		 * @return 
		 * 
		 */
		public static function get realTime():Number{
			return _realCurTime-_realBeginTime;
		}
		
		/**
		 * 上一帧时间增量 (不受timeScale影响)
		 * @return 
		 * 
		 */
		public static function get realDeltaTime():Number{
			return _realDeltaTime;
		}
		
		potato_internal static function start(main:DisplayObjectContainer):void{
			_realCurTime=_realBeginTime=getTimer();
			_curTime=0;
			
			_main=main;
			_main.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			startFixedTimer(_fixedDeltaTime*_timeScale);
		}
		
		private static function startFixedTimer(time:Number):void{
			_fixedTimer = new Timer(time);
			_fixedTimer.addEventListener(TimerEvent.TIMER,timerHandler);
			_fixedTimer.start();
		}
		private static function stopFixedTimer():void{
			_fixedTimer.stop();
			_fixedTimer.removeEventListener(TimerEvent.TIMER,timerHandler);
			_fixedTimer.dispose();
		}
		private static function resetFixedTimer():void{
			_fixedTimer.stop();
			_fixedTimer.delay=_fixedDeltaTime*_timeScale;
			if(_fixedTimer.delay>0)
				_fixedTimer.start();
		}
		
		potato_internal static function stop():void{
			_main.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			stopFixedTimer();
		}
		
		
		private static function timerHandler(e:TimerEvent):void
		{
			for each(var behaivour:Behaviour in BehaviourManager.behaviours){
				if(behaivour._enable){
					behaivour.fixedUpdate();
				}
			}
		}		
		
		private static function enterFrameHandler(e:Event):void
		{
			_realPrevTime=_realCurTime;
			_realCurTime=getTimer();
			_realDeltaTime=_realCurTime-_realPrevTime;
			_deltaTime=_realDeltaTime*_timeScale;
			_curTime+=_deltaTime;
			
			var behaivours:Vector.<Behaviour>=BehaviourManager.behaviours;
			for each(var behaivour:Behaviour in behaivours){
				if(!behaivour._isStart){
					behaivour._isStart=true;
					behaivour.start();
				}
				if(behaivour._enable){
					behaivour.update();
				}
			}
			for each(behaivour in behaivours){
				if(behaivour._enable){
					behaivour.laterUpdate();
				}
			}
		}
	}
}