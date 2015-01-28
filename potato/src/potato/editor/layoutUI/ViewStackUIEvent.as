package potato.editor.layoutUI
{
	import core.events.Event;
	
	public class ViewStackUIEvent extends Event
	{
		public function ViewStackUIEvent(type:String, state:*,bubbles:Boolean=false)
		{
			super(type, bubbles);
			this.state=state;
		}
		
		public var state:*;
		/**
		 * 状态改变 
		 */
		public static const STATE_CHANGE:String="state_change";
	}
}