package potato.component
{
	import core.display.DisplayObjectContainer;
	import core.text.TextField;
	
	import potato.component.data.BitmapSkin;
	import potato.component.data.Padding;
	import potato.component.data.TextFormat;
	import potato.utils.DebugUtil;
	import potato.utils.Size;
	
	/**
	 * 文字 
	 * <br />带背景的文字块。如果设置了组件大小，则文字内容大小由组件大小和填充计算，如果文字内容超出计算的大小则显示不全；
	 * 如果不设置组件大小，则组件大小由文字内容大小加上填充计算，组件的大小依据内容。
	 * @author liuxin
	 * @date 2014.5.30
	 */
	public class Text extends DisplayObjectContainer
		implements ISprite
	{
		public function Text(text:String="",skin:BitmapSkin=null
							 ,width:Number=NaN,height:Number=NaN,textformat:TextFormat=null,textPadding:Padding=null)
		{
			super();
			
			createChildren();
			
			$text=text;
			$skin=skin;
			$textFormat=textformat;
			$textPadding=textPadding;
			$width=width;
			$height=height;
			
			render();
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
		private var _measureWidth:Number=0;
		private var _measureHeight:Number=0;
		protected var _width:Number;
		protected var _height:Number;
		protected var _scale:Number;
		
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
			if(isNaN(_width))
				return _measureWidth;
			else
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
			render();
		}
		override public function get height():Number{
			if(isNaN(_height))
				return _measureHeight;
			else
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
			$htmlText=value;
			render();
		}
		public function set $htmlText(value:String):void{
			_htmlText=value;
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
			$text=value;
			render();
		}
		public function set $text(value:String):void{
			_text=value;
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
			$skin = value;
			render();
		}
		public function set $skin(value:BitmapSkin):void{
			_skin=value;
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
			$textPadding = value;
			render();
		}
		public function set $textPadding(value:Padding):void{
			_textPadding=value;
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
			$textFormat = value;
			render();
		}
		public function set $textFormat(value:TextFormat):void{
			_textFormat=value;
		}
		//------------------------
		// 渲染
		//------------------------
		
		public function render():void{
			DebugUtil.traceProcessCurrent("render",this);
			_textField.setSize(2048,2048);
			//文字内容
			if(htmlText)
				_textField.htmlText=htmlText;
			else{
				_textField.text=text;
				_textField.htmlText=null;
				if(!text){
					_textField.setSize(0,0);
					_measureHeight=_measureWidth=0;
					return;
				}
			}
			
			//文字样式
			if(textFormat){
				_textField.fontName=textFormat.font;
				_textField.fontSize=textFormat.size;
				_textField.textColor=textFormat.color;
				_textField.filter=textFormat.filter;
				_textField.hAlign=textFormat.hAlign;
				_textField.vAlign=textFormat.vAlign;
			}
			
			//文字大小
			var textWidth:Number=0,textHeight:Number=0;
			if(!isNaN(_width))	//有指定宽，获取文字宽
				textWidth=textPadding?width-textPadding.paddingLeft-textPadding.paddingRight:width;
			else{	//没有指定宽，设置显示的宽
				_measureWidth=textWidth=_textField.textWidth+4;
				if(textPadding)
					_measureWidth=textWidth+textPadding.paddingLeft+textPadding.paddingRight;
			}
			if(!isNaN(_height))
				textHeight=textPadding?height-textPadding.paddingTop-textPadding.paddingBottom:height;
			else{
				_measureHeight=textHeight=_textField.textHeight+4;
				if(textPadding)
					_measureHeight=textHeight+textPadding.paddingTop+textPadding.paddingBottom;
			}
			_textField.setSize(textWidth,textHeight);
			
			//文字偏移位置
			_textField.x=textPadding?textPadding.paddingLeft:0;
			_textField.y=textPadding?textPadding.paddingTop:0;
			
			//文字背景
			if(skin){
				if(!_background){
					_background=new Bitmap(skin,width,height);
					addChildAt(_background,0);
				}else{
					_background.$width=width;
					_background.$height=height;
					_background.$skin=skin;
					_background.render();
				}
			}else{
				if(_background){
					removeChild(_background);
					_background.dispose();
					_background=null;
				}
			}
		}
		
		override public function dispose():void{
			super.dispose();
			
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