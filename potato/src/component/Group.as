package potato.component
{
	import core.events.EventDispatcher;
	
	import potato.event.UIEvent;

	public class Group extends EventDispatcher
	{
		public function Group()
		{
		}
		private var _mutiSelectEnable:Boolean=false;
		private var _items:Vector.<IGroupItem>=new Vector.<IGroupItem>();
		private var _selectedItem:IGroupItem;
		private var _selectedItems:Vector.<IGroupItem>=new Vector.<IGroupItem>();
		
		public function get mutiSelectEnable():Boolean
		{
			return _mutiSelectEnable;
		}

		public function set mutiSelectEnable(value:Boolean):void
		{
			_mutiSelectEnable = value;
		}

		public function get selectedItem():IGroupItem
		{
			return _mutiSelectEnable?null:_selectedItem;
		}

		public function set selectedItem(value:IGroupItem):void
		{
			if(_mutiSelectEnable) return;
			_selectedItem=value;
			for each(var item:IGroupItem in _items){
				item.selected=(item==_selectedItem?true:false)
			}
			dispatchEvent(new UIEvent(UIEvent.GROUP_SELECT_CHANGE));
		}		
		
		public function get selectedItems():Vector.<IGroupItem>
		{
			return _mutiSelectEnable?_selectedItems:null;
		}
		
		public function set selectedItems(value:Vector.<IGroupItem>):void
		{
			if(!_mutiSelectEnable) return;
			_selectedItems=value;
			for each(var item:IGroupItem in _items){
				item.selected=(_selectedItems?(_selectedItems.indexOf(item)>-1?true:false):false)
			}
			dispatchEvent(new UIEvent(UIEvent.GROUP_SELECT_CHANGE));
		}
		
		public function select(value:IGroupItem):void{
			if(!contains(value)) return;
			if(_mutiSelectEnable){
				if(_selectedItems.indexOf(value)>-1)
					_selectedItems.splice(_selectedItems.indexOf(value),1);
				else
					_selectedItems.push(value);
				selectedItems=_selectedItems;
			}else{
				if(_selectedItem!=value){
					selectedItem=value;
				}
			}
		}
		
		public function addItem(value:IGroupItem):IGroupItem{
			if(_items.indexOf(value)<0)
				_items.push(value);
			return value;
		}
		
		public function removeItem(value:IGroupItem):IGroupItem{
			if(_items.indexOf(value)>-1)
				_items.splice(_items.indexOf(value),1);
			return value;
		}
		
		public function removeAll():void{
			_items=new Vector.<IGroupItem>();
			_selectedItem=null;
		}
		public function contains(value:IGroupItem):Boolean{
			return _items.indexOf(value)>-1?true:false;
		}
		
		override public function dispose():void{
			super.dispose();
			_items=null;
			_selectedItem=null;
			_selectedItems=null;
		}
	}
}