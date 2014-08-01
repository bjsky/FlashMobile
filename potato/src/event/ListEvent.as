package potato.event
{
	import core.events.Event;
	
	import potato.component.IListItem;
	
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
		static public const LIST_SELECT_CHANGE:String="List_SELECT_CHANGE";
		/**
		 * 列表项点击 
		 */		
		static public const LIST_ITEM_TAP:String="LIST_ITEM_TAP";
		/**
		 * 列表项双击
		 */		
		static public const LIST_ITEM_DOUBLE_TAP:String="LIST_ITEM_DOUBLE_TAP";
		
		
		/**
		 * 项 
		 */
		public var item:IListItem;
	}
}