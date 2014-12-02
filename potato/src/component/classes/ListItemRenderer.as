package potato.component.classes
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import potato.component.interf.IListItem;
	import potato.component.interf.IToggle;
	import potato.component.View;
	import potato.utils.ClassInfo;
	
	public class ListItemRenderer extends View
		implements IListItem, IToggle
	{
		public function ListItemRenderer()
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
			for(var str:String in _data){
				if(spriteMap[str]){
					if(ClassInfo.parse(getDefinitionByName(getQualifiedClassName(spriteMap[str]))).propArr.indexOf("text")>-1){
						spriteMap[str].text=data[str]
					}
				}
			}
			
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
			return "";
		}
	}
}