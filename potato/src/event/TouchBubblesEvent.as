package potato.event
{
	import core.events.Event;
	
	import potato.gesture.TouchBubbles;
	
	/**
	 * 触摸冒泡事件 
	 * @author liuxin
	 * 
	 */
	public class TouchBubblesEvent extends Event
	{
		public function TouchBubblesEvent(type:String, touchBubbles:TouchBubbles,bubbles:Boolean=false)
		{
			super(type, bubbles);
			this.touchBubbles=touchBubbles;
		}
		
		static public const TOUCH_BUBBLES:String="touchBubbles";
		
		private var _touchBubbles:TouchBubbles;
		
		/**
		 * 触摸冒泡 
		 * @return 
		 * 
		 */
		public function get touchBubbles():TouchBubbles
		{
			return _touchBubbles;
		}

		public function set touchBubbles(value:TouchBubbles):void
		{
			_touchBubbles = value;
		}

	}
}