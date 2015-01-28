package potato.editor.tree
{

	import core.events.Event;

	/**
	 * Tree的事件类,点击某一个分支所派发的CLICK_NODE事件
	 * @author EricXie
	 * 
	 */	
	public class TreeEvent extends Event
	{
		/**
		 * 点击某一个节点的事件名
		 */
		public static const CLICK_NODE:String = "clickNode";
		/**
		 *选中该项时 
		 */		
		public static const SELECTED_ITEM:String="selectedItem";
		/**
		 *长按该选项时 
		 */		
		public static const LONG_PRESS_GESTURE:String="Long_press_Gesture";
		//事件源
		public var item:TreeCellRenderer;
		public function TreeEvent(type:String,_item:TreeCellRenderer, bubbles:Boolean = false)
		{
			this.item = _item;
			super(type,bubbles);
		}
	}
}