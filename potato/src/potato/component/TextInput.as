package potato.component
{
	import flash.utils.Dictionary;
	
	import core.display.DisplayObjectContainer;
	import core.events.TextEvent;
	import core.text.TextField;
	
	import potato.component.core.IDataBinding;
	import potato.component.core.ISprite;
	import potato.component.core.RenderManager;
	import potato.component.core.RenderType;
	import potato.component.data.BitmapSkin;
	import potato.component.data.Padding;
	import potato.component.data.TextFormat;
	import potato.utils.Size;
	import potato.utils.SkinUtil;
	
	/**
	 * 文本输入事件
	 * @author liuxin
	 * 
	 */
	[Event(name="textInput",type="core.events.TextEvent")]
	
	/**
	 * 文本输入框.
	 * <p>无焦点输入框，不设置宽高时，输入框大小取决于背景大小和填充边距。多行文本自动换行</p>
	 * @author liuxin
	 * 
	 */
	public class TextInput extends DisplayObjectContainer
		implements ISprite,IDataBinding
	{
		/**
		 * 创建输入框 
		 * @param skins 皮肤
		 * @param text 文字
		 * @param defaultText 默认文字
		 * @param width 宽
		 * @param height 高
		 * @param textformat 文字样式
		 * @param textPadding 文字填充
		 * @param mutiLine 是否多行文本 
		 * @param maxChar 最大字符数
		 * @param maxLine 最大行数	（已废止）
		 * @param restrict 字符集
		 * @param displayAsPassword 是否显示为密码
		 * 
		 */
		public function TextInput(skins:*=null,text:String="",defaultText:String="",width:Number=NaN,height:Number=NaN
							  ,textformat:TextFormat=null,textPadding:Padding=null,mutiLine:Boolean=false
							  ,maxChar:int=0,maxLine:int=0,restrict:String="",displayAsPassword:Boolean=false)
		{
			super();
			createChildren();
			this.skins=skins;
			this.text=text;
			this.defaultText=defaultText;
			this.width=width;
			this.height=height;
			this.textFormat=textformat;
			this.textPadding=textPadding;
			this.mutiLine=mutiLine;
			this.maxChar=maxChar;
			this.restrict=restrict;
			this.displayAsPassword=displayAsPassword;
		}
		
		
		//皮肤
		public static const SKIN:uint=0;
		public static const DISABLE_SKIN:uint=1;
		
		//默认宽高
		public static const DEFAULT_WIDTH:int=200;
		public static const DEFAULT_HEIGHT:int=200;
		
		
		
		//----------------------------
		//	ISprite
		//----------------------------
		private var _width:Number;
		private var _height:Number;
		private var _scale:Number;
		private var _renderType:uint=RenderType.CALLLATER;
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
				return currentSkin?currentSkin.width:DEFAULT_WIDTH;
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
				return currentSkin?currentSkin.height:DEFAULT_HEIGHT;
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
		private var _maxChar:int;
		protected var _text:String;
		private var _htmlText:String;
		private var _textFormat:TextFormat;
		private var _defaultTextFormat:TextFormat;
		private var _textPadding:Padding;
		private var _skins:String;
		private var _restrict:String;
		private var _displayAsPassword:Boolean;
		private var _passwordSkin:BitmapSkin;
		private var _mutiLine:Boolean=false;
		private var _disable:Boolean=false;
		
		private var _maxLine:int;
		
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
			if(_mutiLine!=value){
				_mutiLine = value;
				invalidate(renderText);
			}
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
			_passwordSkin = value;
			invalidate(renderTextSkin);
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
			if(_displayAsPassword !=value){
				_displayAsPassword = value;
				invalidate(renderTextSkin);
			}
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
			if(_disable!=value){
				_disable = value;
				this.mouseEnabled=this.mouseChildren=!_disable;
				invalidate(render);
			}
		}
		
		/**
		 * 禁用皮肤 
		 * @return 
		 * 
		 */
		public function get disableSkin():BitmapSkin
		{
			return _skinsMap[DISABLE_SKIN];
		}
		
		public function set disableSkin(value:BitmapSkin):void
		{
			_skinsMap[DISABLE_SKIN] = value;
			invalidate(render);
		}
		
		/**
		 * 皮肤 
		 * @return 
		 * 
		 */
		public function get skin():BitmapSkin
		{
			return _skinsMap[SKIN];
		}
		
		public function set skin(value:BitmapSkin):void
		{
			_skinsMap[SKIN] = value;
			invalidate(render);
		}
		
		/**
		 * 皮肤组 
		 * @return 
		 * 
		 */
		public function get skins():*
		{
			return _skins;
		}
		
		public function set skins(value:*):void
		{
			_skins=value;	
			_skinsArr=SkinUtil.fillSkins(_skinsArr,value);
			for (var i:int=0;i<_skinsArr.length;i++){
				_skinsMap[i]=_skinsArr[i];
			}
			invalidate(render);
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
			_textPadding = value;
			invalidate(render);
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
			_textFormat = value;
			invalidate(renderText);
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
			_defaultTextFormat = value;
			invalidate(renderText);
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
				_text = value;
				invalidate(renderText);
			}
		}
		
		/**
		 * @private 
		 * @param value
		 * 
		 */
		public function set $text(value:String):void{
			if(_text!=value){
				_text = value;
				renderText();
			}
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
			if(_defaultText!=value){
				_defaultText = value;
				invalidate(renderText);
			}
		}
		
		//--------------------------
		//	assets
		//--------------------------
		protected var _textField:TextField;
		private var _bitmap:Bitmap;
		private var _skinsMap:Dictionary=new Dictionary(true);
		private var _skinsArr:Array=[null,null];
		private var _showText:String="";
		private var _inText:String="";
		private var _isDefault:Boolean=false;
		private var _pwdImgs:Vector.<Bitmap>=new Vector.<Bitmap>();
		
		
		private function createChildren():void{
			_bitmap=new Bitmap();
			this.addChild(_bitmap);
			_textField=new TextField("",2048,2048);
			_textField.type=TextField.INPUT;
			this.addChild(_textField);
			_textField.addEventListener(TextEvent.TEXT_INPUT,onInput);
		}
		
		
