package potato.component.classes
{
	import core.events.Event;
	import core.events.TouchEvent;
	
	import potato.component.Text;
	import potato.component.core.IListItem;
	import potato.component.core.IToggle;
	import potato.gesture.GestureEvent;
	import potato.gesture.TapGesture;
	
	/**
	 * 文字列表渲染器.
	 * <p>实现了列表项接口和组项目接口的文字，List组件内容的默认渲染器</p>
	 * @author liuxin
	 * 
	 */
	public class TextListItemRenderer extends Text
		implements IListItem,IToggle
	{
		public function TextListItemRenderer()
		{
			super();
			var tap:TapGesture=new TapGesture(this);
			tap.addEventListener(GestureEvent.TAP,tapHandler);
			addEventListener(TouchEvent.TOUCH_BEGIN,customHandler);
		}
		
		private function tapHandler(e:GestureEvent):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public static const CUSTOM_EVENT:String="customEvent";
		private function customHandler(e:TouchEvent):void
		{
			// TODO Auto Generated method stub
			dispatchEvent(new Event(CUSTOM_EVENT));
		}
		
		
		private var _index:int;
		private var _selected:Boolean;
		private var _toggleEnable:Boolean=false;
		protected var _data:Object;
		
		/**
		 * 项目索引 
		 * @return 
		 * 
		 */
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
		/**
		 * 是否选中 
		 * @param value
		 * 
		 */
		public function set selected(value:Boolean):void{
			_selected=value;
		}
		public function get selected():Boolean{
			return _selected;
		}
		
		/**
		 * 是否开启选中
		 * @return 
		 * 
		 */
		public function get toggleEnable():Boolean
		{
			return _toggleEnable;
		}
		
		public function set toggleEnable(value:Boolean):void
		{
			_toggleEnable = value;
		}
		
		/**
		 * 数据 
		 * @param value
		 * 
		 */
		public function set data(value:Object):void
		{
			_data=value;
			if(_data is String)
				text=String(_data);
			else if(_data is Number)
				text=String(_data);
			else if(_data.label is String)
				text=String(_data.label);
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * 标签 
		 * @return 
		 * 
		 */
		public function get label():String{
			return text;
		}
		
	}
}