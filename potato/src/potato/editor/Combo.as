package potato.editor
{
	import flash.geom.Point;
	
	import core.display.DisplayObjectContainer;
	import core.display.Shape;
	import core.display.Stage;
	import core.display.Texture;
	import core.display.TextureData;
	import core.events.Event;
	
	import potato.component.Bitmap;
	import potato.component.Button;
	import potato.component.Container;
	import potato.component.List;
	import potato.component.Text;
	import potato.component.core.ISprite;
	import potato.component.core.RenderEvent;
	import potato.component.core.RenderManager;
	import potato.component.core.RenderType;
	import potato.component.data.BitmapSkin;
	import potato.component.data.Padding;
	import potato.component.data.TextFormat;
	import potato.component.event.ListEvent;
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
	 * 下拉框.
	 * @author liuxin
	 * 
	 */
	public class Combo extends DisplayObjectContainer
		implements ISprite
	{
		/**
		 * 创建一个下拉框 
		 * @param dataSource 数据源
		 * @param itemRender 渲染器
		 * @param skins 皮肤
		 * @param textFormat 文字样式
		 * @param width 宽
		 * @param height 高
		 * @param listHeight 列表高
		 * @param listPadding 列表填充
		 * 
		 */
		public function Combo(dataSource:Object=null,itemRender:Class=null,skins:ComboSkin=null,textFormat:TextFormat=null
							  ,width:Number=NaN,height:Number=NaN,listHeight:Number=NaN,listPadding:Padding=null)
		{
			super();
			createChildren();
			this.dataSource=dataSource;
			this.itemRender=itemRender;
			this.skins=skins;
			this.textFormat=textFormat;
			this.width=width;
			this.height=height;
			this.listHeight=listHeight;
			this.listPadding=listPadding;
			this.selectIndex=-1;
		}
		


//		/**
//		 * 默认宽度 
//		 */		
		private static const DEFAULT_WIDTH:Number=150;
		private static const DEFAULT_HEIGHT:Number=30;
		//----------------------------
		//	ISprite
		//----------------------------
		protected var _width:Number;
		protected var _height:Number;
		protected var _scale:Number;
		protected var _disable:Boolean=false;
		private var _renderType:uint=RenderType.CALLLATER;
		
		
		/**
		 * 渲染模式
		 * @return 
		 * 
		 */
		public function get renderType():uint
		{
			return _renderType;
		}
		
		public function set renderType(value:uint):void
		{
			_renderType = value;
			RenderManager.validateNow(this);
		}
		
		/**
		 * 组件失效
		 * @param method
		 * @param args
		 * 
		 */
		public function invalidate(method:Function, args:Array = null):void{
			RenderManager.invalidateProperty(this,method,args);
		}
		
		
		/**
		 * 验证
		 * 
		 */
		public function validate():void{
			render();
		}
		
		/**
		 * 宽度
		 * @param value
		 * 
		 */
		public function set width(value:Number):void{
			if(_width!=value){
				_width=value;
				invalidate(render);
			}
		}
		override public function get width():Number{
			if(!isNaN(_width))
				return _width;
			else
				return _textSkin?_textSkin.width:DEFAULT_WIDTH;
		}
		
		/**
		 * 高度 
		 * @param value
		 * 
		 */
		public function set height(value:Number):void{
			if(_height!=value){
				_height=value;
				invalidate(render);
			}
		}
		override public function get height():Number{
			if(!isNaN(_height))
				return _height;
			else
				return _textSkin?_textSkin.height:DEFAULT_HEIGHT;
		}
		
		/**
		 * 缩放 
		 * @param value
		 * 
		 */
		public function set scale(value:Number):void{
			_scale=value;
			scaleX=scaleY=_scale;
		}
		public function get scale():Number{
			return _scale;
		}
		
		//--------------------------
		//	property
		//--------------------------
		private var _skins:ComboSkin;
		private var _listHeight:Number;
		private var _textSkin:BitmapSkin;
		private var _textFormat:TextFormat;
		private var _buttonUpSkin:BitmapSkin;
		private var _buttonDownSkin:BitmapSkin;
		private var _buttonDisableSkin:BitmapSkin;
		private var _listSkin:BitmapSkin;
		private var _listColor:uint=0x0;
		private var _listColorChanged:Boolean=false;
		private var _listPadding:Padding;
		private var _listWidthAdjust:Number;
		private var _itemSkin:BitmapSkin;
		private var _itemSelectSkin:BitmapSkin;
		private var _autoPosition:Boolean=false;
		private var _buttonMarginRight:Number;
		private var _buttonMarginTop:Number;
		
		private var _itemRender:*;
		private var _dataSource:Object;
		private var _listSelectIndex:int=-1;
		/**
		 * 下拉框皮肤 
		 * @return 
		 * 
		 */		
		public function get skins():ComboSkin
		{
			return _skins;
		}
		
		public function set skins(value:ComboSkin):void
		{
			_skins = value;
			this.textSkin=value.textSkin;
			this.listSkin=value.listSkin;
			this.listWidthAdjust=value.listWidthAdjust;
			this.buttonUpSkin=value.buttonUpSkin;
			this.buttonDownSkin=value.buttonDownSkin;
			this.buttonDisableSkin=value.buttonDisableSkin;
			this.buttonMarginTop=value.buttonMarginTop;
			this.buttonMarginRight=value.buttonMarginRight;
		}
		
		/**
		 * 列表宽度调整 
		 * @return 
		 * 
		 */
		public function get listWidthAdjust():Number
		{
			return _listWidthAdjust;
		}
		
		public function set listWidthAdjust(value:Number):void
		{
			if(_listWidthAdjust!=value){
				_listWidthAdjust = value;
				invalidate(render);
			}
		}

		/**
		 * 列表内容边距 
		 * @return 
		 * 
		 */
		public function get listPadding():Padding
		{
			return _listPadding;
		}
		
		public function set listPadding(value:Padding):void
		{
			_listPadding = value;
			invalidate(render);
		}
		
		/**
		 * 按钮上边距 
		 * @return 
		 * 
		 */
		public function get buttonMarginTop():Number
		{
			return _buttonMarginTop;
		}
		
		public function set buttonMarginTop(value:Number):void
		{
			if(_buttonMarginTop!=value){
				_buttonMarginTop = value;
				invalidate(render);
			}
		}
		
		/**
		 * 按钮右边距 
		 * @return 
		 * 
		 */
		public function get buttonMarginRight():Number
		{
			return _buttonMarginRight;
		}
		
		public function set buttonMarginRight(value:Number):void
		{
			if(_buttonMarginRight!=value){
				_buttonMarginRight = value;
				invalidate(render);
			}
		}

		/**
		 * 自动定位 
		 * @return 
		 * 
		 */
		public function get autoPosition():Boolean
		{
			return _autoPosition;
		}
		
		public function set autoPosition(value:Boolean):void
		{
			_autoPosition = value;
			if(_list){
				if(_autoPosition){ 
					if(!_list.hasEventListener(Event.ENTER_FRAME))
						_list.addEventListener(Event.ENTER_FRAME,onFrame);
				}else{
					if(_list.hasEventListener(Event.ENTER_FRAME))
						_list.removeEventListener(Event.ENTER_FRAME,onFrame);
				}
			}
		}
		

		/**
		 * 列表背景皮肤 
		 * @return 
		 * 
		 */
		public function get listSkin():BitmapSkin
		{
			return _listSkin;
		}
		
		public function set listSkin(value:BitmapSkin):void
		{
			_listSkin = value;
			invalidate(render);
		}
		
		/**
		 * 按钮按下皮肤 
		 * @return 
		 * 
		 */
		public function get buttonDownSkin():BitmapSkin
		{
			return _buttonDownSkin;
		}
		
		public function set buttonDownSkin(value:BitmapSkin):void
		{
			_buttonDownSkin = value;
			invalidate(render);
		}

		/**
		 * 按钮正常皮肤 
		 * @return 
		 * 
		 */
		public function get buttonUpSkin():BitmapSkin
		{
			return _buttonUpSkin;
		}
		
		public function set buttonUpSkin(value:BitmapSkin):void
		{
			_buttonUpSkin = value;
			invalidate(render);
		}
		
		/**
		 * 按钮禁用皮肤 
		 * @return 
		 * 
		 */
		public function get buttonDisableSkin():BitmapSkin
		{
			return _buttonDisableSkin;
		}
		
		public function set buttonDisableSkin(value:BitmapSkin):void
		{
			_buttonDisableSkin = value;
			invalidate(render);
		}

		/**
		 * 文字皮肤 
		 * @return 
		 * 
		 */
		public function get textSkin():BitmapSkin
		{
			return _textSkin;
		}
		
		public function set textSkin(value:BitmapSkin):void
		{
			_textSkin = value;
			invalidate(render);
		}
		
		/**
		 * 列表项渲染去 
		 * @return 
		 * 
		 */
		public function get itemRender():Class
		{
			return _itemRender;
		}
		
		public function set itemRender(value:Class):void
		{
			_itemRender=value;
			invalidate(render);
		}
		
		/**
		 * 列表数据 
		 * @return 
		 * 
		 */
		public function get dataSource():Object
		{
			return _dataSource;
		}
		
		public function set dataSource(value:Object):void
		{
			_dataSource=value;
			selectIndex=-1;
			invalidate(render);
		}
		
		/**
		 * 列表高 
		 * @return 
		 * 
		 */
		public function get listHeight():Number
		{
			return _listHeight;
		}
		
		public function set listHeight(value:Number):void
		{
			if(_listHeight != value){
				_listHeight = value;
				invalidate(render);
			}
		}

		/**
		 * 列表背景颜色 
		 * @return 
		 * 
		 */
		public function get listColor():uint
		{
			return _listColor;
		}
		
		public function set listColor(value:uint):void
		{
			_listColor = value;
			_listColorChanged=true;
			invalidate(render);
		}

		/**
		 * 文字样式 
		 * @return 
		 * 
		 */
		public function get textFormat():TextFormat
		{
			return _textFormat;
		}
		
		public function set textFormat(value:TextFormat):void
		{
			_textFormat = value;
			invalidate(render);
		}
		
		/**
		 * 选中项索引 
		 * @return 
		 * 
		 */
		public function get selectIndex():int
		{
			return _list.selectIndex;
		}
		private var _selectIndex:int=-1;
		public function set selectIndex(value:int):void
		{
			if(_selectIndex!=value){
				_selectIndex=value;
				if(_selectIndex<0)
					_txt.text="";
				invalidate(render);
				
			}
		}
		//--------------------------
		// property
		//--------------------------
		private var _txtBg:Bitmap;		//文字背景
		private var _txtTap:TapGesture;
		private var _txt:Text;			//文字
		private var _button:Button;	//按钮
		private var _listBg:Bitmap;	//list背景
		private var _list:List;	//list
		private var _listContianer:Container;
		private var _isShow:Boolean=false;
		
		public function createChildren():void{
			_txtBg=new Bitmap();
			this.addChild(_txtBg);
			_txt=new Text();
			this.addChild(_txt);
			_txtTap=new TapGesture(this);
			_txtTap.addEventListener(GestureEvent.TAP,onTap);
			_button=new Button();
			this.addChild(_button);
			
			_listContianer=new Container();
			
			_listBg=new Bitmap();
			_listContianer.addChild(_listBg);
			_list=new List();
			_list.selectType=List.SELECT_SINGLE;
			_list.vScrollerVisible=false;
			_list.hScrollerVisible=false;
			_list.hScrollEnable=false;
//			_list.delayEnable=false;
			_list.addEventListener(ListEvent.SELECT_CHANGE,onListChange);
			_list.addEventListener(ListEvent.ITEM_TAP,onListItemTap);
			_listContianer.addChild(_list);
		}
		
		//点击
		private function onTap(e:Event):void{
			_isShow=!_isShow;
			showList(_isShow);
		}
		
		public function showList(isShow:Boolean):void{
			if(isShow){
				if(!_listContianer.parent){
					_listContianer.visible=false;
					Stage.getStage().addChild(_listContianer);
					if(!autoPosition){
						onFrame(null);
					}
				}
			}else{
				if(_listContianer.parent)
					_listContianer.parent.removeChild(_listContianer);
			}
		}
		
		//列表项改变
		private function onListChange(e:ListEvent):void{
			e.stopPropagation();
			this.dispatchEvent(new ListEvent(ListEvent.SELECT_CHANGE,e.item,true));
			e=null;
			
			_selectIndex=_list.selectIndex;
			if(_list.selectItem){
				_txt.text=_list.selectItem.label;
			}else{
				_txt.text="";
			}
			_isShow=false;
			showList(_isShow);
		}
		private function onListItemTap(e:ListEvent):void{
			e.stopPropagation();
			this.dispatchEvent(new ListEvent(ListEvent.ITEM_TAP,e.item,true));
			e=null;
		}
		
		private var _prevStageX:Number;
		private var _prevStageY:Number;
		private function onFrame(e:Event=null):void{
			var p:Point=parent.localToGlobal(new Point(x,y));
			if(p.x!=_prevStageX || p.y!=_prevStageY){
				_prevStageX=p.x;
				_prevStageY=p.y;
				
				_listContianer.x=_prevStageX;
				_listContianer.y=_prevStageY+_txtBg.height-1;
			}
			_listContianer.visible=true;
		}
		
		private function render():void
		{
			//txtBg
			_txtBg.skin=_textSkin;
			_txtBg.width=_width;
			_txtBg.height=_height;
			
			//button
			_button.upSkin=_buttonUpSkin;
			_button.downSkin=_buttonDownSkin;
			_button.x=_txtBg.width-_button.width-(isNaN(_buttonMarginRight)?0:_buttonMarginRight);
			_button.y=isNaN(_buttonMarginTop)?(_txtBg.height-_button.height)/2:_buttonMarginTop;
			
			//txt
			_txt.width=width-_button.width;
			_txt.height=_txtBg.height;
			_txt.textFormat=_textFormat;
			
			//list
			_list.width=listWidth-(listPadding?listPadding.paddingLeft+listPadding.paddingRight:0);
			if(!isNaN(_listHeight)){
				_list.height=_listHeight;
			}
			_list.dataSource=_dataSource;
			_list.itemRender=_itemRender;
			_list.x=listPadding?listPadding.paddingLeft:0;
			_list.y=listPadding?listPadding.paddingTop:0;
			_list.addEventListener(RenderEvent.RENDER_COMPLETE,function(e:RenderEvent):void{
				renderList();
			});
			_list.selectIndex=_selectIndex;
		}
		private function renderList():void{
			//list
			if(_listSkin){
				_listBg.skin=_listSkin;
				_listBg.width=listWidth;
				_listBg.height=_list.height+(listPadding?listPadding.paddingTop+listPadding.paddingBottom:0);
			}else if(_listColorChanged){
				_bgtd=TextureData.createRGB(listWidth,_list.height);
				_barSha=new Shape();
				_barSha.graphics.beginFill(_listColor);
				_barSha.graphics.drawRect(0,0,listWidth,_list.height);
				_barSha.graphics.endFill();
				_bgtd.draw(_barSha);
				_listBg.width=listWidth;
				_listBg.height=_list.height+(listPadding?listPadding.paddingTop+listPadding.paddingBottom:0);
				_listBg.texture=new Texture(_bgtd);
			}
		}
		
		private var _bgtd:TextureData;
		private var _barSha:Shape;
		
		private function get listWidth():Number{
			return isNaN(_listWidthAdjust)?width:width+_listWidthAdjust;
		}
		
		public override function  dispose():void{
			super.dispose();
			RenderManager.dispose(this);
			
			showList(false);
			this.autoPosition=false;
			_txtTap.removeEventListener(GestureEvent.TAP,onTap);
			_txtTap.dispose();
			_list.removeEventListener(ListEvent.SELECT_CHANGE,onListChange);
			_list.removeEventListener(ListEvent.ITEM_TAP,onListItemTap);
		}
	}
}