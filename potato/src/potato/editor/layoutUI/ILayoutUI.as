package potato.editor.layoutUI
{
	import potato.editor.layout.LayoutElement;

	/**
	 * 布局ui的接口.
	 * @author liuxin
	 * 
	 */
	public interface ILayoutUI
	{
		/**
		 * 布局元素
		 * @return 
		 * 
		 */
		function get layout():LayoutElement;
		
		function set $width(value:Number):void;
		
		function set $height(value:Number):void;
		
		function set $x(value:Number):void;
		
		function set $y(value:Number):void;
		
		function set $scaleX(value:Number):void;
		
		function set $scaleY(value:Number):void;
	}
}