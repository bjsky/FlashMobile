package potato.event
{
	import core.events.Event;
	
	public class PotatoEvent extends Event
	{
		public function PotatoEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
		/**
		 * 选择改变 
		 */
		static public const SELECT_CHANGE:String="selectChange";
		
		/**
		 * 组选择改变 
		 */		
		static public const GROUP_SELECT_CHANGE:String="groupSelectChange";
		
		/**
		 * 状态改变 
		 */		
		static public const STATE_CHANGE:String="stateChange";
		
		/**
		 * 渲染 
		 */		
		static public const RENDER:String="render";
		
		/**
		 * 渲染完成
		 */		
		static public const RENDER_COMPLETE:String="renderComplete";
	}
}