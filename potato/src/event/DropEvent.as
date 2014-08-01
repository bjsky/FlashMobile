package potato.event
{
	import core.events.Event;
	
	import potato.gesture.DragGesture;
	
	public class DropEvent extends Event
	{
		public function DropEvent(type:String, gesutre:DragGesture,bubbles:Boolean=false)
		{
			super(type, bubbles);
			this.gesutre=gesutre;
		}
		/**
		 * 拖动进入组件 
		 */
		static public const DRAG_ENTER:String="DragEnter";
		/**
		 * 拖动出组件 
		 */
		static public const DRAG_EXIT:String="DragExit";
		/**
		 * 在组件上拖动时，每move触发 
		 */
		static public const DRAG_OVER:String="DragOver";
		/**
		 * 在组件上放下 
		 */
		static public const DRAG_DROP:String="DragDrop";
		
		/**
		 * 拖动源 
		 */
		public var gesutre:DragGesture;
	}
}