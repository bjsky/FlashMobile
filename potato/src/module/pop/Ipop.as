package potato.module.pop
{
	import core.display.DisplayObjectContainer;

	public interface Ipop
	{
		/**
		 * 打开 
		 */
		function open(parent:DisplayObjectContainer,modal:Boolean=false):void;
		
		/**
		 * 关闭 
		 * 
		 */
		function close():void;
		
		/**
		 * 是否弹出 
		 * @return 
		 * 
		 */		
		function get isPop():Boolean;
		function set isPop(value:Boolean):void;
		/**
		 * 是否可拖动 
		 * @return 
		 * 
		 */		
		function get dragEnable():Boolean;
		function set dragEnable(value:Boolean):void; 
	}
}