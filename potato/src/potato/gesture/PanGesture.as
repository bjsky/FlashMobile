package potato.gesture
{
	import flash.geom.Point;
	
	import core.display.DisplayObject;
	

	/**
	 * 平移开始.
	 * @author liuxin
	 * 
	 */
	[Event(name="panBegin",type="potato.gesture.GestureEvent")]
	/**
	 * 平移过程中.
	 * @author liuxin
	 * 
	 */
	[Event(name="panMove",type="potato.gesture.GestureEvent")]
	/**
	 * 平移结束.
	 * @author liuxin
	 * 
	 */
	[Event(name="panEnd",type="potato.gesture.GestureEvent")]
	/**
	 * 平移手势.
	 * <p>移动行为被认定为平移手势</p> 
	 * @author liuxin
	 * 
	 */
	public class PanGesture extends Gesture
	{
		public function PanGesture(target:DisplayObject,bubbles:Boolean=true)
		{
			super(target,bubbles);
		}
		//-------------------
		// properties
		//-------------------
		protected var _offsetX:Number = 0;
		protected var _offsetY:Number = 0;
		
		/**
		 * x的偏移 
		 * @return 
		 * 
		 */
		public function get offsetX():Number
		{
			return _offsetX;
		}
		
		/**
		 * y的偏移 
		 * @return 
		 * 
		 */
		public function get offsetY():Number
		{
			return _offsetY;
		}
		
		//-----------------------------
		// override
		//-----------------------------
		override public function set state(value:String):void
		{
			super.state=value;
			if(state==BEGIN)
				dispatchEvent(new GestureEvent(GestureEvent.PAN_BEGIN));
			else if(state==CHANGED)
				this.dispatchEvent(new GestureEvent(GestureEvent.PAN_MOVE));
			else if(state==ENDED)
				this.dispatchEvent(new GestureEvent(GestureEvent.PAN_END));
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
				_offsetX = 0;
				_offsetY = 0;
				updateLocation();
			}else{
				state=FAILED;
			}
		}
		
		/**
		 * 重写移动处理 
		 * @param touch
		 * 
		 */
		override protected function onTouchMove(touch:Touch):void
		{
			super.onTouchMove(touch);
			if(state==POSSIBLE || state==BEGIN || state ==CHANGED){
				if(state==POSSIBLE)
					state=BEGIN;
				else if(state==BEGIN || state==CHANGED)
					state=CHANGED;
				
				updatePanOffset();
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
			
			if(state==POSSIBLE || state==BEGIN || state ==CHANGED){
				state=ENDED;
			}
		}
		
		private function updatePanOffset():void{
			//上次位置
			var prevLocation:Point = location;
			//更新位置
			updateLocation();
			var locationOffset:Point=location.subtract(prevLocation);
			_offsetX = locationOffset.x;
			_offsetY = locationOffset.y;
		}
	}
}