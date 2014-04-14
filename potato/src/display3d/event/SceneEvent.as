package potato.display3d.event
{
	import core.events.Event;
	/**
	 * 场景事件
	 * @author win7
	 * 
	 */
	public class SceneEvent extends Event
	{
		public function SceneEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
		
		/** 场景加载完成**/
		static public const LOAD_COMPLETE:String="load_complete";
	}
}