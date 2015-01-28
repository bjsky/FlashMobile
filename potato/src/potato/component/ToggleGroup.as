package potato.component
{
	import core.events.EventDispatcher;
	
	import potato.component.core.IDataBinding;
	import potato.component.core.IToggle;
	import potato.component.event.ToggleGroupEvent;

	/**
	 * 组选择改变.
	 * @author liuxin
	 * 
	 */
	[Event(name="groupSelectChange",type="potato.component.event.ToggleGroupEvent")]
	/**
	 * 开关按钮组.
	 * <p>逻辑开关按钮组，通过添加开关按钮，实现单选和多选</p>
	 * @author liuxin
	 * @see Button
	 * @see IToggle
	 * @example 该例实现了一个包含两个选择框的多选组
	 * <listing>
	 * 		var checkBox:ToggleGroup=new ToggleGroup();
	 * 		checkBox.mutiSelectEnable=true;
	 * 		checkBox.addEventListener(UIEvent.GROUP_SELECT_CHANGE,groupSelectChange);

  	 *		var btn1:Button=new Button("btn_normal,,,btn_select","按钮1");
	 * 		btn1.toggleGroup=checkBox;
	 * 		btn1.data=0;
	 * 		this.addChild(btn1);
	 * 		var btn2:Button=new Button("btn_normal,,,btn_select","按钮2");
	 * 		btn2.toggleGroup=checkBox;
	 * 		btn2.data=1;
	 * 		this.addChild(btn2);
	 * 		
	 * 		checkBox.selectIndex=0;
	 * 		
	 * </listing>
	 * 
	 */
	public class ToggleGroup extends EventDispatcher
		implements IDataBinding
	{
		public function ToggleGroup()
		{
		}
		private var _mutiSelectEnable:Boolean=false;
		private var _items:Vector.<IToggle>=new Vector.<IToggle>();
		private var _selectedItem:IToggle;
		private var _selectedItems:Vector.<IToggle>=new Vector.<IToggle>();
		private var _dataProvider:Object;
		
		/**
		 * 数据绑定 
		 * @return 
		 * 
		 */
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:Object):void
		{
			_dataProvider = value;
			for (var prop:String in _dataProvider) {
				if (hasOwnProperty(prop)) {
					if(this[prop] is IDataBinding)
						IDataBinding(this[prop]).dataProvider=_dataProvider[prop];
					else
						this[prop] = _dataProvider[prop];
				}
			}
		}
		
		/**
		 * 允许多选 
		 * @return 
		 * 
		 */
		public function get mutiSelectEnable():Boolean
		{
			return _mutiSelectEnable;
		}

		public function set mutiSelectEnable(value:Boolean):void
		{
			_mutiSelectEnable = value;
			if(!_mutiSelectEnable){	//单选清除多选
				_selectedItems=new Vector.<IToggle>();
				selectedItem=null;
			}else{	//多选设置
				var itemArr:Array=[_selectedItem].slice();
				_selectedItem=null;
				selectedItems=Vector.<IToggle>(itemArr);
			}
		}

		/**
		 * 选中项 
		 * @return 
		 * 
		 */
		public function get selectedItem():IToggle
		{
			return _mutiSelectEnable?null:_selectedItem;
		}

		public function set selectedItem(value:IToggle):void
		{
			if(_mutiSelectEnable) return;
			if(_selectedItem !=value){
				_selectedItem=value;
				for each(var item:IToggle in _items){
					if(!item.toggleEnable) continue;
					var selected:Boolean=(item==_selectedItem?true:false);
					if(item.selected!=selected)
						item.selected=selected;
				}
				dispatchEvent(new ToggleGroupEvent(ToggleGroupEvent.SELECT_CHANGE));
			}
		}		
		
		/**
		 * 选中的所有项（多选时可用） 
		 * @return 
		 * 
		 */
		public function get selectedItems():Vector.<IToggle>
		{
			return _mutiSelectEnable?_selectedItems:null;
		}
		
		public function set selectedItems(value:Vector.<IToggle>):void
		{
			if(!_mutiSelectEnable) return;
			if(_selectedItems!=value){
				_selectedItems=value;
				for each(var item:IToggle in _items){
					if(!item.toggleEnable) continue;
					var selected:Boolean=(_selectedItems?(_selectedItems.indexOf(item)>-1?true:false):false)
					if(item.selected!=selected)
						item.selected=selected;
				}
				dispatchEvent(new ToggleGroupEvent(ToggleGroupEvent.SELECT_CHANGE));
			}
		}
		
		/**
		 * 选择某项 
		 * @param value
		 * 
		 */
		public function select(value:IToggle):void{
			if(!contains(value) || !value.toggleEnable) return;
			if(_mutiSelectEnable){
				var newItems:Vector.<IToggle>=_selectedItems.slice();
				var ind:int=newItems.indexOf(value);
				if(ind>-1)
					newItems.splice(ind,1);
				else
					newItems.push(value);
				selectedItems=newItems;
			}else{
				if(_selectedItem!=value){
					selectedItem=value;
				}
			}
		}
		
		/**
		 * 添加项 
		 * @param value
		 * @return 
		 * 
		 */
		public function addItem(value:IToggle):IToggle{
			if(_items.indexOf(value)<0)
				_items.push(value);
			return value;
		}
		
		/**
		 * 移除项 
		 * @param value
		 * @return 
		 * 
		 */
		public function removeItem(value:IToggle):IToggle{
			if(_selectedItem==value)
				selectedItem=null;
			if(_selectedItems){
				var temp:Vector.<IToggle>=_selectedItems.slice();
				if(temp.indexOf(value)>-1){
					temp.splice(temp.indexOf(value),1)
					selectedItems=temp;
				}
			}
			if(_items.indexOf(value)>-1)
				_items.splice(_items.indexOf(value),1);
			
			return value;
		}
		
		/**
		 * 移除所有项 
		 * 
		 */
		public function removeAll():void{
			selectedItem=null;
			selectedItems=new Vector.<IToggle>();
			_items=new Vector.<IToggle>();
		}
		
		/**
		 * 是否包含某项 
		 * @param value 项目
		 * @return 
		 * 
		 */
		public function contains(value:IToggle):Boolean{
			return _items.indexOf(value)>-1?true:false;
		}
		
		/**
		 * 释放 
		 * 
		 */
		override public function dispose():void{
			super.dispose();
			_items=null;
			_selectedItem=null;
			_selectedItems=null;
		}
	}
}