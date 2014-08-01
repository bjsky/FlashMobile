package potato.event {
	import core.events.TouchEvent;
	
	/**
	 * 系统事件
	 * author floyd
	 * 2014-5-22 下午5:16:07
	 */
	public class SystemTouchEvent extends TouchEvent {
		public function SystemTouchEvent(type:String, bubbles:Boolean=true, localX:Number=NaN, localY:Number=NaN, touchPointID:int=0)
		{
			super(type, bubbles, localX, localY, touchPointID);
		}
	}
}