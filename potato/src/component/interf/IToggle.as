package potato.component.interf
{
	/**
	 * 选择改变事件.
	 * @author liuxin
	 * 
	 */
	[Event(name="selectChange",type="potato.event.PotatoEvent")]
	/**
	 * 开关组件接口.
	 * @author liuxin
	 * @see ToggleGroup
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
		
	}
}