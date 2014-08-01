package potato.event
{
	import core.events.Event;
	
	/**
	 * ui事件 
	 * @author win7
	 * 
	 */
	public class UIEvent extends Event
	{
		public function UIEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
		/**
		 * 组件渲染事件 
		 */
		static public const RENDER:String="render";
		/**
		 * 组选中改变 
		 */		
		static public const GROUP_SELECT_CHANGE:String="Group_select_Change";
		
		/**
		 * 开关选择改变 
		 */
		static public const TOGGLE_SELECT_CHANGE:String="Toggle_select_change";
	}
}