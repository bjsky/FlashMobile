package potato.component.core
{
	/**
	 * 支持渲染器的组件接口.
	 * <p>通过实现渲染组件接口，可以通过设置渲染器和数据源。并且在编辑器中识别为渲染的组件</p>
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