//		private var _inputFlag:Boolean=false;
		/**
		 * 输入事件处理 
		 * @param e
		 * 
		 */
		protected function onInput(e:TextEvent):void{
//			trace("input______");
//			_inputFlag=true;
			var code:Number=e.text.charCodeAt(0);
			if(code==8){		//退格
				$text=text.substring(0,text.length-1);
			}else{
				if(validInput(e.text))
					$text=text+e.text;
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
		
		protected function get currentSkin():BitmapSkin{
			return disable?_skinsMap[DISABLE_SKIN]:_skinsMap[SKIN]
		}
		/**
		 * 渲染组件内容 
		 * 
		 */
		protected function render():void
		{
			//文字大小
			var textWidth:Number=textPadding?width-textPadding.paddingLeft-textPadding.paddingRight:width;
			var textHeight:Number=textPadding?height-textPadding.paddingTop-textPadding.paddingBottom:height;
			_textField.setSize(textWidth<=0?1:textWidth,textHeight<=0?1:textHeight);
			//文字偏移位置
			_textField.x=textPadding?textPadding.paddingLeft:0;
			_textField.y=textPadding?textPadding.paddingTop:0;
			
			//背景皮肤
			_bitmap.skin=currentSkin;
			_bitmap.width=width;
			_bitmap.height=height;
			
			renderText();
		}
		
		/**
		 * 渲染文字 
		 * 
		 */
		protected function renderText():void{
			//默认文字
			if(!text && defaultText){
				_isDefault=true;
				_inText=defaultText;
			}else{
				_isDefault=false;
				_inText=text;
			}
			
			if(_isDefault && defaultTextFormat){
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
			
			if(!mutiLine){		//单行
				renderSingleLineText();
				_textField.scrollV=1;
			}else{				//多行
				renderMutiLineText();
			}
//			_inputFlag=false;
		}
		/**
		 * 渲染单行文本内容 
		 * 
		 */
		protected function renderSingleLineText():void
		{
//			if(!_inText) return;
			var i:int=0;
			var subText:String;
			var size:Size;
			var complete:Boolean=false;	//全部验证
			// TODO Auto Generated method stub
			i=_inText.length;		//从末尾验证
			while(!size || size.width<_textField.width-4){
				if(i==0){
					complete=true;
					break;
				}
				
				subText=_inText.substring(i-1);
				size=Text.getTextSize(subText,_textField.fontName,_textField.fontSize);
				i--;
			}
			_showText=complete?subText:subText.substring(1);	//不是全部验证取上次文本
			renderTextSkin();
		}
		
		private var _totoalLines:int;
		private var _totalSize:Size=new Size();
		protected function renderMutiLineText():void{
			var size:Size=Text.getTextSize(_inText,_textField.fontName,_textField.fontSize,_textField.width);;
//			var isCheck:Boolean=_inputFlag?():true;
			var isCheck:Boolean=(_totalSize.height!=size.height?true:false);
			_totalSize=size;
			
			var _mutiSize:Size;
			if(isCheck){
				trace("check__")
				var i:int=0;
				var subText:String;
				var complete:Boolean=false;	//全部验证
				i=_inText.length;		//从末尾验证
				
				while(!_mutiSize || _mutiSize.height<_textField.height-4){
					if(i==0){
						complete=true;
						break;
					}
					
					subText=_inText.substring(i-1);
					_mutiSize=Text.getTextSize(subText,_textField.fontName,_textField.fontSize,_textField.width);
					i--;
				}
				_totoalLines=_mutiSize?(complete?_mutiSize.numLines:_mutiSize.numLines-1):0;
			}
			_textField.text=_inText;
			_textField.scrollV=_textField.numLines-_totoalLines+1;
		}
		
		private function renderTextSkin():void{
			if(_mutiLine) return;
			/*var img:Bitmap;
			while(_pwdImgs.length>0){		//删除所有图片
			img=_pwdImgs.shift();
			img.texture=null;
			this.removeChild(img);
			img=null;
			}*/
			if(!_isDefault && displayAsPassword){          //显示密码
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
		
		/**
		 * 释放资源 
		 * 
		 */
		override public function dispose():void{
			super.dispose();
			RenderManager.dispose(this);
			
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
				for(var i:String in _skinsMap){
					delete _skinsMap[uint(i)];
				}
				_skinsMap=null;
				_skinsMap=new Dictionary(true);
			}
			
		}
		
	}
}