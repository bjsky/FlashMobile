package potato.component.classes
{
	import potato.component.IGroupItem;
	import potato.component.IListItem;
	import potato.component.Text;
	
	/**
	 * 默认文字列表项 
	 * @author liuxin
	 * 
	 */
	public class DefaultListItemRenderer extends Text
		implements IListItem,IGroupItem
	{
		public function DefaultListItemRenderer()
		{
			super();
		}
		protected var _index:int;
		protected var _selected:Boolean;
		protected var _data:Object;

		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
		public function set selected(value:Boolean):void{
			_selected=value;
		}
		public function get selected():Boolean{
			return _selected;
		}
		
		public function set data(value:Object):void
		{
			_data=value;
			if(_data is String)
				text=String(_data);
			else if(_data.label is String)
				text=String(_data.label);
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function get label():String{
			return text;
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}