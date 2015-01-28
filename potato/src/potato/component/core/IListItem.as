package potato.component.core
{
	/**
	 * 列表项接口.
	 * <p>通过实现列表项接口，以便获得列表的数据</p>
	 * @author liuxin
	 * 
	 */
	public interface IListItem 
	{
		/**
		 * 索引 
		 * @param value
		 * 
		 */
		function set index(value:int):void;
		function get index():int;
		/**
		 * 列表项数据 
		 * @param value
		 * 
		 */
		function set data(value:Object):void;
		function get data():Object;
		
		/**
		 * 获取标签 
		 * @return 
		 * 
		 */
		function get label():String;
	}
}