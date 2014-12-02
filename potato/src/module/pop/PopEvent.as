package potato.module.pop
{
	import core.events.Event;
	
	/**
	 * 弹窗事件 
	 * @author liuxin
	 * 
	 */
	public class PopEvent extends Event
	{
		public function PopEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
		
		/**
		 * 遮罩触摸 
		 */
		public static const MASK_TOUCH:String="maskTouch";
		
		/**
		 * 弹窗触摸 
		 */
		public static const POP_TOUCH:String="popTouch";
	}
}