package potato.module
{
	import core.events.Event;
	
	public class EffectUIEvent extends Event
	{
		public function EffectUIEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
		
		public static const SHOW_COMPLETE:String="showComplete";
		
		public static const HIDE_COMPLETE:String="hideComplete";
	}
}