package potato.component.core
{
	/**
	 * 容器接口.
	 * <p>实现容器接口，在编辑器中自动识别为容器组件</p> 
	 * @author liuxin
	 * 
	 */
	public interface IContainer
	{
		/**
		 * 测量的宽度
		 * @return 
		 * 
		 */		
		function get measureWidth():Number;
		/**
		 * 测量的高度 
		 * @return 
		 * 
		 */		
		function get measureHeight():Number;
		/**
		 * 确定的宽度 
		 * @return 
		 * 
		 */		
		function get explicitWidth():Number;
		/**
		 * 确定的高度 
		 * @return 
		 * 
		 */
		function get explicitHeight():Number;
		
	}
}