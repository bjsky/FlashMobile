package potato.component
{
	import flash.utils.Dictionary;
	
	import core.display.DisplayObject;
	
	import potato.component.classes.TextListItemRenderer;
	import potato.component.classes.ViewListItemRenderer;
	import potato.component.core.IList;
	import potato.component.core.IListItem;
	import potato.component.core.IRenderer;
	import potato.component.core.IToggle;
	import potato.component.event.ListEvent;
	import potato.component.event.ToggleGroupEvent;
	import potato.component.external.SpriteData;
	import potato.component.external.ViewManager;
	import potato.gesture.GestureEvent;
	import potato.gesture.TapGesture;

	/**
	 * 列表选择改变事件.
	 * @author liuxin
	 * 
	 */
	[Event(name="listSelectChange",type="potato.component.event.ListEvent")]
	
	/**
	 * 子项点击事件
	 * @author liuxin
	 * 
	 */
	[Event(name="listItemTap",type="potato.component.event.ListEvent")]
	/**
	 * 列表.
	 * <p>列表显示方式的组件，支持自定义渲染器，渲染器应当实现IListItem接口以便获取数据。</p>
	 * @author liuxin
	 */
	public class List extends ScrollContainer 
		implements IList,IRenderer
	{
		public function List(dataSource:Object=null,itemRender:Class=null,width:Number=NaN,height:Number=NaN)
		{
			super(width,height);
			this.selectType=SELECT_SINGLE;
			
			this.dataSource=dataSource;
			this.itemRender=itemRender;
		}
		
		static public const ITEM_TAP:String="itemTap";
		
		static public const HORIZONTAL:String="horizontal";
		static public const VERTICAL:String="vertical";
		
		static public const SELECT_NONE:String="SELECT_NONE";
		static public const SELECT_SINGLE:String="SELECT_Single";
		static public const SELECT_MUTI:String="SELECT_Muti";
		
		private var _direction:String="vertical";
		protected var _dataSource:Object;
		private var _scrollIndex:int;
		
		protected var _itemRender:*;
		private var _selectType:String="SELECT_Single";
		protected var _group:ToggleGroup;
		private var _selectedEventType:String=GestureEvent.TAP;
		
		private var _preCollection:Array;
		private var _preItemRender:*;
		private var _itemArr:Array=[];
		private var _optimization:Boolean=false;

		/**
		 * 是否支持渲染性能优化（需要渲染器支持数据重绘）
		 * @return 
		 * 
		 */
		public function get optimization():Boolean
		{
			return _optimization;
		}

		public function set optimization(value:Boolean):void
		{
			_optimization = value;
		}

		
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
					_group.addEventListener(ToggleGroupEvent.SELECT_CHANGE,onGroupSelectChange);
				}
				_group.mutiSelectEnable=(_selectType==SELECT_SINGLE?false:true);
			}else{
				if(_group)
				{
					_group.removeEventListener(ToggleGroupEvent.SELECT_CHANGE,onGroupSelectChange);
					_group=null;
				}
			}
		}
		
		
		/**
		 * 列表项改变事件处理 
		 * @param e
		 * 
		 */
		protected function onGroupSelectChange(e:ToggleGroupEvent):void{
//			trace("_____selectChange");
			groupSelectChange();
			var evt:ListEvent=new ListEvent(ListEvent.SELECT_CHANGE,this.selectItem,true);
			if(_group.mutiSelectEnable)
				evt.items=this.selectItems;
			this.dispatchEvent(evt);
		}
		
		/**
		 * 根据点击的原始目标查找项目 
		 * @param e
		 * 
		 */
		protected function onItemTap(e:GestureEvent):void{
			var tap:TapGesture=e.currentTarget as TapGesture;
			this.dispatchEvent(e.clone());
			if(e.type==_selectedEventType){
				this.dispatchEvent(new ListEvent(ListEvent.ITEM_TAP,IListItem(tap.target),true));
				var toggle:IToggle=tap.target as IToggle;
				if(_group && toggle && toggle.toggleEnable)
					_group.select(toggle);
			}
		}
		
		private function groupSelectChange():void{
			if(_selectType==SELECT_SINGLE){
				_selectIndex = _group?selectItem?getItemIndex(selectItem):-1:-1;
			}else if(_selectType== SELECT_MUTI){
				if(_group && selectItems){
					var indies:Array=[];
					for each(var item:IListItem in selectItems){
						indies.push(item?getItemIndex(item):-1);
					}
					_selectIndies= indies;
				}else
					_selectIndies=[];
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
			_preCollection=_collection;
			_dataSource=value;
			
			_collection=[];
			if(_dataSource is Array){	//只处理array
				_collection=_dataSource as Array;
			}else if(_dataSource is Vector.<*>){
				var temp:Vector.<*>=Vector.<*>(_dataSource).slice();
				for(_collection = [];temp.length>0;_collection.push(temp.shift())){} 
			}
			selectIndex=-1;
			selectIndies=[];
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
			_preItemRender=_itemRender;
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
		protected var _collection:Array=[];
		protected var _tapMap:Dictionary=new Dictionary();
		
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
			if(index>-1 && index<_collection.length){
				var item:Object=_collection[index];
				for each(var render:IListItem in _itemArr){
					if(render.data==item)
						return render;
				}
				return null;
			}else
				return null;
		}
		
		/**
		 * 获取元素的位置 
		 * @param item
		 * @return 
		 * 
		 */
		public function getItemIndex(render:IListItem):int{
			return _collection.indexOf(render.data);
		}
		
		override protected function render():void{
//			trace("_______render");
			
			//移除组事件和点击事件
			if(_group)
				_group.removeEventListener(ToggleGroupEvent.SELECT_CHANGE,onGroupSelectChange);
			
			//显示列表
			var render:IListItem;
			var tap:TapGesture;
			var i:int=0;
			var lp:Number=0;
			if(_preItemRender != _itemRender || !_optimization)		//渲染器改变，重新创建
			{
				_preItemRender=_itemRender;
				while(_itemArr.length>0){
					render=_itemArr.splice(_itemArr.length-1,1)[0];
					removeItemRender(render);
				}
				for each(var item:Object in _collection){
					_itemArr.push(addItemRender());
				}
			}else{				//渲染器未改变，改变渲染器个数
				if(_preCollection.length>_collection.length){
					i=0;
					while(i<_preCollection.length-_collection.length){
						render=_itemArr.splice(_itemArr.length-1,1)[0];
						removeItemRender(render);
						i++;
					}
				}else if(_preCollection.length<_collection.length){
					i=0;
					while(i<_collection.length-_preCollection.length){
						_itemArr.push(addItemRender());
						i++;
					}
				}
			}
			if(_group)
				_group.addEventListener(ToggleGroupEvent.SELECT_CHANGE,onGroupSelectChange);
			
			if(direction==HORIZONTAL){
				vScrollEnable=false;
			}else{
				hScrollEnable=false;
			}
			
			//位置和索引 ，数据和
			for (i=0;i< _collection.length;i++){
				render=_itemArr[i];
				render.index=i;
				render.data=_collection[i];
				
				var display:DisplayObject=DisplayObject(render);
				if(direction==HORIZONTAL){
					if(int(display.x)!=int(lp)){
						display.x=int(lp);
					}
					lp+=display.width;
				}else{
					if(int(display.y)!=int(lp)){
						display.y=int(lp);
					}
					lp+=display.height;
				}
			}
			
			//选中
			if(selectType==SELECT_SINGLE){
				if(selectIndex>-1){
					if(_group){
						selectItem=getItem(selectIndex);
					}
				}else{
					selectItem=null;
				}
			}else if(selectType==SELECT_MUTI){
				if(selectIndies.length>0){
					if(_group){
						var items:Vector.<IListItem>=new Vector.<IListItem>();
						for each(var index:int in selectIndies){
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
		
		private function removeItemRender(render:IListItem):void{
			if(_group && render is IToggle)
				_group.removeItem(IToggle(render));
			removeItemRenderListeners(DisplayObject(render));
			
			this.removeChild(DisplayObject(render));
			DisplayObject(render).dispose();
		}
		
		private function addItemRender():IListItem{
			var render:IListItem;
			if(_itemRender!=null){
				if(_itemRender is SpriteData){		//runtime
					render=ViewManager.createSprite(SpriteData(itemRender)) as ViewListItemRenderer;
				}else{
					render=new _itemRender() as IListItem;
					if(render is TextListItemRenderer)
						direction==VERTICAL?TextListItemRenderer(render).width=_width:TextListItemRenderer(render).height=_height;
				}
			}else
				render=new TextListItemRenderer();
			this.addChild(DisplayObject(render));
			
			if(_group && render is IToggle){
				IToggle(render).toggleEnable=true;
				_group.addItem(IToggle(render));
				addItemRenderListeners(DisplayObject(render));
			}
			
			return render;
		}
		
		/**
		 * 重写添加渲染项侦听的事件 
		 * @param render
		 * 
		 */
		protected function addItemRenderListeners(render:DisplayObject):void
		{
			var tap:TapGesture=new TapGesture(DisplayObject(render));
			tap.addEventListener(GestureEvent.TAP,onItemTap);
			tap.addEventListener(GestureEvent.GESTURE_TOUCH_BEGIN,onItemTap);
			_tapMap[render]=tap;
		}
		
		
		/**
		 * 重写移除渲染项侦听的事件 
		 * @param render
		 * 
		 */
		protected function removeItemRenderListeners(render:DisplayObject):void
		{
			var tap:TapGesture=_tapMap[render];
			if(tap){
				tap.removeEventListeners(GestureEvent.TAP);
				tap.removeEventListeners(GestureEvent.GESTURE_TOUCH_BEGIN);
				tap.dispose();
				tap=null;
				delete _tapMap[render];
			}
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
