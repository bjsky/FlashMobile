package potato.gesture
{
	import core.events.Event;
	
	import potato.potato_internal;

	/**
	 * 单次触摸冒泡 
	 * @author liuxin
	 * 
	 */
	public class TouchBubbles
	{
		/**
		 *  
		 * @param touch 触摸点
		 * @param type	冒泡类型
		 * 
		 */
		public function TouchBubbles(touch:Touch,type:String)
		{
			this.touch=touch;
			this.type=type;
		}
		
		use namespace potato_internal;
		/**
		 * begin冒泡 
		 */
		static public const BEGIN:String="begin";
		/**
		 * move冒泡 
		 */
		static public const MOVE:String="move";
		/**
		 * end 冒泡 
		 */
		static public const END:String="end";
		
		
		private var _touch:Touch;
		private var _type:String;
		private var _preventGestureTypes:Array=[];
		private var _recongnizedGesture:Array=[];
		
		/**
		 * 已验证的手势 
		 * @return 
		 * 
		 */
		public function get recongnizedGesture():Array
		{
			return _recongnizedGesture;
		}

		public function set recongnizedGesture(value:Array):void
		{
			_recongnizedGesture = value;
		}

		/**
		 * 阻止的手势类型 
		 * @return 
		 * 
		 */
		public function get preventGestureTypes():Array
		{
			return _preventGestureTypes;
		}

		public function set preventGestureTypes(value:Array):void
		{
			_preventGestureTypes = value;
		}

		/**
		 * 单次冒泡的类型 
		 * @return 
		 * 
		 */
		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		/**
		 * 单次冒泡的触摸对象 
		 * @return 
		 * 
		 */
		public function get touch():Touch
		{
			return _touch;
		}

		public function set touch(value:Touch):void
		{
			_touch = value;
		}
		
		public function addPreventType(types:Array):void{
			preventGestureTypes=preventGestureTypes.concat(types);
		}
		
		public function flush():void{
			for each(var gesture:Gesture in recongnizedGesture){
				gesture.dispatchEvent(new Event(gesture.state));
//				trace(gesture.state);
//				if(type==END)
//					gesture.reset();
			}
			recongnizedGesture=[];
			_preventGestureTypes=[];
			
			_touch=null;
		}
	}
}