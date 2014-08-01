package potato.event
{
	import core.events.Event;
	
	public class GestureEvent extends Event
	{
		public function GestureEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
		//////////////////////////
		// 触摸
		/////////////////////////
		
		/**
		 * 触摸开始 
		 */
		static public const TOUCH_BEGIN:String="TOUCH_BEGIN";
		
		/**
		 * 触摸移动 
		 */
		static public const TOUCH_MOVE:String="TOUCH_MOVE";
		
		/**
		 * 触摸结束 
		 */
		static public const TOUCH_END:String="TOUCH_END";
		
		
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
		static public const DOUBLE_TAP:String="DoubleTAP";
		
		
		//////////////////////////
		// 长按
		/////////////////////////
		
		/**
		 * 点击
		 */		
		static public const LONGPRESS:String="LongPress";
		
		
		//////////////////////////
		// 平移
		/////////////////////////
		
		/**
		 * 平移开始 
		 */
		static public const PAN_BEGIN:String="PAN_BEGIN";
		/**
		 * 平移 
		 */
		static public const PAN_MOVE:String="PAN_MOVE";
		/**
		 * 平移结束 
		 */
		static public const PAN_END:String="PAN_END";
		
		
		//////////////////////////
		// 拖动
		/////////////////////////
		
		/**
		 * 拖动开始
		 */
		static public const DRAG_BEGIN:String="DRAG_BEGIN";
		
		/**
		 * 拖动 
		 */
		static public const DRAG_MOVE:String="DRAG_MOVE";
		/**
		 * 拖动结束 
		 */
		static public const DRAG_END:String="DRAG_END";
		
		//////////////////////////
		// 缩放
		/////////////////////////
		
		/**
		 * 开始缩放 
		 */		
		static public const ZOOM_BEGIN:String="ZOOM_BEGIN";
		/**
		 * 缩放中 
		 */
		static public const ZOOM:String="ZOOM";
		/**
		 * 停止缩放 
		 */
		static public const ZOOM_END:String="ZOOM_END";
		
	}
}