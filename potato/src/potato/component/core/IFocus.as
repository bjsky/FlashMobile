package potato.component.core
{
	/**
	 * 焦点接口.
	 * <p>实现焦点接口的对象.可以接受和失去焦点</p> 
	 * @author liuxin
	 * 
	 */
	public interface IFocus
	{
		/**
		 * 获得焦点 
		 * 
		 */
		function onFocus():void;
		/**
		 * 失去焦点 
		 * 
		 */		
		function outFocus():void;
	}
}