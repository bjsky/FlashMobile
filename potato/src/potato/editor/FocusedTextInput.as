package potato.editor
{
	import flash.utils.Dictionary;
	
	import core.events.TouchEvent;
	
	import potato.component.TextInput;
	import potato.component.core.FocusManager;
	import potato.component.core.IFocus;
	import potato.component.data.BitmapSkin;
	import potato.component.data.Padding;
	import potato.component.data.TextFormat;
	
	public class FocusedTextInput extends TextInput
		implements IFocus
	{
		public function FocusedTextInput(skins:*=null, text:String="", defaultText:String="", width:Number=NaN, height:Number=NaN, textformat:TextFormat=null, textPadding:Padding=null, mutiLine:Boolean=false, maxChar:int=0, maxLine:int=0, restrict:String="", displayAsPassword:Boolean=false)
		{
			super(skins, text, defaultText, width, height, textformat, textPadding, mutiLine, maxChar, maxLine, restrict, displayAsPassword);
			focusEnable=focusEnable;
		}
		//皮肤
		public static const SKIN:uint=0;
		public static const DISABLE_SKIN:uint=1;
		public static const HOVER_SKIN:uint=2;
		
		private var _skins:String;
		private var _skinsArr:Array=[null,null,null];
		private var _skinsMap:Dictionary=new Dictionary(true);
		
		
		private var _focusEnable:Boolean=true;
		private var _isHover:Boolean=false;
		
		public function get focusEnable():Boolean
		{
			return _focusEnable;
		}
		
		public function set focusEnable(value:Boolean):void
		{
			_focusEnable = value;
			if(_focusEnable)
				addEventListener(TouchEvent.TOUCH_BEGIN,touchBeginHanlder);
			else
				removeEventListener(TouchEvent.TOUCH_BEGIN,touchBeginHanlder);
		}
		
		private function touchBeginHanlder(e:TouchEvent):void
		{
			// TODO Auto Generated method stub
			FocusManager.setFocus(this);
		}
		
		public function onFocus():void{
			_isHover=true;
			invalidate(render);
		}
		public function outFocus():void{
			_isHover=false;
			invalidate(render);
		}
		
		override public function set skins(value:*):void
		{
			_skins=value;	
			_skinsArr=BitmapSkin.fillSkins(_skinsArr,value);
			for (var i:int=0;i<_skinsArr.length;i++){
				_skinsMap[i]=_skinsArr[i];
			}
			invalidate(render);
		}
		
		override protected function get currentSkin():BitmapSkin{
			return disable?_skinsMap[DISABLE_SKIN]:(_isHover?_skinsMap[HOVER_SKIN]:_skinsMap[SKIN]);
		}
		
		override public function dispose():void{
			super.dispose();
			
			FocusManager.deleteFocus(this);
		}
	}
}