package potato.component
{
	

	public interface IDropTrigger
	{
		/**
		 * 忽略冒泡时,认为放置目标为当前的触发器，否则认为放置目标为第一个触发器
		 * @param value
		 * 
		 */
		function set ignoreBubbles(value:Boolean):void;
		function get ignoreBubbles():Boolean;
		
		/**
		 * 是否可放置 
		 * @param value
		 * 
		 */
		function set dropEnable(value:Boolean):void;
		function get dropEnable():Boolean;
	}
}