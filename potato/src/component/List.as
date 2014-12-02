package potato.component
{
	import flash.utils.Dictionary;
	
	import core.display.DisplayObject;
	
	import potato.component.classes.ListItemRenderer;
	import potato.component.classes.TextItemRenderer;
	import potato.component.data.SpriteData;
	import potato.component.interf.IList;
	import potato.component.interf.IListItem;
	import potato.component.interf.IRenderer;
	import potato.component.interf.IToggle;
	import potato.event.GestureEvent;
	import potato.event.ListEvent;
	import potato.event.PotatoEvent;
	import potato.gesture.TapGesture;
	import potato.manager.ViewManager;

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
	 * 列表.
	 * <p>通过列表来呈现列表显示方式的数据内容，如果不使用自定义的渲染器则默认为DefaultListItemRenderer文本渲染器。</p>
	 * <p>如果需要自定义项目渲染器，渲染器应当实现IListItem接口。</p>
	 * @author liuxin
	 * @see DefaultListItemRenderer
	 */
	public class List extends ScrollableContainer 
		implements IList,IRenderer
	{
		public function List(dataSource:Object=null,itemRender:Class=null,width:Number=NaN,height:Number=NaN)
		{
			super(width,height);
			this.selectType=SELECT_NONE;
			
			this.dataSource=dataSource;
			this.itemRender=itemRender;
			
//			_itemTap=new TapGesture(this);
//			_itemTap.addEventListener(GestureEvent.TAP,onItemTap);
		}
		
		static public const ITEM_TAP:String="itemTap";
		
		static public const HORIZONTAL:String="horizontal";
		static public const VERTICAL:String="vertical";
		
		static public const SELECT_NONE:String="SELECT_NONE";
		static public const SELECT_SINGLE:String="SELECT_Single";
		static public const SELECT_MUTI:String="SELECT_Muti";
		
		private var _direction:String="vertical";
		private var _dataSource:Object;
		private var _scrollIndex:int;
		
		private var _itemRender:*;
		private var _selectType:String="SELECT_Single";
		private var _group:ToggleGroup;
		private var _selectedEventType:String=GestureEvent.TAP;
		//-----------------------------
		//	IGroup
		//------------------------------

		public function get selectedEventType():String
		{
			return _selectedEventType;
		}

		public function set selectedEventType(value:String):void
		{
			_selectedEventType = value;
		}

		/**
		 * 选择类型 
		 * @return 
		 * 
		 */
		public function get selectType():String
		{
			return _selectType;
		}

		public function set selectType(value:String):void
		{
			_selectType = value;
			if(_selectType!=SELECT_NONE){
				if(!_group){
					_group=new ToggleGroup();
					_group.addEventListener(PotatoEvent.GROUP_SELECT_CHANGE,onGroupSelectChange);
				}
				_group.mutiSelectEnable=(_selectType==SELECT_SINGLE?false:true);
			}else{
				if(_group)
				{
					_group.removeEventListener(PotatoEvent.GROUP_SELECT_CHANGE,onGroupSelectChange);
					_group=null;
				}
			}
		}
		
		/**
		 * 列表项改变事件处理 
		 * @param e
		 * 
		 */
		private function onGroupSelectChange(e:PotatoEvent):void{
//			trace("_____selectChange");
			groupSelectChange();
			var evt:ListEvent=new ListEvent(ListEvent.LIST_SELECT_CHANGE,this.selectItem,true);
			if(_group.mutiSelectEnable)
				evt.items=this.selectItems;
			this.dispatchEvent(evt);
		}
		
		/**
		 * 根据点击的原始目标查找项目 
		 * @param e
		 * 
		 */
		private function onItemTap(e:GestureEvent):void{
			var tap:TapGesture=e.currentTarget as TapGesture;
			this.dispatchEvent(e.clone());
			if(e.type==_selectedEventType){
				this.dispatchEvent(new ListEvent(ListEvent.LIST_ITEM_TAP,IListItem(tap.target),true));
				if(_group && tap.target is IToggle)
					_group.select(IToggle(tap.target));
			}
		}
		
		private var _selectIndex:int=-1;
		private var _selectIndies:Array=[];
		
		
		/**
		 * 选中索引 
		 * @param value
		 * 
		 */
		public function set selectIndex(value:int):void
		{
			if(_selectIndex!=value){
				_selectIndex=value;
				invalidate(render);
			}
		}
		
		public function get selectIndex():int
		{
			return _selectIndex;
		}
		
		private function groupSelectChange():void{
			if(_selectType==SELECT_SINGLE){
				_selectIndex = _group?getItemIndex(selectItem):-1;
			}else if(_selectType== SELECT_MUTI){
				if(_group && selectItems){
					var indies:Array=[];
					for each(var item:IListItem in selectItems){
						indies.push(getItemIndex(item));
					}
					_selectIndies= indies;
				}else
					_selectIndies=[];
			}
		}
		/**
		 * 选中索引数组（多选时可用） 
		 * @return 
		 * 
		 */
		public function get selectIndies():Array
		{
			return _selectIndies;
		}
		
		public function set selectIndies(value:Array):void
		{
			_selectIndies=value;
			invalidate(render);
		}

		/**
		 * 选中项 
		 * @return 
		 * 
		 */
		public function get selectItem():IListItem
		{
			return _group?IListItem(_group.selectedItem):null;
		}

		public function set selectItem(value:IListItem):void
		{
			if(_group){
				_group.selectedItem=(value is IToggle?IToggle(value):null);
			}
		}

		/**
		 * 选中的所有项（多选时可用）
		 * @return 
		 * 
		 */
		public function get selectItems():Vector.<IListItem>
		{
			if(_group && _group.selectedItems){
				var items:Vector.<IListItem>=new Vector.<IListItem>();
				for each(var item:IToggle in _group.selectedItems){
					items.push(IListItem(item));
				}
				return items;
			}else
				return null;
		}
		
		public function set selectItems(value:Vector.<IListItem>):void
		{
			if(_group){
				var items:Vector.<IToggle>=new Vector.<IToggle>();
				for each(var item:IListItem in value){
					if(item is IToggle)
						items.push(IToggle(item));
				}
				_group.selectedItems=items;
			}
		}
		

		/**
		 * 数据源 
		 * @param value
		 * 
		 */
		public function set dataSource(value:Object):void
		{
			_dataSource=value;
			
			_collection=[];
			if(_dataSource is Array){	//只处理array
				_collection=_dataSource as Array;
			}else if(_dataSource is Vector.<*>){
				var temp:Vector.<*>=Vector.<*>(_dataSource).slice();
				for(_collection = [];temp.length>0;_collection.push(temp.shift())){} 
			}
			_selectIndex=-1;
			_selectIndies=[];
			invalidate(render);
		}
		public function get dataSource():Object
		{
			return _dataSource;
		}
		
		/**
		 * 列表方向 
		 * @return 
		 * 
		 */
		public function get direction():String
		{
			return _direction;
		}
		
		public function set direction(value:String):void
		{
			if(_direction!=value){
				_direction = value;
				invalidate(render);
			}
		}
		
		/**
		 * 内容渲染器，Class类型
		 * @return 
		 * 
		 */
		public function get itemRender():*
		{
			return _itemRender;
		}
		
		public function set itemRender(value:*):void
		{
			_itemRender = value;
			invalidate(render);
		}

		/**
		 * 滚动位置 
		 * @return 
		 * 
		 */
		public function get scrollIndex():int
		{
			return _scrollIndex;
		}
		
		public function set scrollIndex(value:int):void
		{
			_scrollIndex = value;
		}
		
		//-----------------------
		// item collection
		//-----------------------
		private var _collection:Array=[];
		private var _itemMap:Dictionary=new Dictionary();
		private var _tapMap:Dictionary=new Dictionary();
		
//		/**
//		 * 添加一个数据项 
//		 * @param data
//		 * @return 
//		 * 
//		 */
//		public function add(data:Object):IListItem{
//			_collection.push(data);
//			invalidate(render);
//			return _itemMap[data];
//		}
//		/**
//		 * 添加一个数据项到index 
//		 * @param data
//		 * @param index
//		 * @return 
//		 * 
//		 */
//		public function addAt(data:Object,index:int):IListItem{
//			_collection.splice(index,0,data);
//			invalidate(render);
//			return _itemMap[data];
//		}
//		/**
//		 * 移除一个数据项 
//		 * @param data
//		 * @return 
//		 * 
//		 */
//		public function remove(data:Object):IListItem{
//			var ret:IListItem=_itemMap[data];
//			_collection.splice(_collection.indexOf(data),1);
//			invalidate(render);
//			return ret;
//		}
//		/**
//		 * 移除index位置的一个数据项 
//		 * @param index
//		 * @return 
//		 * 
//		 */
//		public function removeAt(index:int):IListItem{
//			var data:Object=_collection[index];
//			return remove(data);
//		}
//		
		/**
		 * 获取index位置的元素 
		 * @param index
		 * @return 
		 * 
		 */
		public function getItem(index:int):IListItem{
			if(index>-1 && index<_collection.length)
				return _itemMap[_collection[index]];
			else
				return null;
		}
		
		/**
		 * 获取元素的位置 
		 * @param item
		 * @return 
		 * 
		 */
		public function getItemIndex(item:IListItem):int{
			var data:Object;
			for (var key:Object in _itemMap){
				if(_itemMap[key]==item){
					data=key;
					break;
				}
			}
			return _collection.indexOf(data);
		}
		
		private function removeItems():void{
			if(_group){
				//渲染时的移除子项并不会处理
				_group.removeEventListener(PotatoEvent.GROUP_SELECT_CHANGE,onGroupSelectChange);
				_group.removeAll();
				_group.addEventListener(PotatoEvent.GROUP_SELECT_CHANGE,onGroupSelectChange);
			}
			
			for each(var lstitem:DisplayObject in _itemMap){
				var tap:TapGesture=_tapMap[lstitem];
				if(tap){
					tap.removeEventListeners(GestureEvent.TAP);
					tap.removeEventListeners(GestureEvent.GESTURE_TOUCH_BEGIN);
					tap.dispose();
					tap=null;
					delete _tapMap[lstitem];
				}
				this.removeChild(DisplayObject(lstitem));
				DisplayObject(lstitem).dispose();
				lstitem=null;
				delete _itemMap[lstitem];
			}
			_itemMap=new Dictionary();
			
		}
		
		/**
		 * 渲染组件内容 
		 * 
		 */		
		override protected function render():void{
//			trace("_______renderlist");
			//渲染子项
			removeItems();
			
			var item:DisplayObject;
			var lp:Number=0;
			
			if(direction==HORIZONTAL){
				vScrollEnable=false;
			}else{
				hScrollEnable=false;
			}
			
			var i:int=0;
			for each(var data:Object in _collection){
				if(itemRender!=null){
					if(itemRender is SpriteData){		//runtime
						item=ViewManager.createSprite(SpriteData(itemRender)) as ListItemRenderer;
					}else{
						item=new itemRender() as DisplayObject;
						if(item is TextItemRenderer)
							direction==VERTICAL?TextItemRenderer(item).width=_width:TextItemRenderer(item).height=_height;
					}
				}else
					item=new TextItemRenderer();
				if(item is IListItem){
					IListItem(item).index=i;
					IListItem(item).data=data;
				}
				addChild(item);
				if(direction==HORIZONTAL){
					item.x=lp;
					lp+=item.width;
				}else{
					item.y=lp;
					lp+=item.height;
				}
				
				_itemMap[data]=item;
				if(_group && item is IToggle){
					_group.addItem(IToggle(item));
					var tap:TapGesture=new TapGesture(item);
					tap.addEventListener(GestureEvent.TAP,onItemTap);
					tap.addEventListener(GestureEvent.GESTURE_TOUCH_BEGIN,onItemTap);
					_tapMap[item]=tap;
				}
				i++;
			}
			
			if(selectType==SELECT_SINGLE){
				if(_selectIndex>-1){
					if(_group){
						selectItem=getItem(_selectIndex);
					}
				}else{
					selectItem=null;
				}
			}else if(selectType==SELECT_MUTI){
				if(_selectIndies.length>0){
					if(_group){
						var items:Vector.<IListItem>=new Vector.<IListItem>();
						for each(var index:int in _selectIndies){
							items.push(getItem(index));
						}
						selectItems=items;
					}
				}else{
					selectItems=null;
				}
			}
			
			super.render();
		}
		
		/**
		 * 释放资源 
		 * 
		 */
		override public function dispose():void
		{
			dataSource=null;
			if(_group){
				_group.dispose();
				_group=null;
			}
			super.dispose();
		}
		
	}
}
