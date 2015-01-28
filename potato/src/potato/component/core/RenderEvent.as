package potato.component.core
{
	import core.events.Event;
	
	/**
	 * 渲染事件. 
	 * @author liuxin
	 * 
	 */
	public class RenderEvent extends Event
	{
		public function RenderEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
		
		/**
		 * 渲染 
		 */
		public static const RENDER:String="render";
		
		/**
		 * 渲染完成 
		 */
		public static const RENDER_COMPLETE:String="renderComplete";
	}
}