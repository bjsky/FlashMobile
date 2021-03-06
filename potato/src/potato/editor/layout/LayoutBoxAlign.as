package potato.editor.layout
{
	/**
	 * box布局对齐方式枚举.
	 * @author liuxin
	 * 
	 */
	public class LayoutBoxAlign
	{
		public function LayoutBoxAlign()
		{
		}
		/**
		 * 向上对齐,适用于verticalAlign
		 */
		static public const TOP:String="top";
		
		/**
		 * 向下对齐,适用于verticalAlign 
		 */		
		static public const BOTTOM:String="bottom";
		
		/**
		 * 向左对齐,适用于horizontalAlign 
		 */		
		static public const LEFT:String="left";
		
		/**
		 * 向右对齐,适用于horizontalAlign 
		 */		
		static public const RIGHT:String="right";
		
		/**
		 * 居中对齐,适用于verticalAlign ,horizontalAlign 
		 */		
		static public const CENTER:String="center";
		
	}
}