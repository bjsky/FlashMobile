package potato.component.core
{
	/**
	 * 数据绑定接口.
	 * <p>实现数据绑定接口，可以通过赋值对象为组件赋值</p> 
	 * @author liuxin
	 * 
	 */
	public interface IDataBinding
	{
		/**
		 * 数据 
		 * @return 
		 * 
		 */
		function get dataProvider():Object;
		function set dataProvider(value:Object):void;
	}
}