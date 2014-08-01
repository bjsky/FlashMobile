package potato.component
{
	/**
	 * list接口 
	 * @author liuxin
	 * 
	 */
	public interface IList
	{
		/**
		 * 数据源 
		 * @param value
		 * 
		 */		
		function set dataSource(value:Object):void;
		function get dataSource():Object;
		
		/**
		 * 选中项索引
		 * @param value
		 * 
		 */
		function set selectIndex(value:int):void;
		function get selectIndex():int;
		
		/**
		 * 添加数据 
		 * @param value
		 * @return 
		 * 
		 */
		function add(value:Object):IListItem;
		
		/**
		 * 添加数据到索引位置 
		 * @param value
		 * @param index
		 * @return 
		 * 
		 */
		function addAt(value:Object,index:int):IListItem;
		
		/**
		 * 删除数据 
		 * @param value
		 * @return 
		 * 
		 */
		function remove(value:Object):IListItem;
		
		/**
		 * 从索引位置移除数据 
		 * @param index
		 * @return 
		 * 
		 */
		function removeAt(index:int):IListItem;
		
		/**
		 * 获取索引位置的项 
		 * @param index
		 * @return 
		 * 
		 */
		function getItem(index:int):IListItem;
		
		/**
		 * 获取项的索引位置 
		 * @param item
		 * @return 
		 * 
		 */
		function getItemIndex(item:IListItem):int;
	}
}