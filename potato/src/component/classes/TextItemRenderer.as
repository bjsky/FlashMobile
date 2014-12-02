package potato.component.classes
{
	import potato.component.interf.IListItem;
	import potato.component.interf.IToggle;
	import potato.component.Text;
	
	/**
	 * 文字列表项.
	 * <p>实现了列表项接口和组项目接口的文字，List组件内容的默认渲染器</p>
	 * @author liuxin
	 * 
	 */
	public class TextItemRenderer extends Text
		implements IListItem,IToggle
	{
		public function TextItemRenderer()
		{
			super();
		}
		
		private var _index:int;
		private var _selected:Boolean;
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
		 * 数据 
		 * @param value
		 * 
		 */
		public function set data(value:Object):void
		{
			_data=value;
			if(_data is String)
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