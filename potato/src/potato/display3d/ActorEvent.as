package potato.display3d
{
	import core.events.Event;
	
	public class ActorEvent extends Event
	{
		public function ActorEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
		/**
		 * 加载完成 
		 */		
		public static const LOADCOMPLETE:String = "LoadComplete";
	}
}