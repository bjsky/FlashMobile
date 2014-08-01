package potato.component
{
	import flash.utils.Dictionary;
	
	import core.display.DisplayObjectContainer;
	import core.events.TouchEvent;
	import core.text.TextField;
	
	import potato.component.data.BitmapSkin;
	import potato.component.data.Padding;
	import potato.component.data.TextFormat;
	import potato.utils.DebugUtil;
	import potato.utils.StringUtil;

	public class Button extends DisplayObjectContainer
		implements ISprite,IGroupItem
	{
		public function Button(skins:String="",text:String="",width:Number=NaN,height:Number=NaN,
											textformat:TextFormat=null,textPadding:Padding=null)
		{
			super();
			createChildren();
			
			this.addEventListener(TouchEvent.TOUCH_BEGIN,onBegin);
			this.addEventListener(TouchEvent.TOUCH_END,onEnd);
			
			this.$skins=skins;
			this.$text=text;
			this.$width=width;
			this.$height=height;
			this.$textFormat=textformat;
			this.$textPadding=textPadding;
			this.render();
		}

		public function setSkins(upSkin:BitmapSkin=null,downSkin:BitmapSkin=null,disableSkin:BitmapSkin=null
								 ,selectedSkin:BitmapSkin=null):void{
			this.$upSkin=upSkin;
			this.$downSkin=downSkin;
			this.$disableSkin=disableSkin;
			this.$selectedSkin=selectedSkin;
			this.render();
		}
		
		
		/**
		 * 正常 
		 */
		static private const UP:uint=0;			
		/**
		 * 按下 
		 */
		static private const DOWN:uint=1;
		/**
		 * 禁用 
		 */
		static private const DISABLE:uint=2;
		/**
		 * 选中 
		 */
		static private const SELECTED:uint=3;
		
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
		//------------------------------
		// properties
		//------------------------------
		private var _skins:String="";
		private var _skinsArr:Array=["","","",""];
		private var _textSkin:BitmapSkin;
		private var _textOffsetX:Number;
		private var _textOffsetY:Number;
		private var _disable:Boolean=false;
		private var _skinsMap:Dictionary=new Dictionary();
		private var _state:uint=UP;
		private var _selected:Boolean=false;
		protected var _data:Object;
		
		/**
		 * 皮肤字符串 [正常，按下，禁用，选中]
		 * @param value
		 * 
		 */
		public function set skins(value:String):void{
			$skins=value;
			render();
		}
		public function get skins():String{
			return _skins;
		}
		
		public function set $skins(value:String):void{
			_skins=value;	
			_skinsArr=StringUtil.fillArray(_skinsArr,value,String);
			for (var i:int=0;i<_skinsArr.length;i++){
				var skinStr:String=_skinsArr[i];
				if(skinStr){
					var bSkin:BitmapSkin=new BitmapSkin();
					bSkin.textureName=skinStr;
					_skinsMap[i]=bSkin;//BitmapSkin.createWithName(skinStr);
				}
			}
		}
		/**
		 * 正常皮肤 
		 * @param value
		 * 
		 */
		public function set upSkin(value:BitmapSkin):void{
			$upSkin=value;
			if(_state==UP)
				render();
		}
		public function get upSkin():BitmapSkin{
			return _skinsMap[UP];
		}
		public function set $upSkin(value:BitmapSkin):void{
			_skinsMap[UP]=value;
		}
		
		/**
		 * 按下皮肤 ，如果没有就使用正常皮肤
		 * @param value
		 * 
		 */
		public function set downSkin(value:BitmapSkin):void{
			$downSkin=value;
			if(_state==DOWN)
				render();
		}
		public function get downSkin():BitmapSkin{
			return _skinsMap[DOWN];
		}
		public function set $downSkin(value:BitmapSkin):void{
			_skinsMap[DOWN]=value;
		}
		
		/**
		 * 禁用皮肤 ，如果没有使用灰度滤镜
		 * @param value
		 * 
		 */
		public function set disableSkin(value:BitmapSkin):void{
			$disableSkin=value;
			if(_state==DISABLE)
				render();
		}
		public function get disableSkin():BitmapSkin{
			return _skinsMap[DISABLE];
		}
		public function set $disableSkin(value:BitmapSkin):void{
			_skinsMap[DISABLE]=value;
		}
		/**
		 * 选中皮肤，如果没有使用正常皮肤 
		 * @param value
		 * 
		 */
		public function set selectedSkin(value:BitmapSkin):void{
			$selectedSkin=value;
			if(_state==SELECTED)
				render();
		}
		public function get selectedSkin():BitmapSkin{
			return _skinsMap[SELECTED];
		}
		public function set $selectedSkin(value:BitmapSkin):void{
			_skinsMap[SELECTED]=value;
		}
		/**
		 * 图片文字
		 * @param value
		 * 
		 */
		public function set textSkin(value:BitmapSkin):void{
			$textSkin=value;
			render();
		}
		public function get textSkin():BitmapSkin{
			return _textSkin;
		}
		public function set $textSkin(value:BitmapSkin):void{
			_textSkin=value;
		}
		
		/**
		 * 文字中心x偏移 
		 * @param value
		 * 
		 */
		public function set textOffsetX(value:Number):void{
			$textOffsetX=value;	
			render();
		}
		public function get textOffsetX():Number{
			return _textOffsetX;
		}
		public function set $textOffsetX(value:Number):void{
			_textOffsetX=value;
		}
		
		/**
		 * 文字中心y偏移 
		 * @param value
		 * 
		 */
		public function set textOffsetY(value:Number):void{
			$textOffsetY=value;	
			render();
		}
		public function get textOffsetY():Number{
			return _textOffsetY;
		}
		public function set $textOffsetY(value:Number):void{
			_textOffsetY=value;
		}
		//-------------------------
		//	text property
		//--------------------------
		private var _text:String;
		private var _htmlText:String;
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
		/**
		 * 禁用 
		 * @param value
		 * 
		 */
		public function set disable(value:Boolean):void{
			$disable=value;	
			render();
		}
		public function get disable():Boolean{
			return _disable;
		}
		public function set $disable(value:Boolean):void{
			_disable=value;
			this.mouseEnabled=this.mouseChildren=!_disable;
			_state=_disable?DISABLE:UP;
		}
		
		public function set selected(value:Boolean):void{
			$selected=value;
			render();
		}
		public function get selected():Boolean{
			return _selected;
		}
		public function set $selected(value:Boolean):void{
			_selected=value;
			if(!_disable){
				_state=_selected?SELECTED:UP;
			}
		}
		
		public function set data(value:Object):void{
			_data=value;
		}
		public function get data():Object{
			return _data;
		}
		//------------------------
		// assets
		//------------------------
		private var _background:Bitmap;
		private var _textField:TextField;
		private var _textBitmap:Bitmap;
		protected function createChildren():void{
			_background=new Bitmap();
			this.addChild(_background);
		}
		//------------------------
		// 渲染
		//------------------------
		public function render():void{
			DebugUtil.traceProcessCurrent("render",this);
			if(!upSkin) return;		//没有弹起皮肤
//			if(!text && !htmlText && !textSkin) return;	//没有文字并且没有文字图像
			
			//背景
			var skin:BitmapSkin=_skinsMap[_state];
			if(_state==DISABLE){
				if(skin){
					_background.$skin=skin;		//存在禁用皮肤
					_background.disable=false;
				}else{
					_background.$skin=_skinsMap[UP]; //不存在禁用皮肤取正常变灰
					_background.disable=true;
				}
			}else{
				_background.disable=false;
				_background.$skin=skin?skin:_skinsMap[UP];	//不存在取正常
			}
			_background.$width=width;
			_background.$height=height;
			_background.render();
			
			//组件大小
			_width=_background.width;
			_height=_background.height;
			
			if(textSkin){		//图片文字
				if(_textField){		//移除文字
					this.removeChild(_textField);
					_textField=null;
				}
				if(!_textBitmap){	//创建图片
					_textBitmap=new Bitmap();
					this.addChild(_textBitmap);
				}
				
				_textBitmap.$skin=textSkin;
				_textBitmap.render();
				
				//图片偏移
				_textBitmap.x=(width-_textBitmap.width)/2+(!isNaN(textOffsetX)?textOffsetX:0);
				_textBitmap.y=(height-_textBitmap.height)/2+(!isNaN(textOffsetY)?textOffsetY:0);
			}else if(text!=null || htmlText!=null){		//文字
				if(_textBitmap){		//移除图片
					this.removeChild(_textBitmap);
					_textBitmap=null;
				}
				if(!_textField){		//创建文字
					_textField=new TextField("",2048,2048);
					this.addChild(_textField);
				}
				
				if(htmlText){
					_textField.htmlText=htmlText;
				}else{
					_textField.text=text;
					_textField.htmlText=null;
				}
				
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
				}
				
				//文字大小
				var textWidth:Number=0,textHeight:Number=0;
				textWidth=textPadding?width-textPadding.paddingLeft-textPadding.paddingRight:width;
				textHeight=textPadding?height-textPadding.paddingTop-textPadding.paddingBottom:height;
				_textField.setSize(textWidth,textHeight);
				//文字偏移位置
				_textField.x=textPadding?textPadding.paddingLeft:0;
				_textField.y=textPadding?textPadding.paddingTop:0;
			}
		}
		
		protected function onBegin(e:TouchEvent):void{
			_state=DOWN;
			render();
		}
		protected function onEnd(e:TouchEvent):void{
			_state=_selected?SELECTED:UP;
			render();
		}
		
		override public function dispose():void{
			super.dispose();
			
			if(_background){
				removeChild(_background);
				_background.dispose();
				_background=null;
			}
			if(_textField){
				if(_textField.parent)
					removeChild(_textField);
				_textField.dispose();
				_textField=null;
			}
			if(_textBitmap){
				if(_textBitmap.parent)
					removeChild(_textBitmap);
				_textBitmap.dispose();
				_textBitmap=null;
			}
			if(_skinsMap){
				for(var i:uint in _skinsMap){
					delete _skinsMap[i];
				}
				_skinsMap=null;
				_skinsMap=new Dictionary(true);
			}
			this.removeEventListener(TouchEvent.TOUCH_BEGIN,onBegin);
			this.removeEventListener(TouchEvent.TOUCH_END,onEnd);
		}
	}
}