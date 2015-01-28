package potato.component.event
{
	import core.events.Event;
	
	/**
	 * 开关按钮事件. 
	 * @author liuxin
	 * 
	 */
	public class ToggleEvent extends Event
	{
		public function ToggleEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
		/**
		 * 选择改变 
		 */
		static public const SELECT_CHANGE:String="selectChange";
	}
}