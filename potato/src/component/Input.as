package potato.component
{
	import flash.utils.Dictionary;
	
	import core.display.DisplayObjectContainer;
	import core.events.TextEvent;
	import core.text.TextField;
	
	import potato.component.data.BitmapSkin;
	import potato.component.data.Padding;
	import potato.component.data.TextFormat;
	import potato.utils.Size;
	import potato.utils.StringUtil;
	
	/**
	 * 输入框 不指定宽高时使用默认宽高
	 * @author liuxin
	 * 
	 */
	public class Input extends DisplayObjectContainer
		implements ISprite
	{
		public function Input(skins:String="",text:String="",defaultText:String="",width:Number=NaN,height:Number=NaN
							  ,textformat:TextFormat=null,textPadding:Padding=null,
							  mutiLine:Boolean=false,maxChar:int=0,maxLine:int=0,restrict:String="",displayAsPassword:Boolean=false)
		{
			super();
			createChildren();
			this.$skins=skins;
			this.$text=text;
			this.$defaultText=defaultText;
			this.$width=isNaN(width)?DEFAULT_WIDTH:width;
			this.$height=isNaN(height)?DEFAULT_HEIGHT:height;
			this.$textFormat=textformat;
			this.$textPadding=textPadding;
			this.$mutiLine=mutiLine;
			this.$maxLine=maxLine;
			this.maxChar=maxChar;
			this.restrict=restrict;
			this.$displayAsPassword=displayAsPassword;
			render();
		}
		
		public function setSkins(backgroundSkin:BitmapSkin=null,disableSkin:BitmapSkin=null):void{
			this.$backgroundSkin=backgroundSkin;
			this.$disableSkin=disableSkin;
			render();
		}
		
		//皮肤
		public static const BACKGROUND:uint=0;
		public static const DISABLE:uint=1;
		
		//默认宽高
		public static const DEFAULT_WIDTH:int=100;
		public static const DEFAULT_HEIGHT:int=24;
		
		
		
		//----------------------------
		//	ISprite
		//----------------------------
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
		
		//----------------------------
		//	property
		//----------------------------
		private var _defaultText:String;
		private var _showDefaultText:Boolean=true;
		private var _maxChar:int;
		protected var _text:String;
		private var _maxLine:int;
		private var _htmlText:String;
		private var _textFormat:TextFormat;
		private var _defaultTextFormat:TextFormat;
		private var _textPadding:Padding;
		private var _skins:String;
		private var _restrict:String;
		private var _displayAsPassword:Boolean;
		private var _passwordSkin:BitmapSkin;
		private var _mutiLine:Boolean;
		private var _disable:Boolean=false;
		private var _isDefault:Boolean=false;
		
		/**
		 * 是否多行，单行为截断超出字符，多行为滚动输入框
		 * @return 
		 * 
		 */
		public function get mutiLine():Boolean
		{
			return _mutiLine;
		}
		
		public function set mutiLine(value:Boolean):void
		{
			$mutiLine=value;
			renderText();
		}
		public function set $mutiLine(value:Boolean):void{
			_mutiLine = value;
		}
		/**
		 * 行数 
		 * @return 
		 * 
		 */		
		public function get maxLine():int
		{
			return _maxLine;
		}
		
		public function set maxLine(value:int):void
		{
			$maxLine=value;
			renderText();
		}
		public function set $maxLine(value:int):void{
			_maxLine = value;
		}
		
		/**
		 * 密码皮肤 ，未指定为"*"
		 * @return 
		 * 
		 */
		public function get passwordSkin():BitmapSkin
		{
			return _passwordSkin;
		}
		
		public function set passwordSkin(value:BitmapSkin):void
		{
			$passwordSkin=value;
			renderPassword();
		}
		public function set $passwordSkin(value:BitmapSkin):void{
			_passwordSkin = value;
		}
		/**
		 * 是否显示为密码
		 * @return 
		 * 
		 */
		public function get displayAsPassword():Boolean
		{
			return _displayAsPassword;
		}
		
		public function set displayAsPassword(value:Boolean):void
		{
			$displayAsPassword=value;
			renderPassword();
		}
		public function set $displayAsPassword(value:Boolean):void{
			_displayAsPassword = value;
		}
		
		/**
		 * 字符集 
		 * @return 
		 * 
		 */
		public function get restrict():String
		{
			return _restrict;
		}
		
		public function set restrict(value:String):void
		{
			_restrict = value;
		}
		
		/**
		 * 是否禁用 
		 * @return 
		 * 
		 */
		public function get disable():Boolean
		{
			return _disable;
		}
		
		public function set disable(value:Boolean):void
		{
			_disable = value;
		}
		
		/**
		 * 禁用皮肤 
		 * @return 
		 * 
		 */
		public function get disableSkin():BitmapSkin
		{
			return _skinsMap[DISABLE];
		}
		
		public function set disableSkin(value:BitmapSkin):void
		{
			$disableSkin = value;
			render();
		}
		public function set $disableSkin(value:BitmapSkin):void{
			_skinsMap[DISABLE] = value;
		}
		
		/**
		 * 皮肤 
		 * @return 
		 * 
		 */
		public function get backgroundSkin():BitmapSkin
		{
			return _skinsMap[BACKGROUND];
		}
		
		public function set backgroundSkin(value:BitmapSkin):void
		{
			$backgroundSkin=value;
			render();
		}
		public function set $backgroundSkin(value:BitmapSkin):void{
			_skinsMap[BACKGROUND] = value;
		}
		
		/**
		 * 皮肤组 
		 * @return 
		 * 
		 */
		public function get skins():String
		{
			return _skins;
		}
		
		public function set skins(value:String):void
		{
			$skins = value;
			render();
		}
		public function set $skins(value:String):void{
			_skins=value;	
			_skinsArr=StringUtil.fillArray(_skinsArr,value,String);
			for (var i:int=0;i<_skinsArr.length;i++){
				var skinStr:String=_skinsArr[i];
				if(skinStr){
					var bSkin:BitmapSkin=new BitmapSkin();
					bSkin.textureName=skinStr;
					_skinsMap[i]=bSkin;
				}
			}
		}
		
		/**
		 * 边距，指字符和背景皮肤之间 
		 * @return 
		 * 
		 */
		public function get textPadding():Padding
		{
			return _textPadding;
		}
		
		public function set textPadding(value:Padding):void
		{
			$textPadding=value;
			render();
		}
		
		public function set $textPadding(value:Padding):void{
			_textPadding = value;
		}
		/**
		 * 字符样式 
		 * @return 
		 * 
		 */
		public function get textFormat():TextFormat
		{
			return _textFormat;
		}
		
		public function set textFormat(value:TextFormat):void
		{
			$textFormat=value;
			renderText();
		}
		public function set $textFormat(value:TextFormat):void{
			_textFormat = value;
		}
		
		/**
		 * 默认文字样式 
		 * @return 
		 * 
		 */
		public function get defaultTextFormat():TextFormat
		{
			return _defaultTextFormat;
		}
		
		public function set defaultTextFormat(value:TextFormat):void
		{
			$defaultTextFormat=value;
			renderText();
		}
		public function set $defaultTextFormat(value:TextFormat):void{
			_defaultTextFormat = value;
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
			renderText();
		}
		public function set $text(value:String):void{
			_text = value;
		}
		
		/**
		 * 最大字符数 
		 * @return 
		 * 
		 */
		public function get maxChar():int
		{
			return _maxChar;
		}
		
		public function set maxChar(value:int):void
		{
			_maxChar = value;
		}
		
		/**
		 * 是否显示默认文本 
		 * @return 
		 * 
		 */
		public function get showDefaultText():Boolean
		{
			return _showDefaultText;
		}
		
		public function set showDefaultText(value:Boolean):void
		{
			$showDefaultText=value;
			renderText();
		}
		public function set $showDefaultText(value:Boolean):void{
			_showDefaultText = value;
		}
		
		/**
		 * 默认文本 
		 * @return 
		 * 
		 */
		public function get defaultText():String
		{
			return _defaultText;
		}
		
		public function set defaultText(value:String):void
		{
			$defaultText=value;
			renderText();
		}
		
		public function set $defaultText(value:String):void{
			_defaultText = value;
		}
		//--------------------------
		//	assets
		//--------------------------
		private var _bitmap:Bitmap;
		protected var _textField:TextField;
		private var _arrow:Clip;
		private var _skinsMap:Dictionary=new Dictionary(true);
		private var _skinsArr:Array=["","","",""];
		private var _realText:String="";
		private var _showText:String="";
		protected var _pwdImgs:Vector.<Bitmap>=new Vector.<Bitmap>();
		
		
		private function createChildren():void{
			_bitmap=new Bitmap();
			this.addChild(_bitmap);
			_textField=new TextField("",2048,2048);
			_textField.type=TextField.INPUT;
			this.addChild(_textField);
			_textField.addEventListener(TextEvent.TEXT_INPUT,onInput);
		}
		
		protected function onInput(e:TextEvent):void{
			var code:Number=e.text.charCodeAt(0);
			if(code==8){		//退格
				text=text.substring(0,text.length-1);
			}else{
				if(validInput(e.text))
					text+=e.text;
			}
			this.dispatchEvent(new TextEvent(TextEvent.TEXT_INPUT,false,text));
		}
		
		protected function validInput(inText:String):Boolean{
			var t:String=inText;
			var  charValid:Boolean=false,restrictValid:Boolean=false;
			if(_maxChar==0 || (_maxChar!=0 && (text.length+t.length<=_maxChar))){				//验证字符数
				charValid=true;
			}
			if(_restrict=="" || (_restrict!="" && new RegExp(_restrict).test(t))){				//正则表达式验证字符集
				restrictValid=true;
			}
			return charValid && restrictValid;
		}
		
		public function render():void
		{
			//背景皮肤
			if(backgroundSkin){
				var skin:BitmapSkin=disable?_skinsMap[DISABLE]:_skinsMap[BACKGROUND];
				if(skin){
					_bitmap.$skin=skin;
				}else{
					if(disable){
						_bitmap.$skin=backgroundSkin;
					}
				}
				_bitmap.$width=width;
				_bitmap.$height=height;
				_bitmap.render();
			}
			
			//文字大小
			var textWidth:Number=0,textHeight:Number=0;
			textWidth=textPadding?width-textPadding.paddingLeft-textPadding.paddingRight:width;
			textHeight=textPadding?height-textPadding.paddingTop-textPadding.paddingBottom:height;
			if(textWidth<=0)
				textWidth=4;
			if(textHeight<=0)
				textHeight=4;
			_textField.setSize(textWidth,textHeight);
			//文字偏移位置
			_textField.x=textPadding?textPadding.paddingLeft:0;
			_textField.y=textPadding?textPadding.paddingTop:0;
			
			renderText();
		}
		
		protected function renderText():void{
			//默认文字
			if(showDefaultText && !text){
				_isDefault=true;
				_realText=defaultText;
			}else{
				_isDefault=false;
				_realText=text;
			}
			
			if(_isDefault){		//没有默认文字样式，使用文字样式
				if(defaultTextFormat){
					_textField.fontName=defaultTextFormat.font;
					_textField.fontSize=defaultTextFormat.size;
					_textField.textColor=defaultTextFormat.color;
					_textField.filter=defaultTextFormat.filter;
					_textField.hAlign=defaultTextFormat.hAlign;
					_textField.vAlign=defaultTextFormat.vAlign;
				}else if(textFormat){
					_textField.fontName=textFormat.font;
					_textField.fontSize=textFormat.size;
					_textField.textColor=textFormat.color;
					_textField.filter=textFormat.filter;
					_textField.hAlign=textFormat.hAlign;
					_textField.vAlign=textFormat.vAlign;
				}
			}else{
				if(textFormat){
					_textField.fontName=textFormat.font;
					_textField.fontSize=textFormat.size;
					_textField.textColor=textFormat.color;
					_textField.filter=textFormat.filter;
					_textField.hAlign=textFormat.hAlign;
					_textField.vAlign=textFormat.vAlign;
				}
			}
			var i:int=0;
			var subText:String;
			var size:Size;
			var complete:Boolean=false;	//全部验证
			
			if(_realText){
				if(!mutiLine){		//单行
					renderSingleLineText();
				}else{				//多行
					if(maxLine>0){
						_showText=_realText;
						_textField.text=_showText;
						_textField.scrollV=_textField.numLines-_maxLine+1; 
					}else{		//计算容纳行，文本较多时消耗很大，不过可以做插入点等高级功能
						i=0;
						size=null;
						complete=false;
						var line:int=0;
						var indexMap:Dictionary=new Dictionary();
						while(true){
							if(i==_realText.length) 
								break;
							subText=_realText.substr(0,i+1);
							size=Text.getTextSize(subText,_textField.fontName,_textField.fontSize,_textField.width);
							if(size.numLines!=line){
								line=size.numLines;
								indexMap[line]=i;		//每行的起始位置
							}
							i++;
						}
						var max:int=size.numLines;
						size=null;
						line=max;
						while(!size || size.height<_textField.height-4){
							if(line==0){
								complete=true;
								break;
							}
							subText=_realText.substring(indexMap[line]);		//倒取多行文本
							size=Text.getTextSize(subText,_textField.fontName,_textField.fontSize,_textField.width)
							line--;
						}
						if(complete)
							_showText=subText;
						else{
							if(line==max-1)
								_showText="";
							else
								_showText=_realText.substring(indexMap[line+2]);
						}
						
						_textField.text=_showText;
					}
				}
			}else{
				_textField.text="";
				_textField.scrollV=1;
			}
		}
		
		protected function renderSingleLineText():void
		{
			var i:int=0;
			var subText:String;
			var size:Size;
			var complete:Boolean=false;	//全部验证
			// TODO Auto Generated method stub
			i=_realText.length;		//从末尾验证
			while(!size || size.width<_textField.width-4){
				if(i==0){
					complete=true;
					break;
				}
				
				subText=_realText.substring(i-1);
				size=Text.getTextSize(subText,_textField.fontName,_textField.fontSize);
				i--;
			}
			_showText=complete?subText:subText.substring(1);	//不是全部验证取上次文本
			if(!_isDefault)	//密码
				renderPassword();
		}
		
		private function renderPassword():void{
			/*var img:Bitmap;
			while(_pwdImgs.length>0){		//删除所有图片
			img=_pwdImgs.shift();
			img.texture=null;
			this.removeChild(img);
			img=null;
			}*/
			if(_displayAsPassword){          //显示密码
				if(!_passwordSkin){			//显示默认
					var _pwdStr:String="";
					for(var i:int=0;i<_showText.length;i++){
						_pwdStr+="*";
					}
					_textField.text=_pwdStr;
				}else{							//密码样式
					_textField.text="";
					/*for (i=0;i<_text.length;i++){
					img=new Bitmap(_passwordSkin);
					img.mouseEnabled=false;
					//位置特殊处理
					img.x=_textField.x+i*img.width+4;
					img.y=_textField.y+(_textField.height-img.height)/2;
					_pwdImgs.push(img);
					this.addChild(img);
					}*/
				}
			}else{
				_textField.text=_showText;
			}
		}
		
		override public function dispose():void{
			super.dispose();
			
			if(_bitmap){
				removeChild(_bitmap);
				_bitmap.dispose();
				_bitmap=null;
			}
			if(_textField){
				removeChild(_textField);
				_textField.removeEventListener(TextEvent.TEXT_INPUT,onInput);
				_textField.dispose();
				_textField=null;
			}
			if(_skinsMap){
				for(var i:uint in _skinsMap){
					delete _skinsMap[i];
				}
				_skinsMap=null;
				_skinsMap=new Dictionary(true);
			}
			
		}
		
	}
}