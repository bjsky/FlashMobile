package potato.component.interf
{
	/**
	 * 渲染组件接口.
	 * <p>通过实现渲染组件接口，可以通过设置渲染器和数据源，实现内容渲染功能。并且在编辑器中自动识别为支持渲染的组件</p>
	 * @author liuxin
	 * 
	 */
	public interface IRenderer
	{
		/**
		 * 数据源 
		 * @param value
		 * 
		 */
		function set dataSource(value:Object):void;
		function get dataSource():Object;
		
		/**
		 * 渲染器 
		 * @param value
		 * 
		 */
		function set itemRender(value:*):void;
		function get itemRender():*;
	}
}