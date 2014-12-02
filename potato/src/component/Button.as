package potato.component
{
	import flash.utils.Dictionary;
	
	import core.display.DisplayObjectContainer;
	import core.events.TouchEvent;
	import core.text.TextField;
	
	import potato.component.data.BitmapSkin;
	import potato.component.data.Padding;
	import potato.component.data.TextFormat;
	import potato.component.interf.IDataBinding;
	import potato.component.interf.IGroupedToggle;
	import potato.component.interf.ISprite;
	import potato.event.PotatoEvent;
	import potato.logger.Logger;
	import potato.manager.RenderManager;
	import potato.utils.StringUtil;

	
	/**
	 * 选择改变事件.
	 * @author liuxin
	 * 
	 */
	[Event(name="selectChange",type="potato.event.PotatoEvent")]
	
	/**
	 * 按钮. 
	 * <p>可以设置正常、按下、禁用、状态的皮肤样式，设置isToggle属性为true，表示开关按钮，可以设置选中状态下的正常，按下，禁用皮肤。
	 * 按钮的大小，由按钮的皮肤或者设置的宽高决定：当设置大小时，按钮的皮肤根据大小缩放，否则按钮的大小为皮肤的大小。不同状态下的皮肤对应不同的按钮大小。</p>
	 * <p>按钮可以设置text、htmlText文字，或者设置图片文字textSkin。设置文字时，通过设置textPadding文字填充改变文字的位置或者textFormat改变文字的内容样式</p>
	 * <p>按钮实现了<code>IGroupedToggle</code>接口，可以指定从属的按钮组从而创建带选中状态的按钮组。
	 * 当按钮的选中状态改变时，按钮派发PotatoEvent.SELECT_CHANGE事件，从属的组派发PotatoEvent.GROUP_SELECT_CHANGE事件，可以侦听事件处理选中改变。</p>
	 * @author liuxin
	 * 
	 * @example 包含一个按钮的样例
	 * <listing>
	 * class ButtonExample{
	 * 
	 * 	public function ButtonExample(){
	 * 
	 * 		var btn:Button=new Button();
	 * 		addChild(btn);
	 * 
	 * 		//皮肤
	 * 		var btn2:Button=new Button("button_up_skin,button_down_skin,button_disable_skin","Click me!",100,36);
	 * 		//文字样式
	 * 		btn2.textFormat=new TextFormat("黑体",26,0x000,TextField.ALIGN_CENTER,TextField.ALIGN_CENTER);
	 * 		//文字填充
	 * 		btn2.textPadding=new Padding(10,4,10,4);
	 * 		addChild(btn2);
	 * 
	 * 		//九宫格皮肤
	 * 		var skins:Array=[new BitmapSkin("button_up_skin","5,5,5,5"),new BitmapSkin("button_down_skin","5,5,5,5")];
	 * 		var btn3:Button=new Button(skins,"Click me!",100,36);
	 * 		btn3.htmlText="<b>Html Text Here!</b>";
	 * 		addChild(btn3);
	 * 
	 * 		//图片文字
	 * 		var btn4:Button=new Button("button_up_skin,button_down_skin,button_disable_skin","",100,36);
	 * 		var front:Bitmap=btn4.addChild(new Bitmap("frontImage"));
	 * 		front.x=5;
	 * 		front.y=5;
	 * 		addChild(btn4);
	 * 
	 * 		//选中
	 * 		var skins:String="button_up_skin,button_down_skin,button_disable_skin,button_select_up_skin,button_select_down_skin,button_select_disable_skin";
	 * 		var btn5:Button=new Button(skins,"click me!",100,36);
	 * 		btn5.isToggle=true;
	 * 		btn5.addEventListener(PotatoEvent.SELECT_CHANGE,onBtnSelectedChange);
	 * 		btn5.selected=true;
	 * 		addChild(btn5);
	 * 
	 * 		//按钮组
	 * 		var group:ToggleGroup=new ToggleGroup();
	 * 		group.addEventListener(PotatoEvent.GROUP_SELECT_CHANGE,onGroupSelectedChange);
	 * 
	 * 		var gBtn1:Button=new Button("button_up_skin,,,button_select_up_skin","选项1");
	 * 		gBtn1.isToggle=true;
	 * 		gBtn1.toggleGroup=group;
	 * 		addChild(gBtn1);
	 * 		var gBtn2:Button=new Button("button_up_skin,,,button_select_up_skin","选项2");
	 * 		gBtn2.isToggle=true;
	 * 		gBtn2.toggleGroup=group;
	 * 		addChild(gBtn2);
	 * 
	 * 		gBtn1.selected=true;
	 *
	 * 	}
	 * 
	 * 	function onBtnSelectedChange(e:PotatoEvent):void
	 * 	{
	 * 		var btn:Button=e.currentTarget as Button;
	 * 		trace(btn.selected); 
	 * 	}
	 * 
	 * 
	 * 	function onGroupSelectedChange(e:PotatoEvent):void
	 * 	{
	 * 		var group:ToggleGroup=e.currentTarget as ToggleGroup;
	 * 		trace(group.selectIndex);
	 * 	}
	 * }
	 * </listing>
	 */
	public class Button extends DisplayObjectContainer
		implements ISprite,IGroupedToggle,IDataBinding
	{
		/**
		 * 创建按钮
		 * @param skins 皮肤字符串（正常，按下，禁用，选中，选中禁用）
		 * @param text 文字
		 * @param width 宽
		 * @param height 高
		 * @param textformat 文字样式
		 * @param textPadding 文字填充
		 * @param isToggle 开关按钮
		 */
		public function Button(skins:*=null,text:String="",width:Number=NaN,height:Number=NaN,
											textformat:TextFormat=null,textPadding:Padding=null,isToggle:Boolean=false)
		{
			super();
			createChildren();
			
			this.addEventListener(TouchEvent.TOUCH_BEGIN,onBegin);
			this.addEventListener(TouchEvent.MULTI_TOUCH_BEGIN,onBegin);
			this.addEventListener(TouchEvent.TOUCH_END,onEnd);
			this.addEventListener(TouchEvent.MULTI_TOUCH_END,onEnd);
			
			this.skins=skins;
			this.text=text;
			this.width=width;
			this.height=height;
			this.textFormat=textformat;
			this.textPadding=textPadding;
		}

		/**
		 * 正常 
		 */
		static public const UP_SKIN:uint=0;			
		/**
		 * 按下 
		 */
		static public const DOWN_SKIN:uint=1;
		/**
		 * 禁用 
		 */
		static public const DISABLE_SKIN:uint=2;
		/**
		 * 选中 正常 
		 */
		static public const SELECTED_UP_SKIN:uint=3;
		/**
		 * 选中 按下 
		 */
		static public const SELECTED_DOWN_SKIN:uint=4;
		
		/**
		 * 选中 禁用 
		 */
		static public const SELECTED_DISABLE_SKIN:uint=5;
		
		//----------------------------
		//	ISprite
		//----------------------------
		private var _width:Number;
		private var _height:Number;
		private var _scale:Number;
		private var _validateMode:uint=RenderManager.CALLLATER;
		
		
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
				invalidate(render);
			}
		}
		override public function get width():Number{
			if(!isNaN(_width))
				return _width;
			else{
				return currentSkin?currentSkin.width:0;
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
				invalidate(render);
			}
		}
		override public function get height():Number{
			if(!isNaN(_height))
				return _height;
			else
				return currentSkin?currentSkin.height:0;
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
		private var _skins:*;
		private var _skinsArr:Array=[null,null,null,null,null,null];
		private var _disable:Boolean=false;
		private var _skinsMap:Dictionary=new Dictionary();
		private var _state:uint=UP_SKIN;
		private var _selected:Boolean=false;
		private var _data:Object;
		private var _isDown:Boolean=false;
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
		 * 皮肤字符串 [正常，按下，禁用，选中]
		 * @param value
		 * 
		 */
		public function set skins(value:*):void{
			_skins=value;	
			_skinsArr=StringUtil.fillSkins(_skinsArr,value);
			for (var i:int=0;i<_skinsArr.length;i++){
				_skinsMap[i]=_skinsArr[i];//BitmapSkin.createWithName(skinStr);
			}
			invalidate(render);
		}
		public function get skins():*{
			return _skins;
		}
		
		/**
		 * 正常皮肤 
		 * @param value
		 * 
		 */
		public function set upSkin(value:BitmapSkin):void{
			_skinsMap[UP_SKIN]=value;
			if(_state==UP_SKIN)
				invalidate(render);
		}
		public function get upSkin():BitmapSkin{
			return _skinsMap[UP_SKIN];
		}
		
		
		/**
		 * 按下皮肤 ，如果没有就使用正常皮肤
		 * @param value
		 * 
		 */
		public function set downSkin(value:BitmapSkin):void{
			_skinsMap[DOWN_SKIN]=value;
			if(_state==DOWN_SKIN)
				invalidate(render);
		}
		public function get downSkin():BitmapSkin{
			return _skinsMap[DOWN_SKIN];
		}
		
		/**
		 * 禁用皮肤 ，如果没有使用灰度滤镜
		 * @param value
		 * 
		 */
		public function set disableSkin(value:BitmapSkin):void{
			_skinsMap[DISABLE_SKIN]=value;
			if(_state==DISABLE_SKIN)
				invalidate(render);
		}
		public function get disableSkin():BitmapSkin{
			return _skinsMap[DISABLE_SKIN];
		}
		
		/**
		 * 选中正常皮肤
		 * @param value
		 * 
		 */
		public function set selectedUpSkin(value:BitmapSkin):void{
			_skinsMap[SELECTED_UP_SKIN]=value;
			if(_state==SELECTED_UP_SKIN)
				invalidate(render);
		}
		public function get selectedUpSkin():BitmapSkin{
			return _skinsMap[SELECTED_UP_SKIN];
		}
		
		/**
		 * 选中按下皮肤
		 * @param value
		 * 
		 */
		public function set selectedDownSkin(value:BitmapSkin):void{
			_skinsMap[SELECTED_DOWN_SKIN]=value;
			if(_state==SELECTED_DOWN_SKIN)
				invalidate(render);
		}
		public function get selectedDownSkin():BitmapSkin{
			return _skinsMap[SELECTED_DOWN_SKIN];
		}
		
		/**
		 * 选中禁用皮肤 
		 * @param value
		 * 
		 */
		public function set selectedDisableSkin(value:BitmapSkin):void{
			_skinsMap[SELECTED_DISABLE_SKIN]=value;
			if(_state==SELECTED_DISABLE_SKIN)
				invalidate(render);
		}
		public function get selectedDisableSkin():BitmapSkin{
			return _skinsMap[SELECTED_DISABLE_SKIN];
		}
		
		//-------------------------
		//	text property
		//--------------------------
		private var _text:String;
		private var _htmlText:String;
		private var _textFormat:TextFormat;
		private var _textPadding:Padding;
		private var _toggleGroup:ToggleGroup;
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
				invalidate(render);
			}
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
			invalidate(render);
		}

		/**
		 * 禁用 
		 * @param value
		 * 
		 */
		public function set disable(value:Boolean):void{
			if(_disable!=value){
				_disable=value;
				this.mouseEnabled=this.mouseChildren=!_disable;
				invalidate(render);
			}
		}
		public function get disable():Boolean{
			return _disable;
		}
		
		/**
		 * 是否选中 
		 * @param value
		 * 
		 */
		public function set selected(value:Boolean):void{
			if(_selected!=value){
				_selected=value;
				dispatchEvent(new PotatoEvent(PotatoEvent.SELECT_CHANGE));
				if(_selected && _toggleGroup){
					_toggleGroup.select(this);
				}
				invalidate(render);
			}
		}
		public function get selected():Boolean{
			return _selected;
		}
		
		/**
		 * 数据 
		 * @param value
		 * 
		 */
		public function set data(value:Object):void{
			_data=value;
		}
		public function get data():Object{
			return _data;
		}
		
		/**
		 * 开关按钮组 
		 * @return 
		 * 
		 */
		public function get toggleGroup():ToggleGroup
		{
			return _toggleGroup;
		}
		
		public function set toggleGroup(value:ToggleGroup):void
		{
			if(value==_toggleGroup)
				return;
			
			if(_toggleGroup){
				_toggleGroup.removeItem(this);
			}
			_toggleGroup = value;
			if(_toggleGroup){
				_toggleGroup.addItem(this);
			}
		}

		//------------------------
		// assets
		//------------------------
		private var _background:Bitmap;
		private var _textField:TextField;
		protected function createChildren():void{
			_background=new Bitmap();
			this.addChild(_background);
		}
		//------------------------
		// 渲染
		//------------------------
		private function get currentSkin():BitmapSkin{
			if(!_disable && !_selected && !_isDown){
				_state=UP_SKIN;
			}else if(!_disable && !_selected && _isDown){
				_state=DOWN_SKIN;
			}else if(!_disable && _selected && !_isDown){
				_state=SELECTED_UP_SKIN;
			}else if(!_disable && _selected && _isDown){
				_state=SELECTED_DOWN_SKIN;
			}else if(_disable && _selected){
				_state=SELECTED_DISABLE_SKIN;
			}else if(_disable && !_selected){
				_state=DISABLE_SKIN;
			}
			
			return _skinsMap[_state]!=null?_skinsMap[_state]:upSkin;
		}
		/**
		 * 渲染组件内容 
		 * 
		 */
		private function render():void{
//			trace("__________render1")
			if(!_background)	return;
			
			//背景
			_background.skin=currentSkin;		
			_background.width=_width;
			_background.height=_height;
			
			if(_disable){
				if(_state==DISABLE_SKIN || _state==SELECTED_DISABLE_SKIN){
					_background.disable=false;		
				}else{
					_background.disable=true;		
				}
			}else{
				_background.disable=false;
			}
			
			if(text!=null || htmlText!=null){		//文字
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
		
		private function onBegin(e:TouchEvent):void{
			_isDown=true;
			
			render();
		}
		private function onEnd(e:TouchEvent):void{
			_isDown=false;
			render();
		}
		
		/**
		 * 释放资源 
		 * 
		 */
		override public function dispose():void{
			super.dispose();
			RenderManager.dispose(this);
			
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
			if(_skinsMap){
				for(var i:String in _skinsMap){
					delete _skinsMap[uint(i)];
				}
				_skinsMap=null;
				_skinsMap=new Dictionary(true);
			}
			toggleGroup=null;
			
			this.removeEventListener(TouchEvent.TOUCH_BEGIN,onBegin);
			this.removeEventListener(TouchEvent.MULTI_TOUCH_BEGIN,onBegin);
			
			this.removeEventListener(TouchEvent.TOUCH_END,onEnd);
			this.removeEventListener(TouchEvent.MULTI_TOUCH_END,onEnd);
			
		}
	}
}