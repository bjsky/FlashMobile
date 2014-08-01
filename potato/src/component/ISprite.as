package potato.component
{
	/**
	 * 精灵接口 
	 * @author liuxin
	 * 
	 */
	public interface ISprite
	{
		/**
		 * x
		 * @param value
		 * 
		 */
		function set x(value:Number):void;
		function get x():Number;
		
		/**
		 * y 
		 * @param value
		 * 
		 */
		function set y(value:Number):void;
		function get y():Number;
		
		
		/**
		 * 宽度
		 * @param value
		 * 
		 */
		function set width(value:Number):void;
		function get width():Number;
		
		/**
		 * 高度 
		 * @param value
		 * 
		 */
		function set height(value:Number):void;
		function get height():Number;
		
		/**
		 * scaleX
		 * @param value
		 * 
		 */
		function set scaleX(value:Number):void;
		function get scaleX():Number;
		
		/**
		 * scaleY
		 * @param value
		 * 
		 */
		function set scaleY(value:Number):void;
		function get scaleY():Number;
		
		/**
		 * 缩放 
		 * @param value
		 * 
		 */
		function set scale(value:Number):void;
		function get scale():Number
		/**
		 * 渲染组件内容 
		 * 
		 */
		function render():void;
	}
}