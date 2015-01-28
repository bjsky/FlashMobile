package potato.gesture
{
	import flash.geom.Point;
	
	import core.display.DisplayObject;
	
	import potato.potato_internal;

	/**
	 * 触摸点. 
	 * <p>封装一次触摸的所有数据</p>
	 * @author liuxin
	 * 
	 */
	public class Touch
	{
		public function Touch(id:int=0)
		{
			this._id=id;
		}
		use namespace potato_internal;
		
		private var _guestureTarget:DisplayObject;
		private var _target:DisplayObject;
		private var _currentTarget:DisplayObject;
		private var _id:int;
		private var _beginTime:Number;
		private var _beginLocation:Point;
		private var _time:Number;
		private var _location:Point;
		private var _previousLocation:Point;

		
		/**
		 * 开始位置 
		 * @return 
		 * 
		 */
		public function get beginLocation():Point
		{
			return _beginLocation;
		}

		/**
		 * 当前位置 
		 * @return 
		 * 
		 */
		public function get location():Point
		{
			return _location;
		}
		
		/**
		 * 上次位置 
		 * @return 
		 * 
		 */
		public function get previousLocation():Point
		{
			return _previousLocation;
		}
		
		/**
		 * 开始时间 
		 * @return 
		 * 
		 */
		public function get beginTime():Number
		{
			return _beginTime;
		}

		/**
		 * 当前时间 
		 * @return 
		 * 
		 */
		public function get time():Number
		{
			return _time;
		}
		
		
		/**
		 * 触摸唯一标示符 
		 * @return 
		 * 
		 */
		public function get id():int
		{
			return _id;
		}
		
		/**
		 * 触摸的手势对象
		 * @return 
		 * 
		 */		
		public function get guestureTarget():DisplayObject
		{
			return _guestureTarget;
		}
		
		public function set guestureTarget(value:DisplayObject):void
		{
			_guestureTarget = value;
		}

		/**
		 * 触摸开始的显示对象
		 * @return 
		 * 
		 */
		public function get target():DisplayObject
		{
			return _target;
		}

		public function set target(value:DisplayObject):void
		{
			_target = value;
		}
		
		/**
		 * 触摸的当前显示对象 
		 * @return 
		 * 
		 */
		public function get currentTarget():DisplayObject
		{
			return _currentTarget;
		}
		
		public function set currentTarget(value:DisplayObject):void
		{
			_currentTarget = value;
		}
		
		/**
		 * 设置初始位置 
		 * @param x
		 * @param y
		 * @param time
		 * 
		 */
		potato_internal function setLocation(x:Number, y:Number, time:uint,curTarget:DisplayObject):void
		{
			_location = new Point(x, y);
			_beginLocation = _location.clone();
			_previousLocation = _location.clone();
			_currentTarget=curTarget;
			
			_time = time;
			_beginTime = time;
		}
		
		/**
		 * 更新位置 
		 * @param x
		 * @param y
		 * @param time
		 * @return 
		 * 
		 */
		potato_internal function updateLocation(x:Number, y:Number, time:uint,curTarget:DisplayObject):void
		{
			if (_location)
			{
				_previousLocation.x = _location.x;
				_previousLocation.y = _location.y;
				_location.x = x;
				_location.y = y;
				_currentTarget=curTarget;
				
				_time = time;
			}
			else
			{
				setLocation(x, y, time,target);
			}
		}
		
		/**
		 * 触摸开始的位置偏移 
		 * @return 
		 * 
		 */
		public function get locationOffset():Point
		{
			return _location.subtract(_beginLocation);
		}
		
		/**
		 * 触摸开始的持续时间
		 * @return 
		 * 
		 */
		public function get timeDuring():uint{
			return _time-_beginTime;
		}
		
	}
}