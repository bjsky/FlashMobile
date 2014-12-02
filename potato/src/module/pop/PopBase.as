package potato.module.pop
{
	import core.display.DisplayObjectContainer;
	import core.display.Stage;
	import core.display.TextureData;
	import core.events.TouchEvent;
	
	import potato.potato_internal;
	import potato.component.Bitmap;
	import potato.component.BorderContainer;
	import potato.component.data.BitmapSkin;
	import potato.event.GestureEvent;
	import potato.gesture.DragGesture;
	import potato.manager.DragManager;
	import potato.module.EffectUIEvent;
	import potato.module.IEffectUI;
	
	/**
	 * 弹窗基类.
	 * @author liuxin
	 * 
	 */
	public class PopBase extends BorderContainer
		implements Ipop,IEffectUI
	{
		public function PopBase(width:Number=NaN, height:Number=NaN)
		{
			super(width, height);
			this.addEventListener(TouchEvent.TOUCH_BEGIN,onTouch);
		}
		use namespace potato_internal;
		
		private var _isPop:Boolean=false;
		private var _dragEnable:Boolean=false;
		private var _mask:Bitmap;
		private var _dragGesture:DragGesture;
		
		override public function set x(_arg1:Number):void{
			super.x=_arg1;
			if(_mask){
				_mask.x=-x;
			}
		}
		override public function set y(_arg1:Number):void{
			super.y=_arg1;
			if(_mask){
				_mask.y=-y;
			}
		}
		
		/**
		 * 是否弹出 
		 * @return 
		 * 
		 */
		public function get isPop():Boolean
		{
			return _isPop;
		}

		public function set isPop(value:Boolean):void
		{
			_isPop = value;
		}
		
		/**
		 * 是否可以拖动 
		 * @return 
		 * 
		 */
		public function get dragEnable():Boolean
		{
			return _dragEnable;
		}
		
		public function set dragEnable(value:Boolean):void
		{
			if(_dragEnable!=value){
				_dragEnable = value;
				if(_dragEnable){
					_dragGesture=new DragGesture(content);
					_dragGesture.addEventListener(GestureEvent.DRAG_BEGIN,dragBegin);
					_dragGesture.addEventListener(GestureEvent.DRAG_END,dragEnd);
				}else{
					_dragGesture.removeEventListeners();
					_dragGesture.dispose();
				}
			}
		}
		
		private function dragBegin(e:GestureEvent):void
		{
			DragManager.doDrag(this,_dragGesture,this,null,this.globalToLocal(_dragGesture.location));
		}
		
		private function dragEnd(e:GestureEvent):void
		{
			DragManager.stopDrag(_dragGesture);
		}
		
		private var _parentObj:DisplayObjectContainer;
		
		/**
		 * 打开弹出窗口 
		 * @param modal 是否模态，ture为模态
		 * 
		 */
		public function open(parentObj:DisplayObjectContainer,modal:Boolean=false):void
		{
			if(_isPop || parentObj==parent) return;
			
			_parentObj=parentObj;
			if(modal){//场景遮罩
				var td:TextureData=TextureData.createRGB(Stage.getStage().stageWidth,Stage.getStage().stageHeight,true,0x33ffffff);
				_mask=new Bitmap(new BitmapSkin(td),Stage.getStage().stageWidth,Stage.getStage().stageHeight);
				background.addChild(_mask);
			}else{
				if(_mask){ 
					background.removeChild(_mask);
					_mask.dispose();
				}
			}
			
			_parentObj.addChild(this);
			_isPop=true;
				
			show();
		}
		
		private function onTouch(e:TouchEvent):void
		{
			if(e.target == _mask){
				this.dispatchEvent(new PopEvent(PopEvent.MASK_TOUCH));
			}else{
				this.dispatchEvent(new PopEvent(PopEvent.POP_TOUCH));
			}
		}
		
		/**
		 * 显示效果 
		 * 
		 */
		public function show():void{
			showComplete();
		}
		
		/**
		 * 显示效果完成 
		 * 
		 */
		public function showComplete():void{
			this.dispatchEvent(new EffectUIEvent(EffectUIEvent.SHOW_COMPLETE));
		}
		
		
		/**
		 * 关闭弹出窗口 
		 * 
		 */
		public function close():void
		{
			if(!_isPop) return;
			hide();
		}
		
		/**
		 * 隐藏效果
		 * 
		 */
		public function hide():void{
			hideComplete();
		}
		
		/**
		 * 隐藏效果完成 
		 * 
		 */
		public function hideComplete():void
		{
			//移除遮罩
			if(_mask){ 
				background.removeChild(_mask);
				_mask.dispose();
			}
			
			if(_parentObj && this.parent==_parentObj){
				_parentObj.removeChild(this);
				_parentObj=null;
			}
			
			_isPop=false;
			this.dispatchEvent(new EffectUIEvent(EffectUIEvent.HIDE_COMPLETE));
		}
		
		override public function dispose():void{
			super.dispose();
			//由弹出管理器关闭
			this.removeEventListener(TouchEvent.TOUCH_BEGIN,onTouch);
		}
		
	}
}