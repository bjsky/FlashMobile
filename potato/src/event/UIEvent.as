package potato.event
{
	import core.events.Event;
	
	/**
	 * ui事件
	 * @author liuxin
	 * 
	 */
	public class UIEvent extends Event
	{
		public function UIEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
		
		/** 渲染完成**/
		static public const RENDER_COMPLETE:String="render_complete";
	}
}