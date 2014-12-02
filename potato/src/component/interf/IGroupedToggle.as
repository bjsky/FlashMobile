package potato.component.interf
{
	import potato.component.ToggleGroup;

	/**
	 * 可指定分组的开关组件接口.
	 * <p></p> 
	 * @author win7
	 * 
	 */
	public interface IGroupedToggle extends IToggle
	{
		/**
		 * 从属按钮组 
		 * @param value
		 * 
		 */		
		function set toggleGroup(value:ToggleGroup):void;
		function get toggleGroup():ToggleGroup;
	}
}