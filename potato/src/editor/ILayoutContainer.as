package potato.editor
{
	import potato.component.ISprite;
	import potato.editor.layout.LayoutElement;

	/**
	 * 容器接口 
	 * @author liuxin
	 * 
	 */
	public interface ILayoutContainer
	{
		/**
		 * 视图的布局 
		 * @param value
		 * 
		 */
		function set layout(value:LayoutElement):void;
		function get layout():LayoutElement;
		
		/**
		 * 布局父 
		 * @param value
		 * 
		 */		
		function set layoutParent(value:ILayoutContainer):void;
		function get layoutParent():ILayoutContainer;
		/**
		 * 是否包含在上级布局中 
		 * @param value
		 * 
		 */		
		function set includeinLayout(value:Boolean):void;
		function get includeinLayout():Boolean;
		
		/**
		 * 是否为根布局（根布局负责刷新） 
		 * @param value
		 * 
		 */
		function set isRootLayout(value:Boolean):void;
		function get isRootLayout():Boolean;
		/**
		 * 附加子项的布局 （创建级联布局）
		 * @param iview
		 * 
		 */		
		function attachChildLayout(value:ISprite):void;
	}
}