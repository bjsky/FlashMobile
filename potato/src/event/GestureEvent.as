package potato.event
{
	import core.events.Event;
	
	/**
	 * 手势事件. 
	 * @author liuxin
	 * 
	 */
	public class GestureEvent extends Event
	{
		public function GestureEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
		
		override public function clone():Event
		{
			var gestureEvent:GestureEvent=new GestureEvent(type, bubbles);
			return gestureEvent;
		}
		//////////////////////////
		// 触摸
		/////////////////////////
		
		/**
		 * 触摸开始 
		 */
		static public const GESTURE_TOUCH_BEGIN:String="gestureTouchBegin";
		
		/**
		 * 触摸移动 
		 */
		static public const GESTURE_TOUCH_MOVE:String="gestureTouchMove";
		
		/**
		 * 触摸结束 
		 */
		static public const GESTURE_TOUCH_END:String="gestureTouchEnd";
		
		
		//////////////////////////
		// 点击
		/////////////////////////
		
		/**
		 * 点击
		 */		
		static public const TAP:String="tap";
		
		//////////////////////////
		// 双击
		/////////////////////////
		
		/**
		 * 双击
		 */		
		static public const DOUBLE_TAP:String="doubleTap";
		
		
		//////////////////////////
		// 长按
		/////////////////////////
		
		/**
		 * 长按开始
		 */		
		static public const LONGPRESS_BEGIN:String="longPressBegin";
		/**
		 * 长按中
		 */		
		static public const LONGPRESS_UPDATE:String="longPressUpdate";
		/**
		 * 长按结束
		 */		
		static public const LONGPRESS_END:String="longPressEnd";
		
		
		//////////////////////////
		// 平移
		/////////////////////////
		
		/**
		 * 平移开始 
		 */
		static public const PAN_BEGIN:String="panBegin";
		/**
		 * 平移 
		 */
		static public const PAN_MOVE:String="panMove";
		/**
		 * 平移结束 
		 */
		static public const PAN_END:String="panEnd";
		
		
		//////////////////////////
		// 拖动
		/////////////////////////
		
		/**
		 * 拖动开始
		 */
		static public const DRAG_BEGIN:String="dragBegin";
		
		/**
		 * 拖动 
		 */
		static public const DRAG_MOVE:String="dragMove";
		/**
		 * 拖动结束 
		 */
		static public const DRAG_END:String="dragEnd";
		
		//////////////////////////
		// 缩放
		/////////////////////////
		
		/**
		 * 开始缩放 
		 */		
		static public const ZOOM_BEGIN:String="zoomBegin";
		/**
		 * 缩放中 
		 */
		static public const ZOOM:String="zoom";
		/**
		 * 停止缩放 
		 */
		static public const ZOOM_END:String="zoomEnd";
		
	}
}