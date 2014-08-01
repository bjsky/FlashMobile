package potato.component
{
	public interface IGroupItem
	{
		
		/**
		 * 是否选中 
		 * @param value
		 * 
		 */
		function set selected(value:Boolean):void;
		function get selected():Boolean;
		
		/**
		 * 数据 
		 * @param value
		 * 
		 */
		function set data(value:Object):void;
		function get data():Object;
	}
}