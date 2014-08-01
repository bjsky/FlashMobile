package potato.gesture
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import core.display.DisplayObject;
	import core.display.Stage;
	
	import potato.event.GestureEvent;

	/**
	 * 双击手势 
	 * @author liuxin
	 * 
	 */
	public class DoubleTapGesture extends Gesture
	{
		public function DoubleTapGesture(target:DisplayObject,bubbles:Boolean=true,minDelay:uint=600)
		{
			super(target,bubbles);
			this.minBoubleTapDelay=minDelay;
		}
		/**
		 * 最小双击时间 
		 */
		public var minBoubleTapDelay:uint = 600;
		/**
		 * 允许的最大偏移,为NaN表示在对象上
		 */
		public var maxOffset:Number = NaN;
		
		
		private var _tapCount:Number=0;
		private var _tapTime:Number;
		private var _duringTime:Number;
		
		override public function set state(value:String):void
		{
			super.state=value;
			if(state==RECOGNIZED)
				dispatchEvent(new GestureEvent(GestureEvent.DOUBLE_TAP));
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
				updateLocation();
				if(_tapCount==0){		//首次按下取时间
					_tapTime=_duringTime=getTimer();
				}else if(_tapCount==1){		//第二次按下，判定是否重置
					_duringTime=getTimer()-_tapTime;
					if(_duringTime>minBoubleTapDelay){
						_tapCount=0;
						_tapTime=_duringTime=getTimer();
					}
				}
				_tapCount++;
//				trace(_tapCount+","+_tapTime+","+_duringTime);
			}else
				state=FAILED;
		}
		
		/**
		 * 重写移动处理 
		 * @param touch
		 * 
		 */
		override protected function onTouchMove(touch:Touch):void
		{
			super.onTouchMove(touch);
			if(state == POSSIBLE){
				//上次位置
				var prevLocation:Point=location;
				updateLocation();
				if(isNaN(maxOffset)){
					//移出了显示对象
					var bounds:Rectangle=target.getBounds(Stage.getStage());
					if(!bounds.contains(location.x,location.y)){
						state=FAILED;
						_tapCount=0;
					}
				}else{
					//移动过程中超出了允许的范围
					if (location.subtract(prevLocation).length > maxOffset){
						state=FAILED;
						_tapCount=0;
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
			if(state==POSSIBLE){
				if(_tapCount>=2){			//第二次抬起，验证时间差
					_duringTime=getTimer()-_tapTime;
					if(_duringTime<=minBoubleTapDelay)
						state=RECOGNIZED;
					else
						state=FAILED;
					_tapCount=0;
				}
			}
			
//			trace(_tapCount+","+_tapTime+","+_duringTime);
		}
	}
}