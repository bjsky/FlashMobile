package potato.gesture
{
	import flash.geom.Point;
	
	import core.display.DisplayObject;
	
	import potato.event.GestureEvent;
	import potato.logger.Logger;

	/**
	 * 缩放开始.
	 * @author liuxin
	 * 
	 */
	[Event(name="zoomBegin",type="potato.event.GestureEvent")]
	/**
	 * 缩放过程中.
	 * @author liuxin
	 * 
	 */
	[Event(name="zoom",type="potato.event.GestureEvent")]
	/**
	 * 缩放结束.
	 * @author liuxin
	 * 
	 */
	[Event(name="zoomEnd",type="potato.event.GestureEvent")]
	/**
	 * 缩放手势.
	 * <p>两指的距离变化可以认定为有效的缩放</p> 
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
		 * 锁定方向缩放，当设置为true时，scaleX等于scaleY，依据两指的距离变化。否则scaleX依据横向距离变化，scaleY依据纵向距离变化
		 */		
		public var lockAspectRatio:Boolean = true;
		
		
		private var _touch1:Touch;
		private var _touch2:Touch;
		private var _transformVector:Point;
		private var _initialDistance:Number;
		
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		
		/**
		 * x轴缩放比
		 * @return 
		 * 
		 */
		public function get scaleX():Number
		{
			return _scaleX;
		}
		
		/**
		 * y轴缩放比 
		 * @return 
		 * 
		 */
		public function get scaleY():Number
		{
			return _scaleY;
		}
		
		
		override public function set state(value:String):void
		{
			super.state=value;
			if(state==BEGIN)
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
					state=BEGIN;
				else if(state==BEGIN || state==CHANGED)
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