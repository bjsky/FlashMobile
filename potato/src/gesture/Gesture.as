package potato.gesture
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import core.display.DisplayObject;
	import core.events.EventDispatcher;
	
	import potato.potato_internal;
	import potato.event.GestureEvent;
	import potato.manager.GestureManager;

	/**
	 * 手势类 手势是触摸事件的自定义验证，不存在冒泡的概念，允许阻止冒泡的touch事件的产生的后续手势验证
	 * @author liuxin
	 * 
	 */
	public class Gesture extends EventDispatcher
	{
		public function Gesture(target:DisplayObject,bubbles:Boolean=true)
		{
			_target=target;
			GestureManager.addGesture(this);
			_bubbles=bubbles;
		}
		use namespace potato_internal;
		
		//////////////////////////
		// states
		/////////////////////////
		/**
		 * 可能
		 */		
		static public const POSSIBLE:String="POSSIBLE";
		/**
		 * 失败
		 */
		static public const FAILED:String="FAILED";
		/**
		 * 确认
		 */
		static public const RECOGNIZED:String="RECOGNIZED";
		
		/**
		 * 开始
		 */
		static public const BEGAN:String="BEGAN";
		
		/**
		 * 改变
		 */
		static public const CHANGED:String="CHANGED";
		
		/**
		 * 结束
		 */
		static public const ENDED:String="ENDED";
		
		
		static private function keyInDic(dic:Dictionary,value:*):Boolean{
			for (var key:* in dic){
				if(key==value){
					return true;
				}
			}
			return false;
		}
		
		//////////////////////////
		//	gestureType
		//////////////////////////
		
		private var _target:DisplayObject;
		private var _bubbles:Boolean=true;
		private var _state:String=POSSIBLE;
		private var _enable:Boolean=true;
		
		potato_internal function get bubbles():Boolean{
			return _bubbles;
		}

		/**
		 * 手势的对象 
		 * @return 
		 * 
		 */
		public function get target():DisplayObject
		{
			return _target;
		}
		
		/**
		 * 手势的状态 
		 * @return 
		 * 
		 */
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			_state = value;
		}
		
		/**
		 * 可用性 
		 * @return 
		 * 
		 */
		public function get enable():Boolean
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void
		{
			_enable = value;
		}

		/**
		 * 阻止上层事件冒泡，但不组织当前显示层
		 * @see potato.gestures.Gestures.stopImmediatePropagation stopImmediatePropagation()
		 */
		public function stopPropagation():void {
			_bubbles = false;
		}
		//------------------------------
		//   touches && location
		//------------------------------
		protected var _touch:Touch;
		protected var _touchesMap:Dictionary = new Dictionary(false);
		protected var _touchesCount:uint = 0;
		protected var _location:Point = new Point();
		
		/**
		 * 唯一的触摸点 
		 * @return 
		 * 
		 */		
		public function get touch():Touch
		{
			return _touch;
		}
		
		/**
		 * 触摸位置或多点触摸中心点位置
		 * @return 
		 * 
		 */		
		public function get location():Point
		{
			return _location.clone();
		}
		
		/**
		 * 更新位置 
		 * 
		 */
		protected function updateLocation():void
		{
			var touchLocation:Point;
			var x:Number = 0;
			var y:Number = 0;
			for (var touchID:String in _touchesMap)
			{
				touchLocation = (_touchesMap[int(touchID)] as Touch).location; 
				x += touchLocation.x;
				y += touchLocation.y;
			}
			_location.x = x / _touchesCount;
			_location.y = y / _touchesCount;
		}
			
		
		/**
		 * 触摸点开始处理 
		 * @param touch
		 * 
		 */
		potato_internal function touchBeginHanlder(touch:Touch):void{
			if(!keyInDic(_touchesMap,touch.id))
				_touchesCount++;
			_touchesMap[touch.id] = touch;
			
			if(_touchesCount==1)
				_touch=touch;
			
			this.dispatchEvent(new GestureEvent(GestureEvent.TOUCH_BEGIN));
			onTouchBegin(touch);
		}
		
		/**
		 * 触摸点移动处理 
		 * @param touch
		 * 
		 */
		potato_internal function touchMoveHanlder(touch:Touch):void{
			_touchesMap[touch.id] = touch;
			
			this.dispatchEvent(new GestureEvent(GestureEvent.TOUCH_MOVE));
			onTouchMove(touch);
		}
		/**
		 * 触摸点结束处理 
		 * @param touch
		 * 
		 */
		potato_internal function touchEndHanlder(touch:Touch):void{
			delete _touchesMap[touch.id];
			_touchesCount--;
			
			this.dispatchEvent(new GestureEvent(GestureEvent.TOUCH_END));
			onTouchEnd(touch);
		}
		
		potato_internal function touchCancelHandler(touch:Touch):void
		{
			delete _touchesMap[touch.id];
			_touchesCount--;
			
			onTouchCancel(touch);
		}
		
		protected function onTouchCancel(touch:Touch):void
		{
		}
		/**
		 * 子类重写触摸点开始处理 
		 * @param touch
		 * 
		 */
		protected function onTouchBegin(touch:Touch):void{
			//			trace("["+eventType+"]touchBegin");
		}
		
		/**
		 * 子类重写触摸点移动处理 
		 * @param touch
		 * 
		 */
		protected function onTouchMove(touch:Touch):void{
			//			trace("["+eventType+"]touchMove");
		}
		
		/**
		 * 子类重写触摸点结束处理 
		 * @param touch
		 * 
		 */
		protected function onTouchEnd(touch:Touch):void{
			//			trace("["+eventType+"]touchEnd");
		}
		
		override public function dispose():void{
			super.dispose();
			
			this._touchesMap=null;
			this._touchesCount=0;
			this._location=null;
			
			GestureManager.removeGesture(this);
			this._target=null;
		}
	}
}