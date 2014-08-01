package potato.component
{
	/**
	 * 列表项 
	 * @author win7
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