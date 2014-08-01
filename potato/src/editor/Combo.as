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
	import potato.component.ISprite;
	import potato.component.List;
	import potato.component.Text;
	import potato.component.data.BitmapSkin;
	import potato.component.data.Padding;
	import potato.component.data.TextFormat;
	import potato.event.GestureEvent;
	import potato.event.ListEvent;
	import potato.gesture.TapGesture;
	
	/**
	 * 下拉框 ,编辑器使用
	 * @author liuxin
	 * 
	 */
	public class Combo extends DisplayObjectContainer
		implements ISprite
	{
		public function Combo(dataSource:Object=null,itemRender:Class=null,textFormat:TextFormat=null
							  ,width:Number=NaN,height:Number=NaN,listHeight:Number=NaN,listPadding:Padding=null)
		{
			super();
			createChildren();
			this.$dataSource=dataSource;
			this.$itemRender=itemRender;
			this.$textFormat=textFormat;
			this.$width=width;
			this.$height=height;
			this.$listHeight=listHeight;
			this.$listPadding=listPadding;
			render();
			selectIndex=-1;
		}
		




		public function setSkins(textSkin:BitmapSkin=null,listSkin:BitmapSkin=null,listWidthAdjust:Number=NaN
								 ,buttonUpSkin:BitmapSkin=null,buttonDownSkin:BitmapSkin=null
								  ,buttonMarginTop:Number=NaN,buttonMarginRight:Number=NaN):void{
			this.$textSkin=textSkin;
			this.$listSkin=listSkin;
			this.$listWidthAdjust=listWidthAdjust;
			this.$buttonUpSkin=buttonUpSkin;
			this.$buttonDownSkin=buttonDownSkin;
			this.$buttonMarginTop=buttonMarginTop;
			this.$buttonMarginRight=buttonMarginRight;
			render();
		}
		/**
		 * 默认宽度 
		 */		
		private static const DEFAULT_WIDTH:Number=150;
		//----------------------------
		//	ISprite
		//----------------------------
		protected var _width:Number;
		protected var _height:Number;
		protected var _scale:Number;
		protected var _disable:Boolean=false;

		/**
		 * 宽度
		 * @param value
		 * 
		 */
		public function set width(value:Number):void{
			$width=value;
			render();
		}
		override public function get width():Number{
			return _width;
		}
		
		public function set $width(value:Number):void{
			_width=value;
		}
		
		/**
		 * 高度 
		 * @param value
		 * 
		 */
		public function set height(value:Number):void{
			$height=value;
			renderText();
		}
		override public function get height():Number{
			return _height;
		}
		
		public function set $height(value:Number):void{
			_height=value;
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
		private var _listHeight:Number;
		private var _textSkin:BitmapSkin;
		private var _textFormat:TextFormat;
		private var _buttonUpSkin:BitmapSkin;
		private var _buttonDownSkin:BitmapSkin;
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
			$listWidthAdjust = value;
			renderList();
		}
		public function set $listWidthAdjust(value:Number):void
		{
			_listWidthAdjust = value;
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
			$listPadding = value;
			renderList();
		}
		public function set $listPadding(value:Padding):void
		{
			_listPadding = value;
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
			$buttonMarginTop = value;
			renderButton();
		}
		public function set $buttonMarginTop(value:Number):void
		{
			_buttonMarginTop = value;
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
			$buttonMarginRight=value;
			renderButton();
		}
		public function set $buttonMarginRight(value:Number):void{
			_buttonMarginRight = value;
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
			$listSkin = value;
			renderList();
		}
		public function set $listSkin(value:BitmapSkin):void
		{
			_listSkin = value;
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
			$buttonDownSkin = value;
			renderButton();
		}
		public function set $buttonDownSkin(value:BitmapSkin):void
		{
			_buttonDownSkin = value;
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
			$buttonUpSkin = value;
			renderButton();
		}
		public function set $buttonUpSkin(value:BitmapSkin):void
		{
			_buttonUpSkin = value;
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
			$textSkin = value;
			renderText();
		}
		public function set $textSkin(value:BitmapSkin):void
		{
			_textSkin = value;
		}
		
		/**
		 * 列表项渲染去 
		 * @return 
		 * 
		 */
		public function get itemRender():Class
		{
			return _list.itemRender;
		}
		
		public function set itemRender(value:Class):void
		{
			$itemRender = value;
			renderList();
		}
		public function set $itemRender(value:Class):void
		{
			_list.$itemRender=value;
		}
		
		/**
		 * 列表数据 
		 * @return 
		 * 
		 */
		public function get dataSource():Object
		{
			return _list.dataSource;
		}
		
		public function set dataSource(value:Object):void
		{
			$dataSource = value;
			renderList();
			selectIndex=-1;
		}
		public function set $dataSource(value:Object):void
		{
			_list.$dataSource=value;
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
			$listHeight = value;
			renderList();
		}
		public function set $listHeight(value:Number):void
		{
			_listHeight = value;
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
			$listColor = value;
			_listColorChanged=true;
			renderList();
		}
		public function set $listColor(value:uint):void
		{
			_listColor = value;
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
			$textFormat = value;
			renderText();
		}
		public function set $textFormat(value:TextFormat):void
		{
			_textFormat = value;
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
		
		public function set selectIndex(value:int):void
		{
			_list.selectIndex=value;
			$selectIndex = value;
		}
		
		public function set $selectIndex(value:int):void
		{
			var textStr:String="";
			if(_list.selectItem){
				textStr=_list.selectItem.label;
			}
			_txt.text=textStr;
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
			_list.verticalScrollerVisible=false;
			_list.horizontalScrollerVisible=false;
			_list.horizontalScrollEnable=false;
			_list.addEventListener(ListEvent.LIST_SELECT_CHANGE,onListChange);
			_list.addEventListener(ListEvent.LIST_ITEM_TAP,onListTap);
			_list.addEventListener(ListEvent.LIST_ITEM_DOUBLE_TAP,onListDoubleTap);
			_listContianer.addChild(_list);
		}
		
		//点击
		private function onTap(e:Event):void{
			_isShow=!_isShow;
			showList(_isShow);
		}
		
		private function showList(isShow:Boolean):void{
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
			$selectIndex=_list.selectIndex;
			this.dispatchEvent(new ListEvent(ListEvent.LIST_SELECT_CHANGE,e.item,true));
			_isShow=false;
			showList(_isShow);
		}
		
		private function onListTap(e:ListEvent):void{
			this.dispatchEvent(new ListEvent(ListEvent.LIST_ITEM_TAP,e.item,true));
		}
		
		private function onListDoubleTap(e:ListEvent):void{
			this.dispatchEvent(new ListEvent(ListEvent.LIST_ITEM_DOUBLE_TAP,e.item,true));
		}
		private var _prevStageX:Number=0;
		private var _prevStageY:Number=0;
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
		
		public function render():void
		{
			renderText();
			renderList();
		}
		
		private var _bgtd:TextureData;
		private var _barSha:Shape;
		private function renderList():void{
			var lw:Number=isNaN(_width)?DEFAULT_WIDTH:_width;
			//WidthAdjust
			lw+=isNaN(_listWidthAdjust)?0:_listWidthAdjust;
			//list
			_list.$width=lw-(listPadding?listPadding.paddingLeft+listPadding.paddingRight:0);
			if(!isNaN(_listHeight))
				_list.$height=_listHeight;
			_list.render();
			_list.x=listPadding?listPadding.paddingLeft:0;
			_list.y=listPadding?listPadding.paddingTop:0;
			var lh:Number=_list.height;
			//listBg
			if(_listSkin){
				_listBg.$skin=_listSkin;
				_listBg.$width=lw;
				_listBg.$height=lh+(listPadding?listPadding.paddingTop+listPadding.paddingBottom:0);
				_listBg.render();
			}else if(_listColorChanged){
				_bgtd=TextureData.createRGB(lw,lh);
				_barSha=new Shape();
				_barSha.graphics.beginFill(_listColor);
				_barSha.graphics.drawRect(0,0,lw,lh);
				_barSha.graphics.endFill();
				_bgtd.draw(_barSha);
				_listBg.$width=lw;
				_listBg.$height=lh+(listPadding?listPadding.paddingTop+listPadding.paddingBottom:0);
				_listBg.texture=new Texture(_bgtd);
			}
		}
		private function renderText():void{
			var lw:Number=isNaN(_width)?DEFAULT_WIDTH:_width;
			_txtBg.$skin=_textSkin;
			_txtBg.$width=lw;
			_txtBg.$height=_height;
			_txtBg.render();
			
			renderButton();
			var bw:Number=isNaN(_button.width)?0:_button.width;
			_txt.$width=lw-bw;
			_txt.$height=_txtBg.height;
			_txt.$textFormat=_textFormat;
			_txt.render();
		}
		
		private function renderButton():void{
			_button.$upSkin=_buttonUpSkin;
			_button.$downSkin=_buttonDownSkin;
			_button.render();
			var bw:Number=isNaN(_button.width)?0:_button.width;
			var bh:Number=isNaN(_button.height)?0:_button.height;
			_button.x=_txtBg.width-bw-(isNaN(_buttonMarginRight)?0:_buttonMarginRight);
			_button.y=isNaN(_buttonMarginTop)?(_txtBg.height-bh)/2:_buttonMarginTop;
		}
		
		public override function  dispose():void{
			super.dispose();
			showList(false);
			this.autoPosition=false;
			_txtTap.removeEventListener(GestureEvent.TAP,onTap);
			_txtTap.dispose();
			_list.removeEventListener(ListEvent.LIST_SELECT_CHANGE,onListChange);
			_list.removeEventListener(ListEvent.LIST_ITEM_TAP,onListTap);
			_list.removeEventListener(ListEvent.LIST_ITEM_DOUBLE_TAP,onListDoubleTap);
			
		}
	}
}