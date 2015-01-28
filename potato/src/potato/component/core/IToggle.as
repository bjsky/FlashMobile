package potato.component.core
{
	/**
	 * 选择改变事件.
	 * @author liuxin
	 * 
	 */
	[Event(name="selectChange",type="potato.component.event.PotatoEvent")]
	/**
	 * 开关组件接口.
	 * @author liuxin
	 */
	public interface IToggle
	{
		
		/**
		 * 是否选中 
		 * @param value
		 * 
		 */
		function set selected(value:Boolean):void;
		function get selected():Boolean;
		
		/**
		 * 是否开启选中
		 * @param value
		 * 
		 */
		function set toggleEnable(value:Boolean):void;
		function get toggleEnable():Boolean;
	}
}