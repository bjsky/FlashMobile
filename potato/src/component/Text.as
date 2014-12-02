package potato.component
{
	import core.display.DisplayObjectContainer;
	import core.text.TextField;
	
	import potato.component.data.BitmapSkin;
	import potato.component.data.Padding;
	import potato.component.data.TextFormat;
	import potato.component.interf.IDataBinding;
	import potato.component.interf.ISprite;
	import potato.manager.RenderManager;
	import potato.utils.Size;
	
	/**
	 * 文字.
	 * <p>带背景的文字，可以设置文字的HtmlText</p>
	 * <p>如果设置了组件大小，则文字内容大小由组件大小和填充计算，如果文字内容超出计算的大小则显示不全。
	 * 否则组件大小由文字内容大小加上填充计算，组件的大小依据内容</p>
	 * @author liuxin
	 * @date 2014.5.30
	 */
	public class Text extends DisplayObjectContainer
		implements ISprite,IDataBinding
	{
		/**
		 * 创建文本
		 * @param text 文本
		 * @param skin 背景皮肤
		 * @param width	宽
		 * @param height 高
		 * @param textformat 文字样式
		 * @param textPadding	文字填充
		 * 
		 */
		public function Text(text:String="",skin:BitmapSkin=null
							 ,width:Number=NaN,height:Number=NaN,textformat:TextFormat=null,textPadding:Padding=null)
		{
			super();
			
			createChildren();
			
			this.text=text;
			this.skin=skin;
			this.width=width;
			this.height=height;
			this.textFormat=textformat;
			this.textPadding=textPadding;
		}
		
		
		/**
		 * 文本工具 
		 */		
		static private var toolText:TextField = new TextField("", 2048, 2048);
		
		/**
		 * 获取文本宽度
		 * @param txt
		 * @param fontName
		 * @param fontSize
		 * @param isHtmlText
		 * @return 
		 * 
		 */
		public static function getTextSize(txt:String, fontName:String, fontSize:int,width:Number=NaN, isHtmlText:Boolean = false):Size {
			toolText.fontName = fontName;
			toolText.fontSize = fontSize;
			toolText.setSize(isNaN(width)?2048:width,2048);
			
			if (isHtmlText)
				toolText.htmlText = txt;
			else
			{
				toolText.text = txt;
				toolText.htmlText = null;
			}
			return new Size(toolText.textWidth + 4, toolText.textHeight + 4,toolText.numLines);
		}
	
		protected var _textField:TextField;
		protected var _background:Bitmap;
		
		protected function createChildren():void{
			_textField=new TextField("",2048,2048);
			addChild(_textField);
		}
		
		//----------------------------
		//	ISprite
		//----------------------------
		private var _width:Number;
		private var _height:Number;
		private var _scale:Number;
		private var _validateMode:uint=RenderManager.CALLLATER;
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
		 * 渲染模式
		 * @return 
		 * 
		 */
		public function get validateMode():uint
		{
			return _validateMode;
		}
		
		public function set validateMode(value:uint):void
		{
			_validateMode = value;
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
				_textField.setSize(2048,2048);
				invalidate(render);
			}
		}
		override public function get width():Number{
			if(!isNaN(_width))
				return _width;
			else{
				var paddingWidth:Number=textPadding?textPadding.paddingLeft+textPadding.paddingRight:0;
				return _textField.textWidth!=0?_textField.textWidth+4+paddingWidth:paddingWidth;
			}
		}
		
		/**
		 * 高度 
		 * @param value
		 * 
		 */
		public function set height(value:Number):void{
			if(_height!=value){
				_height=value;
				_textField.setSize(2048,2048);
				invalidate(render);
			}
		}
		override public function get height():Number{
			if(!isNaN(_height))
				return _height;
			else{
				var paddingHeight:Number=textPadding?textPadding.paddingTop+textPadding.paddingBottom:0;
				return _textField.textHeight!=0?_textField.textHeight+4+paddingHeight:paddingHeight;
			}
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
		//-------------------------
		//		property
		//--------------------------
		private var _text:String;
		private var _htmlText:String;
		private var _skin:BitmapSkin;
		private var _textFormat:TextFormat;
		private var _textPadding:Padding;
		
		/**
		 * html文本 
		 * @return 
		 * 
		 */
		public function get htmlText():String
		{
			return _htmlText;
		}
		
		public function set htmlText(value:String):void
		{
			if(_htmlText!=value){
				_htmlText=value;
				_textField.setSize(2048,2048);
				_textField.htmlText=_htmlText;
				invalidate(render);
			}
		}
		
		/**
		 * 文本 
		 * @return 
		 * 
		 */
		public function get text():String
		{
			return _text;
		}
		
		public function set text(value:String):void
		{
			if(_text!=value){
				_text=value;
				_textField.setSize(2048,2048);
				_textField.text=text;
				_textField.htmlText=null;
				invalidate(render);
			}
		}
		
		/**
		 * 背景图片 
		 * @return 
		 * 
		 */
		public function get skin():BitmapSkin
		{
			return _skin;
		}
		
		public function set skin(value:BitmapSkin):void
		{
			_skin=value;
			invalidate(render);
		}
		
		/**
		 * 文字填充
		 * @return 
		 * 
		 */
		public function get textPadding():Padding
		{
			return _textPadding;
		}
		
		public function set textPadding(value:Padding):void
		{
			_textPadding=value;
			invalidate(render);
		}
		
		/**
		 * 文本样式 
		 * @return 
		 * 
		 */
		public function get textFormat():TextFormat
		{
			return _textFormat;
		}
		
		public function set textFormat(value:TextFormat):void
		{
			_textFormat=value;
			//文字样式
			if(_textField && textFormat){
				_textField.fontName=textFormat.font;
				_textField.fontSize=textFormat.size;
				_textField.textColor=textFormat.color;
				_textField.filter=textFormat.filter;
				_textField.hAlign=textFormat.hAlign;
				_textField.vAlign=textFormat.vAlign;
			}
			invalidate(render);
		}
		
		//------------------------
		// 渲染
		//------------------------
		
		/**
		 * 渲染组件内容 
		 * 
		 */
		private function render():void{
			if(!_textField)
				return;
			
			//文字大小
			var textWidth:Number=textPadding?width-textPadding.paddingLeft-textPadding.paddingRight:width;
			var textHeight:Number=textPadding?height-textPadding.paddingTop-textPadding.paddingBottom:height;
			_textField.setSize(textWidth<=0?1:textWidth,textHeight<=0?1:textHeight);
			//文字偏移位置
			_textField.x=textPadding?textPadding.paddingLeft:0;
			_textField.y=textPadding?textPadding.paddingTop:0;
			
			//文字背景
			if(skin){
				if(!_background){
					_background=new Bitmap(skin,width,height);
					addChildAt(_background,0);
				}else{
					_background.width=width;
					_background.height=height;
					_background.skin=skin;
				}
			}else{
				if(_background){
					removeChild(_background);
					_background.dispose();
					_background=null;
				}
			}
		}
		
		/**
		 * 释放资源 
		 * 
		 */
		override public function dispose():void{
			super.dispose();
			RenderManager.dispose(this);
			
			if(_background){
				if(_background.parent)
					removeChild(_background);
				_background.dispose();
				_background=null;
			}
			if(_textField){
				removeChild(_textField);
				_textField.dispose();
				_textField=null;
			}
		}
	}
}