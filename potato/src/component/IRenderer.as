package potato.component
{
	/**
	 * 子项渲染接口 
	 * @author liuxin
	 * 
	 */
	public interface IRenderer
	{
		/**
		 * 渲染器 
		 * @param value
		 * 
		 */
		function set itemRender(value:Class):void;
		function get itemRender():Class;
	}
}