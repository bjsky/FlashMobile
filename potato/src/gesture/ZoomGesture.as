package potato.gesture
{
	import flash.geom.Point;
	
	import core.display.DisplayObject;
	
	import potato.event.GestureEvent;
	import potato.logger.Logger;

	/**
	 * 捏放手势 
	 * @author liuxin
	 * 
	 */
	public class ZoomGesture extends Gesture
	{
		public function ZoomGesture(target:DisplayObject,bubbles:Boolean=true)
		{
			super(target,bubbles);
		}
		private static var log:Logger=Logger.getLog("ZoomGesture");
		/**
		 * 锁定方向缩放 
		 */		
		public var lockAspectRatio:Boolean = true;
		
		
		protected var _touch1:Touch;
		protected var _touch2:Touch;
		protected var _transformVector:Point;
		protected var _initialDistance:Number;
		
		protected var _scaleX:Number = 1;
		public function get scaleX():Number
		{
			return _scaleX;
		}
		
		
		protected var _scaleY:Number = 1;
		public function get scaleY():Number
		{
			return _scaleY;
		}
		
		
		override public function set state(value:String):void
		{
			super.state=value;
			if(state==BEGAN)
				dispatchEvent(new GestureEvent(GestureEvent.ZOOM_BEGIN));
			else if(state==CHANGED)
				this.dispatchEvent(new GestureEvent(GestureEvent.ZOOM));
			else if(state==ENDED)
				this.dispatchEvent(new GestureEvent(GestureEvent.ZOOM_END));
		}
		/**
		 * 重写开始处理 
		 * @param touch
		 * 
		 */
		override protected function onTouchBegin(touch:Touch):void
		{
			super.onTouchBegin(touch);
//			log.debug("[begin]touchesCount:"+_touchesCount+",state:"+state);
			if(_touchesCount>2)
				state=FAILED;
			else{
				if (_touchesCount == 1)
				{
					_touch1 = touch;
				}
				else// == 2
				{
					state=POSSIBLE;
					
					_touch2 = touch;
					_transformVector = _touch2.location.subtract(_touch1.location);
					_initialDistance = _transformVector.length;
				}
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
//			log.debug("[Move]touchesCount:"+_touchesCount+",state:"+state);
			
			if(_touchesCount==2){
				var currTransformVector:Point = _touch2.location.subtract(_touch1.location);
				
				if(lockAspectRatio){
					_scaleX=currTransformVector.length/_transformVector.length;
					_scaleY=_scaleX;
//					log.debug("curLength:"+currTransformVector.length+",formLength:"+_transformVector.length+",scale:"+_scaleX);
				}else{
					_scaleX=currTransformVector.x/_transformVector.x;
					_scaleY=currTransformVector.y/_transformVector.y;
				}
				
				if(state==POSSIBLE)
					state=BEGAN;
				else if(state==BEGAN || state==CHANGED)
					state=CHANGED;
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
//			log.debug("[End]touchesCount:"+_touchesCount+",state:"+state);
			
			if(state!=FAILED){
				if (_touchesCount == 0)
				{
					_touch1=null;
					
					state=POSSIBLE;
				}
				else//== 1
				{
					if (touch == _touch1)
					{
						_touch1 = _touch2;
					}
					_touch2 = null;
					
					state=ENDED;
				}
			}
		}
		
	}
}