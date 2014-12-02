package potato.event
{
	import core.events.Event;
	
	import potato.component.interf.IListItem;
	
	/**
	 * 列表事件. 
	 * @author liuxin
	 * 
	 */
	public class ListEvent extends Event
	{
		public function ListEvent(type:String,item:IListItem, bubbles:Boolean=false)
		{
			super(type, bubbles);
			this.item=item;
		}
		/**
		 * 列表选中改变 
		 */		
		static public const LIST_SELECT_CHANGE:String="listSelectChange";
		/**
		 * 列表项点击 
		 */		
		static public const LIST_ITEM_TAP:String="listItemTap";
		
		/**
		 * 列表项
		 */
		public var item:IListItem;
		
		/**
		 * 列表项集合 
		 */
		public var items:Vector.<IListItem>;
	}
}