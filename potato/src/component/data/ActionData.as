package potato.component.data
{
	import flash.net.registerClassAlias;

	public class ActionData extends Object
	{
		public function ActionData()
		{
		}

		/**
		 * 注册别名 
		 * 
		 */
		static public function registerAlias():void{
			registerClassAlias("potato.component.data.ActionData",ActionData);
		}
		
		
		private var _gestureName:String="";
		private var _eventName:String="";
		private var _typeName:String="";
		private var _functionName:String="";
		private var _argumentsArr:Array=[];

		/**
		 * 手势名 
		 * @return 
		 * 
		 */
		public function get gestureName():String
		{
			return _gestureName;
		}

		public function set gestureName(value:String):void
		{
			_gestureName = value;
		}

		/**
		 * 事件类型名 
		 * @return 
		 * 
		 */
		public function get typeName():String
		{
			return _typeName;
		}

		public function set typeName(value:String):void
		{
			_typeName = value;
		}

		/**
		 * 事件名 
		 * @return 
		 * 
		 */
		public function get eventName():String
		{
			return _eventName;
		}

		public function set eventName(value:String):void
		{
			_eventName = value;
		}

		/**
		 * 参数列表 
		 * @return 
		 * 
		 */
		public function get argumentsArr():Array
		{
			return _argumentsArr;
		}

		public function set argumentsArr(value:Array):void
		{
			_argumentsArr = value;
		}

		
		/**
		 * 方法名 
		 * @return 
		 * 
		 */
		public function get functionName():String
		{
			return _functionName;
		}
		
		public function set functionName(value:String):void
		{
			_functionName = value;
		}
		
		
	}
}