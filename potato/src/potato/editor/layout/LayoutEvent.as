package potato.editor.layout
{
	import core.events.Event;
	
	/**
	 * 布局事件.
	 * <p>布局的事件枚举</p> 
	 * @author win7
	 * 
	 */
	public class LayoutEvent extends Event
	{
		public function LayoutEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
		
		/**
		 * 大小改变 
		 */
		static public const RESIZE:String="resize";
		
		/**
		 * 测量
		 */		
		static public const MEASURE:String="measure";
	}
}