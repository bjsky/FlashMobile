package potato.component.event
{
	import core.events.Event;
	
	import potato.component.core.IToggle;
	
	/**
	 * 开关组事件. 
	 * @author liuxin
	 * 
	 */
	public class ToggleGroupEvent extends Event
	{
		public function ToggleGroupEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
		
		/**
		 * 组选择改变 
		 */		
		static public const SELECT_CHANGE:String="groupSelectChange";
		
		/**
		 * 开关组件 
		 */
		public var toggle:IToggle;
		
		/**
		 * 开关组件列表 
		 */		
		public var toggles:Vector.<IToggle>;
	}
}