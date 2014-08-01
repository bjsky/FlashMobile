package potato.gesture
{
	import flash.geom.Point;
	
	import core.display.DisplayObject;
	import core.display.Stage;
	
	import potato.component.IDropTrigger;
	import potato.event.DropEvent;
	import potato.event.GestureEvent;

	public class DragGesture extends Gesture
	{
		public function DragGesture(target:DisplayObject,bubbles:Boolean=true)
		{
			super(target,bubbles);
		}
		
		//-------------------
		// properties
		//-------------------
		protected var _offsetX:Number = 0;
		protected var _offsetY:Number = 0;

		/**
		 * x的偏移 
		 * @return 
		 * 
		 */
		public function get offsetX():Number
		{
			return _offsetX;
		}
		
		/**
		 * y的偏移 
		 * @return 
		 * 
		 */
		public function get offsetY():Number
		{
			return _offsetY;
		}
		
		//--------------------------------
		// dragManager
		//--------------------------------
		private var _isDragging:Boolean=false;
		private var _dragInitiator:DisplayObject;
		private var _dragImage:DisplayObject;
		private var _dragSource:Object;
		
		
		/**
		 * 正在移动 
		 * @return 
		 * 
		 */
		public function get isDragging():Boolean
		{
			return _isDragging;
		}
		
		public function set isDragging(value:Boolean):void
		{
			_isDragging = value;
		}
		
		/**
		 * 拖动的数据源 
		 * @return 
		 * 
		 */
		public function get dragSource():Object
		{
			return _dragSource;
		}
		
		public function set dragSource(value:Object):void
		{
			_dragSource = value;
		}
		
		/**
		 * 拖动的图像 
		 * @return 
		 * 
		 */
		public function get dragImage():DisplayObject
		{
			return _dragImage;
		}
		
		public function set dragImage(value:DisplayObject):void
		{
			_dragImage = value;
		}
		
		/**
		 * 拖动的初始化对象 
		 * @return 
		 * 
		 */
		public function get dragInitiator():DisplayObject
		{
			return _dragInitiator;
		}
		
		public function set dragInitiator(value:DisplayObject):void
		{
			_dragInitiator = value;
		}

		
		override public function set state(value:String):void
		{
			super.state=value;
			if(state==BEGAN)
				dispatchEvent(new GestureEvent(GestureEvent.DRAG_BEGIN));
			else if(state==CHANGED)
				this.dispatchEvent(new GestureEvent(GestureEvent.DRAG_MOVE));
			else if(state==ENDED)
				this.dispatchEvent(new GestureEvent(GestureEvent.DRAG_END));
		}
		
		/**
		 * 重写开始处理 
		 * @param touch
		 * 
		 */
		override protected function onTouchBegin(touch:Touch):void
		{
			super.onTouchBegin(touch);
			if(_touchesCount==1){
				state=POSSIBLE;
				_offsetX = 0;
				_offsetY = 0;
				updateLocation();
			}else{
				state=FAILED;
			}
		}
		
		/**
		 * 重写移动处理 
		 * @param touch
		 * 
		 */
		override protected function onTouchMove(touch:Touch):void
		{
			super.onTouchMove(touch);
			if(state==POSSIBLE || state==BEGAN || state ==CHANGED){
				if(state==POSSIBLE)
					state=BEGAN;
				else if(state==BEGAN || state==CHANGED)
					state=CHANGED;
				
				updatePanOffset();
			}
		}
		
		/**
		 * 重写结束处理 
		 * @param touch
		 * 
		 */
		override protected function onTouchEnd(touch:Touch):void
		{
			super.onTouchEnd(touch);
			if(state==POSSIBLE || state==BEGAN || state ==CHANGED){
				
				var i:int=0;
				for each(var trigger:IDropTrigger in _triggers){
					if(trigger.ignoreBubbles ||(!trigger.ignoreBubbles && i==0))
						DisplayObject(trigger).dispatchEvent(new DropEvent(DropEvent.DRAG_DROP,this));
					i++;
				}
				
				state=ENDED;
				
				_triggers=[];
				_prevTriggers=[];
			}
		}
		
		private var _last:Object;
		private var _triggers:Array=[];
		private var _prevTriggers:Array=[];
		
		private function updatePanOffset():void{
			//上次位置
			var prevLocation:Point = location;
			//更新位置
			updateLocation();
			var locationOffset:Point=location.subtract(prevLocation);
			
			_offsetX = locationOffset.x;
			_offsetY = locationOffset.y;
			
			_triggers=[];
			_triggers=getTriggers(touch.currentTarget,_triggers);
			var i:int=0;
			for each(trigger in _prevTriggers){
				if(_triggers.indexOf(trigger)<0)		//移除的trigger
					DisplayObject(trigger).dispatchEvent(new DropEvent(DropEvent.DRAG_EXIT,this));
			}
			for each(var trigger:IDropTrigger in _triggers){
				var index:int=_prevTriggers.indexOf(trigger);
				if(index>-1){
					if(!trigger.ignoreBubbles){
						if(index==0){		//靠前
							if(i==0)
								DisplayObject(trigger).dispatchEvent(new DropEvent(DropEvent.DRAG_OVER,this));
							else
								DisplayObject(trigger).dispatchEvent(new DropEvent(DropEvent.DRAG_EXIT,this));
						}else{
							if(i==0)
								DisplayObject(trigger).dispatchEvent(new DropEvent(DropEvent.DRAG_ENTER,this));
							else
								DisplayObject(trigger).dispatchEvent(new DropEvent(DropEvent.DRAG_OVER,this));
						}
					}else		
						DisplayObject(trigger).dispatchEvent(new DropEvent(DropEvent.DRAG_OVER,this));
				}else{		//新加入的trigger
					if(trigger.ignoreBubbles || (!trigger.ignoreBubbles && i==0))
						DisplayObject(trigger).dispatchEvent(new DropEvent(DropEvent.DRAG_ENTER,this));
				}
				i++;
			}
			
			_prevTriggers=_triggers;
		}
		
		private function getTriggers(target:Object,arr:Array):Array{
			if(!target || !(target is DisplayObject)|| target is Stage)
				return arr;
			
			if(target is IDropTrigger && IDropTrigger(target).dropEnable){
				arr.push(IDropTrigger(target));
			}
			return getTriggers(DisplayObject(target).parent,arr);
		}
	}
}