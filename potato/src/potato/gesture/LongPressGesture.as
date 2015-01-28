package potato.gesture
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import core.display.DisplayObject;
	import core.display.Stage;
	import core.events.TimerEvent;
	import core.utils.Timer;
	

	/**
	 * 长按结束事件.
	 * @author liuxin
	 * 
	 */
	[Event(name="longPressEnd",type="potato.gesture.GestureEvent")]
	/**
	 * 长按中事件.
	 * @author liuxin
	 * 
	 */
	[Event(name="longPressUpdate",type="potato.gesture.GestureEvent")]
	/**
	 * 长按开始事件.
	 * @author liuxin
	 * 
	 */
	[Event(name="longPressBegin",type="potato.gesture.GestureEvent")]
	/**
	 * 长按手势.
	 * <p>按下后保持最短时间以上被认为是长按，超过时间被认为长按开始，抬起被认为是长按结束，中间以一定时间间隔派发更新事件</p>
	 * @author liuxin
	 * 
	 */
	public class LongPressGesture extends Gesture
	{
		public function LongPressGesture(target:DisplayObject,bubbles:Boolean=true,interval:Number=200,minDelay:uint=600)
		{
			super(target,bubbles);
			this.updateInterval=interval;
			this.minLongPressDelay=minDelay;
		}
		
		/**
		 * 最小长按时间 
		 */
		public var minLongPressDelay:uint = 600;
		/**
		 * 允许的最大偏移,为NaN表示在对象上
		 */
		public var maxOffset:Number = NaN;
		
		/**
		 * 更新间隔 
		 */		
		public var updateInterval:Number=200;
		
//		private var begin:Number;
		private var timer:Timer;
		private var updateTimer:Timer;
		override public function set state(value:String):void
		{
			super.state=value;
			if(state== BEGIN){
				dispatchEvent(new GestureEvent(GestureEvent.LONGPRESS_BEGIN));
				disposeTimer();
				//更新计时器
				updateTimer=new Timer(updateInterval);
				updateTimer.addEventListener(TimerEvent.TIMER,onUpdate);
				updateTimer.start();
			}else if(state== CHANGED){
				dispatchEvent(new GestureEvent(GestureEvent.LONGPRESS_UPDATE));
			}else if(state== ENDED){
				dispatchEvent(new GestureEvent(GestureEvent.LONGPRESS_END));
				disposeUpdateTimer();
			}else if(state== FAILED){
				disposeTimer();
				disposeUpdateTimer();
			}
		}
		
		private function disposeTimer():void{
			if(timer){
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onComplete);
				timer.stop();
				timer.dispose();
				timer=null;
			}
		}
		
		private function disposeUpdateTimer():void{
			if(updateTimer){
				updateTimer.removeEventListener(TimerEvent.TIMER,onUpdate);
				updateTimer.stop();
				updateTimer.dispose();
				updateTimer=null;
			}
		}
		
		/**
		 * 重写开始处理 
		 * @param touch
		 * 
		 */
		override protected function onTouchBegin(touch:Touch):void
		{
			super.onTouchBegin(touch);
			if(_touchesCount==1){
				state=POSSIBLE;
				//更新位置
				updateLocation();
				
				timer=new Timer(minLongPressDelay,1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE,onComplete);
				timer.start();
//				begin=getTimer();
			}else
				state=FAILED;
		}
		
		private function onComplete(e:TimerEvent):void
		{
			// TODO Auto Generated method stub
			state=BEGIN;
		}
		
		private function onUpdate(e:TimerEvent):void
		{
			// TODO Auto Generated method stub
			state=CHANGED;
		}
		
		/**
		 * 重写移动处理 
		 * @param touch
		 * 
		 */
		override protected function onTouchMove(touch:Touch):void
		{
			super.onTouchMove(touch);
			if(state==BEGIN || state== CHANGED){
				//上次位置
				var prevLocation:Point=location;
				updateLocation();
				if(isNaN(maxOffset)){
					//移出了显示对象
					var bounds:Rectangle=target.getBounds(Stage.getStage());
					if(!bounds.contains(location.x,location.y)){
						state=FAILED;
					}
				}else{
					//移动过程中超出了允许的范围
					if (location.subtract(prevLocation).length > maxOffset){
						state=FAILED;
					}
				}
			}
		}
		
		/**
		 * 重写结束处理 
		 * @param touch
		 * 
		 */
		override protected function onTouchEnd(touch:Touch):void
		{
			super.onTouchEnd(touch);
			if(state==BEGIN || state== CHANGED){
				state=ENDED;
			}else{
				state=FAILED;
			}
		}
		
		override public function dispose():void{
			super.dispose();
			
			disposeTimer();
			disposeUpdateTimer();
		}
	}
}