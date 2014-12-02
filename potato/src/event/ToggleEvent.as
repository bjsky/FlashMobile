package potato.event
{
	import core.events.Event;
	
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