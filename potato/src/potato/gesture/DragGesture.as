package potato.gesture
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import core.display.DisplayObject;
	import core.display.Stage;
	
	import potato.gesture.drag.DragEvent;
	import potato.gesture.drag.IDropTrigger;

	/**
	 * 拖动开始.
	 * @author liuxin
	 * 
	 */
	[Event(name="dragBegin",type="potato.gesture.GestureEvent")]
	/**
	 * 拖动过程中.
	 * @author liuxin
	 * 
	 */
	[Event(name="dragMove",type="potato.gesture.GestureEvent")]
	/**
	 * 拖动结束.
	 * @author liuxin
	 * 
	 */
	[Event(name="dragEnd",type="potato.gesture.GestureEvent")]
	/**
	 * 拖动手势.
	 * <p>验证拖动放置的平移手势</p> 
	 * @author liuxin
	 * 
	 */
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
		private var _dragRectangle:Rectangle;
		
		/**
		 *拖动范围限制 
		 * @return 
		 * 
		 */		
		public function get dragRectangle():Rectangle
		{
			return _dragRectangle;
		}
		
		public function set dragRectangle(value:Rectangle):void
		{
			_dragRectangle = value;
		}
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
			if(state==BEGIN)
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
			if(state==POSSIBLE || state==BEGIN || state ==CHANGED){
				if(state==POSSIBLE)
					state=BEGIN;
				else if(state==BEGIN || state==CHANGED)
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
			if(state==POSSIBLE || state==BEGIN || state ==CHANGED){
				
				var i:int=0;
				for each(var trigger:IDropTrigger in _triggers){
					if(trigger.dropIgnoreChildren ||(!trigger.dropIgnoreChildren && i==0))
						DisplayObject(trigger).dispatchEvent(new DragEvent(DragEvent.DRAG_DROP,this));
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
					DisplayObject(trigger).dispatchEvent(new DragEvent(DragEvent.DRAG_EXIT,this));
			}
			for each(var trigger:IDropTrigger in _triggers){
				var index:int=_prevTriggers.indexOf(trigger);
				if(index>-1){
					if(!trigger.dropIgnoreChildren){
						if(index==0){		//靠前
							if(i==0)
								DisplayObject(trigger).dispatchEvent(new DragEvent(DragEvent.DRAG_OVER,this));
							else
								DisplayObject(trigger).dispatchEvent(new DragEvent(DragEvent.DRAG_EXIT,this));
						}else{
							if(i==0)
								DisplayObject(trigger).dispatchEvent(new DragEvent(DragEvent.DRAG_ENTER,this));
							else
								DisplayObject(trigger).dispatchEvent(new DragEvent(DragEvent.DRAG_OVER,this));
						}
					}else		
						DisplayObject(trigger).dispatchEvent(new DragEvent(DragEvent.DRAG_OVER,this));
				}else{		//新加入的trigger
					if(trigger.dropIgnoreChildren || (!trigger.dropIgnoreChildren && i==0))
						DisplayObject(trigger).dispatchEvent(new DragEvent(DragEvent.DRAG_ENTER,this));
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