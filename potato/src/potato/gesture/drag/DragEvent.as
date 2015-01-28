package potato.gesture.drag
{
	import core.events.Event;
	import potato.gesture.DragGesture;
	
	
	/**
	 * 拖拽放置事件. 
	 * @author liuxin
	 * 
	 */
	public class DragEvent extends Event
	{
		public function DragEvent(type:String, gesutre:DragGesture,bubbles:Boolean=false)
		{
			super(type, bubbles);
			this.gesutre=gesutre;
		}
		/**
		 * 拖动进入组件 
		 */
		static public const DRAG_ENTER:String="dragEnter";
		/**
		 * 拖动出组件 
		 */
		static public const DRAG_EXIT:String="dragExit";
		/**
		 * 在组件上拖动时，每move触发 
		 */
		static public const DRAG_OVER:String="dragOver";
		/**
		 * 在组件上放下 
		 */
		static public const DRAG_DROP:String="dragDrop";
		
		/**
		 * 拖动源 
		 */
		public var gesutre:DragGesture;
	}
}