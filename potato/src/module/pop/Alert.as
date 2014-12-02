package potato.module.pop
{
	import core.filters.ShadowFilter;
	import core.text.TextField;
	
	import potato.component.Bitmap;
	import potato.component.Button;
	import potato.component.Container;
	import potato.component.Text;
	import potato.component.data.BitmapSkin;
	import potato.component.data.TextFormat;
	import potato.event.GestureEvent;
	import potato.gesture.TapGesture;

	/**
	 * 提示框 
	 * @author win7
	 * 
	 */
	public class Alert extends PopBase
	{
		public function Alert(width:Number=NaN, height:Number=NaN)
		{
			super(width, height);
		}
		public static const OK:uint=0;
		public static const CANCEL:uint=1;
		
		private var defaultTextFormat:TextFormat= new TextFormat("黑体",22,0xd6d6d6,TextField.ALIGN_CENTER,TextField.ALIGN_CENTER
			,new ShadowFilter(0x77000000,2,2,false))
		
		/**
		 * 提示文字 
		 * @return 
		 * 
		 */
		public function get text():String
		{
			return _textTxt.text;
		}

		public function set text(value:String):void
		{
			_textTxt.text = value;
		}

		/**
		 * 标题文字 
		 * @param value
		 * 
		 */
		public function set title(value:String):void{
			_titleTxt.text=value;
		}
		public function get title():String{
			return _titleTxt.text;
		}
		
		override public function set width(value:Number):void{
			super.width=value;
		}
		override public function set height(value:Number):void{
			super.height=value;
		}
		
		/**
		 * 完成回调：
		 * function callback(type:uint):void; 		---value:OK/CANCEL
		 */
		public var callback:Function;
		
		protected var _closeBtn:Button;
		protected var _okBtn:Button;
		protected var _cancelBtn:Button;
		protected var _titleTxt:Text;
		protected var _textTxt:Text;
		protected var _bg:Bitmap;
		protected var _btnContainer:Container;
		
		/**
		 * 需要重写createClidren的样式 
		 * 
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			_bg =new Bitmap(new BitmapSkin("panelBackground.png","15,50,15,20"),width,height);
			this.addChild(_bg);
			
			_closeBtn=new Button("closeButtonUp.png,closeButtonDown.png");
			var closeTap:TapGesture=new TapGesture(_closeBtn);
			closeTap.addEventListener(GestureEvent.TAP,onCloseBtnHandler);
			this.addChild(_closeBtn);
			
			_titleTxt=new Text("",null,NaN,NaN,defaultTextFormat);
			this.addChild(_titleTxt);
			
			_textTxt=new Text("",null,NaN,NaN,defaultTextFormat);
			this.addChild(_textTxt);
			
			_btnContainer=new Container();
			_okBtn=new Button([new BitmapSkin("buttonUp.png","5,5,5,5"),new BitmapSkin("buttonDown.png","5,5,5,5")]
				,"确定",100,44,defaultTextFormat);
			var okTap:TapGesture=new TapGesture(_okBtn);
			okTap.addEventListener(GestureEvent.TAP,onOkBtnHandler);
			_btnContainer.addChild(_okBtn);
			_cancelBtn=new Button([new BitmapSkin("buttonUp.png","5,5,5,5"),new BitmapSkin("buttonDown.png","5,5,5,5")]
				,"取消",100,44,defaultTextFormat);
			var cancelTap:TapGesture=new TapGesture(_cancelBtn);
			cancelTap.addEventListener(GestureEvent.TAP,onCancelBtnHandler);
			_btnContainer.addChild(_cancelBtn);
			this.addChild(_btnContainer);
		}
		
		override protected function render():void{
			super.render();
			
			_bg.width=width;
			_bg.height=height;
			
			_closeBtn.x=width-_closeBtn.width-5;
			_closeBtn.y=5;
		
			_titleTxt.x=10;
			_titleTxt.y=10;
		
			_textTxt.x=20;
			_textTxt.y=40;
			_textTxt.width=width-40;
			_textTxt.height=height-80;
		
			_cancelBtn.x=_okBtn.width+20;
		
			_btnContainer.x=(width-_btnContainer.width)/2;
			_btnContainer.y=height-_btnContainer.height-20;
			
		}
		
		private var _returnType:uint;
		private function onCancelBtnHandler(e:GestureEvent):void
		{
			// TODO Auto Generated method stub
			_returnType=CANCEL;
			close();
		}
		
		private function onOkBtnHandler(e:GestureEvent):void
		{
			// TODO Auto Generated method stub
			_returnType=OK;
			close();
		}
		
		private function onCloseBtnHandler(e:GestureEvent):void
		{
			// TODO Auto Generated method stub
			_returnType=CANCEL;
			close();
		}
		
		override public function  hideComplete():void{
			super.hideComplete();
			if(callback!=null)
				callback(_returnType);
		}
	}
}