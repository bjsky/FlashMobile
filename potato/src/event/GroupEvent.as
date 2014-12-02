package potato.event
{
	import core.events.Event;
	
	public class GroupEvent extends Event
	{
		public function GroupEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
		
		/**
		 * 组选择改变 
		 */		
		static public const GROUP_SELECT_CHANGE:String="groupSelectChange";
	}
}