package potato.component.core
{
	
	/**
	 * 精灵接口.
	 * <p>定义精灵的基本属性。在编辑器中识别为组件</p>
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
		function get scale():Number;
			
		/**
		 * 渲染类型
		 * @param value
		 * 
		 */		
		function set renderType(value:uint):void;
		function get renderType():uint;
		
		/**
		 * 组件失效 
		 * @param method 处理属性失效的方法
		 * @param args 处理属性失效的参数
		 * 
		 */		
		function invalidate(method:Function, args:Array = null):void;
		
		/**
		 * 验证组件
		 * 
		 */		
		function validate():void;
	}
}