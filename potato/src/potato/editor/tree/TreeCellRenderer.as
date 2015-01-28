package potato.editor.tree
{
	import flash.utils.Dictionary;
	
	import core.display.DisplayObjectContainer;
	import core.display.Shape;
	import core.display.TextureData;
	import core.events.Event;
	import core.text.TextField;
	
	import potato.component.Bitmap;
	import potato.component.core.IListItem;
	import potato.component.core.ISprite;
	import potato.component.core.RenderManager;
	import potato.component.core.RenderType;
	import potato.component.data.BitmapSkin;
	import potato.component.data.Padding;
	import potato.component.data.TextFormat;
	import potato.gesture.GestureEvent;
	import potato.gesture.LongPressGesture;
	import potato.gesture.TapGesture;
	import potato.utils.Size;
	import potato.utils.SkinUtil;
	
	/**
	 * 树组件程视项渲染器
	 * @author EricXie
	 * 
	 */	
	public class TreeCellRenderer extends DisplayObjectContainer implements ISprite, IListItem
	{
		/**
		 *Icon打开状态 
		 */		
		static private const NODE_OPEN:uint=1;			
		/**
		 *Icon关闭状态 
		 */			
		static private const NODE_CLOSE:uint=0;
		/**
		 *背景选中状态
		 */		
		static private const BG_SELECTED:uint=1;
		/**
		 *背景非选中状态 
		 */		
		static private const BG_UNSELECTED:uint=0;
		/**
		 *默认组件宽度 
		 */		
		static private const DEFAULT_WIDTH:int = 200;
		//		文本
		protected var _label:String;
		//		索引
		protected var _index:int;
		/**
		 *大小 
		 */		
		public var fontSize:int=28;
		//		长度测量文本
		static private var toolText:TextField =new TextField("",2048,2048,"Verdana",28,0xFFFFFF);
		//		图标
		protected var _icon:Bitmap;
		//		选择项背景皮肤
		protected var _bgBitmap:Bitmap;
		//		皮肤字段
		protected var _iconSkins:String="";
		//		背景皮肤字段
		//		皮肤数组
		protected var _iconSkinsArr:Array=["",""];
		//		背景皮肤数组
		protected var _bgSkin:BitmapSkin;
		//		图标皮肤字典
		protected var _iconSkinsMap:Dictionary=new Dictionary();
		//		背景材质
		protected var bgTextrue:TextureData;
		//		label文字
		protected var _textField:TextField;
		//		置灰
		protected var _disable:Boolean=false;
		//		当前状态
		protected var _state:uint=NODE_CLOSE;
		//		是否选中
		protected var _selected:Boolean=false;
		/**
		 *字体格式 
		 */		
		public var textFormat:TextFormat;
		/**
		 *宽度 
		 */			
		private var _width:Number;
		/**
		 *高度 
		 */			
		private var _height:Number;
		/**
		 *选框和文字之间的间隙 
		 */			
		public var gap:Number=5;
		/**
		 *字体 
		 */		
		public var font:String="Verdana";
		
		/**
		 *间距 
		 */		
		public var textPadding:Padding;
		//		初始化
		private var initBoolean:Boolean=false;
		//		是否具有子项
		private var hasChildNodes:Boolean;
		//		子项数组
		private var _childNodes:Vector.<TreeCellRenderer>=new Vector.<TreeCellRenderer>;
		//		层级
		private var _level:int;
		//		X缩进值
		protected var paddingX:int=10;
		//		父节点渲染器
		private var _parentNode:TreeCellRenderer;
		//		是否具有父节点
		private var _hasParentNode:Boolean;
		//		数据
		private var _data:TreeCellRendererVO;
		/**
		 *是否展开显示 
		 */		
		public var shows:Boolean=false;
		/**
		 * 是否自动展开 
		 */		
		public var autoOpenUp:Boolean=true;
		//		当前项是否选中
		private var _selectedItemBoolean:Boolean=false;
		private var _scaleX:Number;
		private var iconTapGesture:TapGesture;
		private var tapGesture:TapGesture;
		private var downPress:LongPressGesture;

		private var _renderType:uint=RenderType.CALLLATER;
		
		/**
		 * 构造函数  
		 */		
		public function TreeCellRenderer()
		{
			super();
			createChildren();
		}
		
		/**
		 * 渲染模式
		 * @return 
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
		 */
		public function invalidate(method:Function, args:Array = null):void
		{
			RenderManager.invalidateProperty(this,method,args);
		}
		
		/**
		 * 验证
		 */
		public function validate():void
		{
			render();
		}
		
		/**
		 * 皮肤字符串 [正常，按下]
		 * @param value
		 */
		public function set iconSkins(value:String):void
		{
			_iconSkins=value;	
			_iconSkinsArr=SkinUtil.fillArray(_iconSkinsArr,value,String);
			for (var i:int=0;i<_iconSkinsArr.length;i++){
				var skinStr:String=_iconSkinsArr[i];
				if(skinStr){
					_iconSkinsMap[i]=new BitmapSkin(skinStr);
				}
			}
		}
		
		public function get iconSkins():String
		{
			return _iconSkins;
		}
		
		/**
		 *背景皮肤 字段  
		 * @return 
		 * 
		 */		
		public function get bgSkin():BitmapSkin
		{
			return _bgSkin;
		}

		public function set bgSkin(skin:BitmapSkin):void
		{
			if (skin != null){
				_bgSkin = skin;
			}else{
				_bgSkin = new BitmapSkin(createRectTexture(0xCCAAAA, -1, 10, 10));
			}
		}
		
		/**
		 *是否被选中 
		 * @return 
		 * 
		 */		
		public function get selectedItemBoolean():Boolean
		{
			return _selectedItemBoolean;
		}

		public function set selectedItemBoolean(value:Boolean):void
		{
			if(_selectedItemBoolean==value) return;
			_selectedItemBoolean=value;
			render();
		}

		/**
		 * 文本 
		 * @return 
		 * 
		 */
		public function get text():String
		{
			return _label;
		}
		
		public function set text(value:String):void
		{
			_label=value;
		}
		
		/**
		 * 关闭状态皮肤 
		 * @param value
		 * 
		 */
		public function set closeSkin(value:BitmapSkin):void
		{
			_iconSkinsMap[NODE_CLOSE]=value;
		}
		
		public function get closeSkin():BitmapSkin
		{
			return _iconSkinsMap[NODE_CLOSE];
		}
	
		/**
		 * 打开状态皮肤，如果没有使用正常皮肤 
		 * @param value
		 */
		public function set openSkin(value:BitmapSkin):void
		{
			_iconSkinsMap[NODE_OPEN]=value;
		}
		
		public function get openSkin():BitmapSkin
		{
			return _iconSkinsMap[NODE_OPEN];
		}
		
		/**
		 * 子节点的数据 Array<TreeCellRenderer>
		 */
		public function get childNodes():Vector.<TreeCellRenderer>
		{
			return _childNodes;
		}
		
		/**
		 * @private
		 */
		public function set childNodes(value:Vector.<TreeCellRenderer>):void
		{
			_childNodes = value;
			hasChildNodes = true;
		}
		
		/**
		 *父节点的数据
		 */
		public function get parentNode():TreeCellRenderer 
		{
			return _parentNode;
		}
		
		/**
		 * @private
		 */
		public function set parentNode(value:TreeCellRenderer):void
		{
			_parentNode = value;
			
			if (_parentNode != null) {
				this._hasParentNode = true;
			}
		}
		
		/**
		 * 是否打开或关闭子项
		 * @param value
		 */
		public function set selected(value:Boolean):void
		{
			_selected=value;
			if(value){
				_state=NODE_OPEN;
				_hasParentNode=true;
			}else{
				_state=NODE_CLOSE;
				_hasParentNode=false;
			}
			
			for(var i:uint=0;i<this._childNodes.length;i++){
				_childNodes[i].shows=value;
			}
			//建议手动render
			render();
		}
		
		/**
		 * 是否打开或关闭子项 
		 * @return 
		 */		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		/**
		 * 宽度
		 * @param value
		 */
		public function set width(value:Number):void
		{
			if (_width != value)
			{
				_width=value;
				invalidate(render);
			}
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		/**
		 * 高度 
		 * @param value
		 */
		public function set height(value:Number):void
		{
			if (_height != value)
			{
				_height=value;
				invalidate(render);
			}
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		/**
		 * 缩放 
		 * @param value
		 */
		public function set scale(value:Number):void
		{
			_scaleX=scaleY=value;
		}
		
		public function get scale():Number
		{
			return _scaleX;
		}
		
		/**
		 * 层级 
		 * @return 
		 */		
		public function get level():int 
		{
			return _level;
		}
		
		public function set level(value:int):void
		{
			_level = value;
			if (value != 0) {
				this.x = paddingX*_level;
			}else{
				shows=true;
			}
		}
		
		/**
		 * 获取文本宽度
		 * @param txt
		 * @param fontName
		 * @param fontSize
		 * @return 
		 */
		public static function getTextSize(txt:String, fontName:String, fontSize:int):Size 
		{
			toolText.fontName = fontName;
			toolText.fontSize = fontSize;
			toolText.text = txt;
			
			return new Size(toolText.textWidth + 4, toolText.textHeight + 4);
		}

		/**
		 * 创建渲染块
		 */		
		protected function createChildren():void
		{
			_bgBitmap=new Bitmap();
			addChild(_bgBitmap);
			_icon=new Bitmap();
			addChild(_icon);
			
			_textField=new TextField("",2048,2048,"Verdana",fontSize,0xFFFFFF);
			addChild(_textField);
			
			iconTapGesture=new TapGesture(_icon,false);
			iconTapGesture.addEventListener(GestureEvent.TAP,onIconTap);
			
			tapGesture=new TapGesture(this);
			tapGesture.addEventListener(GestureEvent.TAP,onEnd);
			
			downPress=new LongPressGesture(this,400);
			downPress.addEventListener(GestureEvent.LONGPRESS_END,longPressGestureHandler);
		}

		/**
		 * 长按事件向上抛出 
		 * @param evt
		 */		
		protected function longPressGestureHandler(evt:Event):void
		{
			this.dispatchEvent(new TreeEvent(TreeEvent.LONG_PRESS_GESTURE,this,true));
		}

		protected function removeTapGesture():void
		{
			if(iconTapGesture){
				iconTapGesture.removeEventListener(GestureEvent.TAP,onIconTap);
				iconTapGesture.dispose();
				iconTapGesture=null;
			}
			if(tapGesture){
				tapGesture.removeEventListener(GestureEvent.TAP,onEnd);
				tapGesture.dispose();
				tapGesture=null;
			}
			if(downPress){
				downPress.removeEventListener(GestureEvent.LONGPRESS_END,longPressGestureHandler);
				downPress.dispose();
				downPress=null;
			}
		}
		
		/**
		 * 图标点击事件处理 
		 * @param evt
		 */		
		private function onIconTap(evt:Event):void
		{
			if (autoOpenUp){
				cascadeChindNodes(this);
			}
			this.dispatchEvent(new TreeEvent(TreeEvent.CLICK_NODE,this,true));
		}
		
		/**
		 * 递归创建子项 
		 * @param renderer
		 * @param forceSeleted
		 */		
		private function cascadeChindNodes(renderer:TreeCellRenderer,forceSeleted:Boolean=false):void
		{
			if(renderer.childNodes!=null){
				if(renderer.childNodes.length>0){
					if(!forceSeleted){
						if(renderer.selected){
							renderer.selected=false;
						}else{
							renderer.selected=true;
						}
					}else{
						if(!renderer.parentNode.selected){
							renderer.selected=false;
						}
					}
					
					for(var i:uint=0;i<renderer.childNodes.length;i++){
						cascadeChindNodes(renderer.childNodes[i],true);
					}
				}
			}
		}
		
		/**
		 *创建背景矩形 
		 * @return 
		 * 
		 */		
		private function createRectTexture(color:int,lineColor:int,_width:Number=10,_height:Number=10):TextureData
		{
			var textureData:TextureData=TextureData.createRGB(_width,_height,true,0x00000000);
			var rect:Shape=new Shape();
			if(color>0){
				rect.graphics.beginFill(color);
			}
			if(lineColor>0){
				rect.graphics.lineStyle(4,lineColor);
				rect.graphics.drawRect(2,2,_width-4,_height-4);
			}else{
				rect.graphics.drawRect(0,0,_width,_height);
			}
			
			textureData.draw(rect);
			return textureData;
		}
		
		//------------------------
		// 渲染
		//------------------------
		
		public function render():void
		{
			if(!closeSkin || !_icon || !_bgBitmap) return;

			//_height=fontSize+12;
			//开关状态图标
			var skin:BitmapSkin=_iconSkinsMap[_state];
			if(skin!=_icon.skin){
				_icon.skin=skin;
			}
			//背景
			if(bgSkin != _bgBitmap.skin){
				_bgBitmap.skin = bgSkin;			
			}
			if(_bgBitmap.width != width){
				_bgBitmap.width = width;
			}
			if(_bgBitmap.height != height){
				_bgBitmap.height = height;
			}
			if(selectedItemBoolean){
				_bgBitmap.alpha = 1.0;
			}else{
				_bgBitmap.alpha = 0.2;
			}
//			_bgIcon.render();
			
			if(text){		
				_textField.text=text;
				//文字样式
				if(textFormat){
					_textField.fontName=textFormat.font;
					_textField.fontSize=textFormat.size;
					_textField.textColor=textFormat.color;
					_textField.filter=textFormat.filter;
					_textField.hAlign=textFormat.hAlign;
					_textField.vAlign=textFormat.vAlign;
				}else{	//居中
					_textField.hAlign=TextField.ALIGN_CENTER;
					_textField.vAlign=TextField.ALIGN_CENTER;
					_textField.fontSize = fontSize;
				}
				//文字大小
				var textWidth:Number=0,textHeight:Number=0;
				textWidth=getTextSize(text,font,fontSize).width
				textHeight=getTextSize(text,font,fontSize).height;
				_textField.setSize(textWidth,textHeight);
				
				//文字偏移位置
				_textField.x=textPadding?_icon.width+textPadding.paddingLeft:_icon.width;
				_textField.y=textPadding?textPadding.paddingTop:(height-_textField.height)/2;
				_textField.visible=true;
				
			}
			//组件大小
//			if(DEFAULT_WIDTH<textWidth){
//				width=_icon.width+gap+textWidth+(textPadding ? textPadding.paddingLeft+textPadding.paddingRight :0);
//			}else{
//				width=DEFAULT_WIDTH;
//			}
			_icon.y=(height-_icon.height)/2;
		}
		
		/**
		 *监听鼠标操作针对icon或者对项操作。 
		 * @param evt
		 * 
		 */		
		private function onEnd(evt:Event):void 
		{
			this.dispatchEvent(new TreeEvent(TreeEvent.SELECTED_ITEM,this,true));
		}
		
		/**
		 * 处理内存回收 
		 */		
		override public function dispose():void 
		{
			super.dispose();
			RenderManager.dispose(this);
			if(_bgBitmap){
				this.removeChild(_bgBitmap);
				_bgBitmap=null;
			}
			if(_icon){
				this.removeChild(_icon);
				_icon=null;
			}
			if(_textField){
				this.removeChild(_textField);
				_textField=null;
			}
			removeTapGesture();
		}
	
		/**
		 * 获取数据,带类型
		 * @return 
		 */		
		public function get treeCellRendererVO():TreeCellRendererVO {
			return _data as TreeCellRendererVO;
		}
		
		/**
		 * IListItem
		 * 数据 
		 * @return 
		 */		
		public function get data():Object {
			return _data;
		}
		
		/**
		 * IListItem
		 * 需要提供TreeCellRendererVO类型的数据,其他类型数据不被支持 
		 * @param value
		 */		
		public function set data(value:Object):void {
			_data = value as TreeCellRendererVO;
			if (_data != null){
				_label = _data.label ? _data.label : "";
				//trace ("_label:", _label);
			}
			invalidate(render);
		}
		
		/**
		 * IListItem内方法 
		 * @param value
		 */		
		public function set index(value:int):void
		{
			_index = value;
		}
		
		/**
		 * IListItem内方法 
		 * @param value
		 */	
		public function get index():int
		{
			return _index;
		}
		
		/**
		 * IListItem内方法 
		 * @param value
		 */	
		public function get label():String
		{
			return _label;
		}
		
	}
}