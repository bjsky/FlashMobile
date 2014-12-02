package potato.component.interf
{
	/**
	 * 列表选择改变事件.
	 * @author liuxin
	 * 
	 */
	[Event(name="listSelectChange",type="potato.event.ListEvent")]
	
	/**
	 * 子项点击事件
	 * @author liuxin
	 * 
	 */
	[Event(name="listItemTap",type="potato.event.ListEvent")]
	
	/**
	 * 列表接口.
	 * <p>列表接口定义了使用列表方式呈现的组件的常用属性</p>
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
		
//		/**
//		 * 添加数据 
//		 * @param value
//		 * @return 
//		 * 
//		 */
//		function add(value:Object):IListItem;
//		
//		/**
//		 * 添加数据到索引位置 
//		 * @param value
//		 * @param index
//		 * @return 
//		 * 
//		 */
//		function addAt(value:Object,index:int):IListItem;
//		
//		/**
//		 * 删除数据 
//		 * @param value
//		 * @return 
//		 * 
//		 */
//		function remove(value:Object):IListItem;
//		
//		/**
//		 * 从索引位置移除数据 
//		 * @param index
//		 * @return 
//		 * 
//		 */
//		function removeAt(index:int):IListItem;
		
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