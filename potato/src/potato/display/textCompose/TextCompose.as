package potato.display.textCompose
{
	import flash.geom.Point;
	
	import core.display.DisplayObjectContainer;
	import core.display.Image;
	import core.display.Texture;
	import core.display.TextureData;
	import core.events.TextEvent;
	import core.text.CharMetrics;
	import core.text.Font;
	import core.text.TextField;
	
	import potato.utils.html.HtmlNode;
	import potato.utils.html.HtmlParser;
	
	/**
	 * 文字排版.
	 * <p>支持基本的图文混排，字符位置索引接口。比textField提供更丰富的功能，当然效率也低一点。</p>
	 * 
	 * <p>特性：1、支持空行 <br />
	 * 			2、支持滚动scrollV <br />
	 * 			3、提供智能获取坐标到的文本度量的映射<br />
	 * 			4、字符索引位置的文本度量<br />
	 * 			5、已绘制文本度量的字符索引位置 
	 * </p>
	 * @author liuxin
	 * 
	 */
	public class TextCompose extends DisplayObjectContainer
	{
		public function TextCompose(text:String="",width:Number=100,height:Number=100)
		{
			super();
			
			//用一下textfield的输入事件...
			_txt=new TextField();
			_txt.type=TextField.INPUT;
			_txt.addEventListener(TextEvent.TEXT_INPUT,textInputHandler);
			_txt.alpha=0;
			addChild(_txt);
			_img=new Image(null);
			addChild(_img);
			_img.mouseEnabled=false;
			
			_text = text;
			_txt.text=_text;
			setSize(width,height);
			
		}
		private var _htmlText:String="";
		private var _text:String="";
		protected var _width:Number=100;
		protected var _height:Number=100;
		private var _format:TextMetricsFormat;
		private var _img:Image;
		private var _txt:TextField;
		private var _scrollV:int=0;
		
		/**
		 * 排版样式 
		 * @return 
		 * 
		 */
		public function get format():TextMetricsFormat
		{
			return _format;
		}

		public function set format(value:TextMetricsFormat):void
		{
			_format = value;
			doCompose();
		}

		/**
		 * 高 
		 * @return 
		 * 
		 */
		public override  function get height():Number
		{
			return _height;
		}

		public  function set height(value:Number):void
		{
			if(isNaN(value)) return;
			_height = value;
			doCompose();
		}

		/**
		 * 宽 
		 * @return 
		 * 
		 */
		public override function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			if(isNaN(value)) return;
			_width = value;
			doCompose();
		}
		
		public function setSize(w:Number,h:Number):void{
			if(!isNaN(w)) 
				_width = w;
			if(!isNaN(h)) 
				_height = h;
			doCompose();
		}
		
		/**
		 * text 文本 
		 * @return 
		 * 
		 */
		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
			_txt.text=_text;
			doCompose();
		}

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
			_htmlText = value;
			doCompose();
		}
		
		/**
		 * 文本滚动行 
		 * @return 
		 * 
		 */		
		public function get scrollV():int
		{
			return _scrollV;
		}
		
		public function set scrollV(value:int):void
		{
			if(_scrollV!=value && value>=0){
				_scrollV = value;
				setTdSize(width,height);
				drawLines(_scrollV);
			}
		}

		
		protected var _textMetrics:Vector.<TextMetrics>;
		private var _drawTextMetrics:Vector.<TextMetrics>;
		private var _td:TextureData;
		
		protected var _lines:Vector.<ComposeLine>;
		protected var _drawLines:Vector.<ComposeLine>;
		
		private var _drawBeginIndex:int=0;
		private var _drawScrollV:Number=0;
		
		/**
		 * 总行数 
		 * @return 
		 * 
		 */
		public function get totalLines():int{
			return _lines.length;
		}
		
		/**
		 * 显示中的行数 
		 * @return 
		 * 
		 */
		public function get totalDrawLines():int{
			return _drawLines.length;
		}
		
		/**
		 * 开始绘制的字符字符索引 
		 * @return 
		 * 
		 */
		public function get drawBeginIndex():int
		{
			return _drawBeginIndex;
		}

		/**
		 * 任意坐标点到已绘制文本度量的映射  
		 * @param point  坐标点
		 * @param isSmart 智能处理：如果宽度小于文本度量的一半则为该度量，否则为下一个度量；如果找不到精确度量取当前行\最后行的最后一个度量
		 * @return 
		 * 
		 */
		public function pointToOnDrawMetrics(point:Point,isSmart:Boolean=false):TextMetrics{
			var i:int=0;
			var hSum:Number=0;
			var numSum:Number=0;
			for each(var line:ComposeLine in _drawLines){
				numSum+=line.numMetrics;
				for (var j:int=0;j<line.numMetrics;j++){
					var met:TextMetrics=_drawTextMetrics[i];
					if(point.x>=met.x && point.y>=met.y && point.x<=met.x+met.width && point.y<=met.y+line.lineHeight){
						if(!isSmart) 
							return met;
						else{
							if(point.x>met.x+met.width/2 && i<_drawTextMetrics.length-1)
								return _drawTextMetrics[i+1];
							else
								return met;
						}
					}
					i++;
				}
				
				if(isSmart){
					if(point.y>hSum && point.y<hSum+line.lineHeight)
						break;
				}
				hSum+=line.lineHeight;
			}
			if(isSmart && _textMetrics.length>0){
				return _textMetrics[_drawBeginIndex+numSum-1]
			}else{
				return null;
			}
		}
		
		/**
		 * 字符索引位置的文本度量
		 * @param index
		 * @return 
		 * 
		 */
		public function indexToMetrics(index:int):TextMetrics{
			if(index>-1 && index<_textMetrics.length)
				return _textMetrics[index];
			else
				return null;
		}
		
		
		public function indexToLineIndex(index:int):int{
			var sum:int=0;
			for (var i:int=0 ;i<_lines.length-1;i++){
				sum+=_lines[i].numMetrics;
				if(index<sum)
					break;
			}
			return i;
		}
		
		/**
		 * 已绘制文本度量的字符索引位置 
		 * @param met
		 * @return 
		 * 
		 */
		public function onDrawMetricsToIndex(met:TextMetrics):int{
			for (var i:int=0;i<_drawTextMetrics.length;i++){
				var me:TextMetrics=_drawTextMetrics[i];
				if(me==met)
					return i+_drawBeginIndex;
			}
			return -1;
		}
		
		private function setTdSize(w:Number,h:Number):void{
			_txt.setSize(w,h);
			_td=TextureData.createRGB(isNaN(w)?_width:w,isNaN(h)?_height:h,true,0);
		}
		
		/**
		 * 排版 
		 * 
		 */
		protected function doCompose():void
		{
			_textMetrics=new Vector.<TextMetrics>();
			_lines=new Vector.<ComposeLine>();
			_lastMetrics=null;
			
			setTdSize(width,height);
			var line:ComposeLine;
			if(_htmlText){	//htmltext composing
				var nodes:Vector.<HtmlNode>=HtmlParser.parse(_htmlText);
//				line=composing("\n",_format?_format:new TextMetricsFormat,null);
//				drawLines(_scrollV);
			}else{		//text composing
				line=composing(_text+"\n",_format?_format:new TextMetricsFormat,null);
				drawLines(_scrollV);
			}
		}
		
		private function drawLines(scrollv:int=0):void
		{
			if(_lines.length>0 && scrollv<=_lines.length-1){
				var x:int=0;
				var b:int=0;
				var fontName:String,fontSize:Number,fontColor:uint,isBold:Boolean,isItalic:Boolean,isUnderline:Boolean;
				
				var i:int=0;
				var k:int=0;
				_drawTextMetrics=new Vector.<TextMetrics>();
				_drawLines=new Vector.<ComposeLine>();
				
				for (var j:int=0;j<_lines.length;j++){
					var line:ComposeLine =_lines[j];
					if(j>=scrollv){
						if(j==scrollv)
							_drawBeginIndex=i;
						
						x=0;
						
						line.x=x;
						line.y=b;
						
						if(b+line.lineHeight >_height) 
							break;
						
						for (k=0;k<line.numMetrics;k++){
							var matrics:TextMetrics=_textMetrics[i];
							if(matrics.char){	//字符
								
								if(matrics.format && 
									(matrics.format.fontName!=fontName ||
									matrics.format.fontColor!=fontColor ||
									matrics.format.fontSize!=fontSize ||
									matrics.format.isBold!=isBold ||
									matrics.format.isItalic!=isItalic ||
									matrics.format.isUnderline!=isUnderline)){
									fontName=matrics.format.fontName;
									fontColor=matrics.format.fontColor;
									fontSize=matrics.format.fontSize;
									isBold=matrics.format.isBold;
									isItalic=matrics.format.isItalic;
									isUnderline=matrics.format.isUnderline;
									Font.selectFont(fontName,fontSize,isBold,isItalic,isUnderline);
									Font.setTextColor(fontColor);
								}
								var width:int=Font.drawChar(matrics.char.code,_td,b+line.ascent,x);
								
								matrics.x=x;
								matrics.width=width;
								matrics.y=b;
								
								x+=width;
							}else if(matrics.symbol=="\n"){	//换行
								
								matrics.x=x;
								matrics.width=0;
								matrics.y=b;
							}
							_drawTextMetrics.push(matrics);
							
							i++;
						}
						
						b+=line.lineHeight;
						
						line.width=x;
						_drawLines.push(line);
					}else{
						for (k=0;k<line.numMetrics;k++){
							i++;
						}
					}
				}
			}
			_img.texture=new Texture(_td);
		}		
		
		private var _lastMetrics:TextMetrics;
		private function composing(text:String,format:TextMetricsFormat,line:ComposeLine=null):ComposeLine{
			Font.selectFont(format.fontName,format.fontSize,format.isBold,format.isItalic,format.isUnderline);
			
			var newline:Boolean;
			for (var i:int=0;i<text.length;i++) {
				newline=false;
				if(!line)	//不存在创建行
					line=new ComposeLine();
				
				var c:uint=text.charCodeAt(i);
//				Logger.getLog("TextCompose").debug(c);
				var tm:TextMetrics=new TextMetrics();
				tm.format=format;
				if(c==10){	//换行
					tm.symbol="\n";
					if(_lastMetrics)
						tm.height=_lastMetrics.height;		//高度
					else
						tm.height=format.fontSize;
					newline=true;
				}else if(c==13){ //回车
					tm.symbol="\r";
					if(_lastMetrics)
						tm.height=_lastMetrics.height;		//高度
					else
						tm.height=format.fontSize;
					newline=true;
				}else{
					var cm:CharMetrics=new CharMetrics();
					cm.code=c;
					Font.getCharMetrics(cm);
					tm.char=cm;
					
					if(cm.width>_width){
						break;
					}else if(line.x+cm.width>_width){
						line=newLine(line);
					}
					line.x+=cm.width;
					
					if(cm.ascent>line.ascent)
						line.ascent=cm.ascent;
					if(cm.descent>line.descent)
						line.descent=cm.descent;
					tm.height=line.ascent+line.descent; //高度
					
				}
				if(tm.height>line.height)
					line.height=tm.height;
				
				line.numMetrics++;
				_textMetrics.push(tm);
				
				_lastMetrics=tm;
				if(newline){
					line=newLine(line);
				}
			}
			return line;
		}
		
		private function newLine(cur:ComposeLine):ComposeLine
		{
			_lines.push(cur);
			var line:ComposeLine=new ComposeLine();
			return line;
		}
		
		private function textInputHandler(e:TextEvent):void
		{
//			trace(e.text,e.text.charCodeAt(0));
//			Logger.getLog("TextCompose").debug(e.text,e.text.charCodeAt(0));
			if(e.text.charCodeAt(0)!=3)
				dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT,false,e.text));
		}
		
		override public function dispose():void{
			super.dispose();
			
			_txt.removeEventListener(TextEvent.TEXT_INPUT,textInputHandler);
			removeChild(_txt);
			_img.dispose();
			removeChild(_img);
		}
	}
}
