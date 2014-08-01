package potato.gesture
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import core.display.DisplayObject;
	import core.display.Stage;
	
	import potato.event.GestureEvent;

	/**
	 * 点击手势 
	 * @author liuxin
	 * 
	 */
	public class TapGesture extends Gesture
	{
		public function TapGesture(target:DisplayObject,bubbles:Boolean=true,maxOffset:Number=NaN,maxDelay:uint=400)
		{
			super(target,bubbles);
			this.maxOffset=maxOffset;
			this.maxTapDelay=maxDelay;
		}
		
		/**
		 * 允许的最大偏移,为NaN表示在对象上
		 */
		public var maxOffset:Number = NaN;
		
		/**
		 * 允许的最大延时 
		 */		
		public var maxTapDelay:uint = 400;
		
		private var begin:Number;
		
		override public function set state(value:String):void
		{
			super.state=value;
			if(state==RECOGNIZED)
				dispatchEvent(new GestureEvent(GestureEvent.TAP));
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
				begin=getTimer();
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
			if (state == POSSIBLE){
				var during:Number=getTimer()-begin;
				//超出最大延时，设置状态为失败
				if(during > maxTapDelay){
					state=FAILED;
				}else{
					state=RECOGNIZED;
				}
			}
		}
		
		
	}
}