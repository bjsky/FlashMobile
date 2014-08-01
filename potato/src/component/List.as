package potato.component
{
	import flash.utils.Dictionary;
	
	import core.display.DisplayObject;
	import core.events.Event;
	
	import potato.component.classes.DefaultListItemRenderer;
	import potato.event.GestureEvent;
	import potato.event.ListEvent;
	import potato.event.UIEvent;
	import potato.gesture.DoubleTapGesture;
	import potato.gesture.TapGesture;

	/**
	 * 带滚动容器的list，如果没有滚动需求，使用pagelist(轻量)
	 * @author liuxin
	 * 
	 */
	public class List extends ScrollContainer 
		implements IList,IRenderer
	{
		public function List(dataSource:Object=null,itemRender:Class=null,width:Number=NaN,height:Number=NaN)
		{
			selectType=SELECT_NONE;
			
			$dataSource=dataSource;
			$itemRender=itemRender;
			$width=width;
			$height=height;
			
			super();
		}
		
		
		static public const HORIZONTAL:String="horizontal";
		static public const VERTICAL:String="vertical";
		
		static public const SELECT_NONE:String="SELECT_NONE";
		static public const SELECT_SINGLE:String="SELECT_Single";
		static public const SELECT_MUTI:String="SELECT_Muti";
		
		private var _direction:String="vertical";
		private var _dataSource:Object;
		private var _scrollIndex:int;
		private var _itemRender:Class;
		private var _selectType:String="SELECT_Single";
		private var _group:Group;

		//-----------------------------
		//	IGroup
		//------------------------------

		public function get selectType():String
		{
			return _selectType;
		}

		public function set selectType(value:String):void
		{
			_selectType = value;
			if(_selectType!=SELECT_NONE){
				if(!_group){
					_group=new Group();
					_group.addEventListener(UIEvent.GROUP_SELECT_CHANGE,onGroupSelectChange);
				}
				_group.mutiSelectEnable=(_selectType==SELECT_SINGLE?false:true);
			}else{
				if(_group)
				{
					_group.removeEventListener(UIEvent.GROUP_SELECT_CHANGE,onGroupSelectChange);
					_group=null;
				}
			}
		}
		
		private function onGroupSelectChange(e:UIEvent):void{
			this.dispatchEvent(new ListEvent(ListEvent.LIST_SELECT_CHANGE,this.selectItem,true));
		}
		
		private function onItemTap(e:Event):void{
			var tap:TapGesture=e.currentTarget as TapGesture;
			this.dispatchEvent(new ListEvent(ListEvent.LIST_ITEM_TAP,IListItem(tap.target),true));
			if(_group && tap.target is IGroupItem)
				_group.select(IGroupItem(tap.target));
		}
		private function onDoubleTap(e:Event):void{
			var tap:DoubleTapGesture=e.currentTarget as DoubleTapGesture;
			this.dispatchEvent(new ListEvent(ListEvent.LIST_ITEM_DOUBLE_TAP,IListItem(tap.target),true));
		}
		
		public function set selectIndex(value:int):void
		{
			if(_group){
				selectItem=getItem(value);
			}
		}
		
		public function get selectIndex():int
		{
			return _group?getItemIndex(selectItem):-1;
		}
		
		public function get selectIndies():Array
		{
			if(_group && selectItems){
				var indies:Array=[];
				for each(var item:IListItem in selectItems){
					indies.push(getItemIndex(item));
				}
				return indies;
			}else
				return null;
		}
		
		public function set selectIndies(value:Array):void
		{
			if(_group){
				var items:Vector.<IListItem>=new Vector.<IListItem>();
				for each(var index:int in value){
					items.push(getItem(index));
				}
				selectItems=items;
			}
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
			if(_group && value is IGroupItem){
				_group.selectedItem=IGroupItem(value);
			}
		}

		/**
		 * 选中的所有项 
		 * @return 
		 * 
		 */
		public function get selectItems():Vector.<IListItem>
		{
			if(_group && _group.selectedItems){
				var items:Vector.<IListItem>=new Vector.<IListItem>();
				for each(var item:IGroupItem in _group.selectedItems){
					items.push(IListItem(item));
				}
				return items;
			}else
				return null;
		}
		
		public function set selectItems(value:Vector.<IListItem>):void
		{
			if(_group){
				var items:Vector.<IGroupItem>=new Vector.<IGroupItem>();
				for each(var item:IListItem in value){
					if(item is IGroupItem)
						items.push(IGroupItem(item));
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
			$dataSource=value;
			render();
		}
		public function get dataSource():Object
		{
			return _dataSource;
		}
		public function set $dataSource(value:Object):void{
			_dataSource=value;
			
			
			_collection=[];
			if(_dataSource is Array){	//只处理array
				_collection=_dataSource as Array;
			}else if(_dataSource is Vector.<*>){
				var temp:Vector.<*>=Vector.<*>(_dataSource).slice();
				for(_collection = [];temp.length>0;_collection.push(temp.shift())){} 
			}
		}
		
		/**
		 * 方向 
		 * @return 
		 * 
		 */
		public function get direction():String
		{
			return _direction;
		}
		
		public function set direction(value:String):void
		{
			$direction=value;
			render();
		}
		public function set $direction(value:String):void{
			_direction = value;
		}
		
		/**
		 * 内容渲染器,未指定使用Text
		 * @return 
		 * 
		 */
		public function get itemRender():Class
		{
			return _itemRender;
		}
		
		public function set itemRender(value:Class):void
		{
			$itemRender=value;
			render();
		}
		public function set $itemRender(value:Class):void{
			_itemRender = value;
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
		private var _itemMap:Dictionary=new Dictionary(true);
		private var _tapMap:Dictionary=new Dictionary();
		private var _doubleTapMap:Dictionary=new Dictionary();
		
		/**
		 * 添加一个数据项 
		 * @param data
		 * @return 
		 * 
		 */
		public function add(data:Object):IListItem{
			_collection.push(data);
			render();
			return _itemMap[data];
		}
		/**
		 * 添加一个数据项到index 
		 * @param data
		 * @param index
		 * @return 
		 * 
		 */
		public function addAt(data:Object,index:int):IListItem{
			_collection.splice(index,0,data);
			render();
			return _itemMap[data];
		}
		/**
		 * 移除一个数据项 
		 * @param data
		 * @return 
		 * 
		 */
		public function remove(data:Object):IListItem{
			var ret:IListItem=_itemMap[data];
			_collection.splice(_collection.indexOf(data),1);
			render();
			return ret;
		}
		/**
		 * 移除index位置的一个数据项 
		 * @param index
		 * @return 
		 * 
		 */
		public function removeAt(index:int):IListItem{
			var data:Object=_collection[index];
			return remove(data);
		}
		
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
				_group.removeAll();
			}
			
			while(numChildren>0){
				var item:DisplayObject=getChildAt(0);
				removeChild(item);
			}
			for each(var lstitem:IListItem in _itemMap){
				var tap:TapGesture=_tapMap[lstitem];
				if(tap){
					tap.removeEventListeners(GestureEvent.TAP);
					tap.dispose();
					tap=null;
					delete _tapMap[lstitem];
				}
				var double:DoubleTapGesture=_doubleTapMap[lstitem]
				if(double){
					double.removeEventListeners(GestureEvent.DOUBLE_TAP);
					double.dispose();
					double=null;
					delete _doubleTapMap[lstitem];
				}
				_itemMap[lstitem]=null;
				delete _itemMap[lstitem];
				DisplayObject(lstitem).dispose();
				lstitem=null;
			}
			
			_doubleTapMap=new Dictionary();
			_tapMap=new Dictionary();
			_itemMap=new Dictionary(true);
			
		}
		override public function render():void{
			
			//渲染子项
			removeItems();
			var item:DisplayObject;
			var lp:Number=0;
			
			if(direction==HORIZONTAL){
				verticalScrollEnable=false;
			}else{
				horizontalScrollEnable=false;
			}
			
			var i:int=0;
			for each(var data:Object in _collection){
				if(itemRender!=null){
					item=new itemRender() as DisplayObject;
					if(item is DefaultListItemRenderer)
						DefaultListItemRenderer(item).$width=width;
				}else
					item=new DefaultListItemRenderer();
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
				if(_group && item is IGroupItem){
					_group.addItem(IGroupItem(item));
					var tap:TapGesture=new TapGesture(item);
					tap.addEventListener(GestureEvent.TAP,onItemTap);
					var double:DoubleTapGesture=new DoubleTapGesture(item);
					double.addEventListener(GestureEvent.DOUBLE_TAP,onDoubleTap);
					_tapMap[item]=tap;
					_doubleTapMap[item]=double;
				}
				i++;
			}
			
			super.render();
		}
		
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
