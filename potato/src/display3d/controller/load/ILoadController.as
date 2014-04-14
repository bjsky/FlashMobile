package potato.display3d.controller.load
{
	import potato.display3d.resource.IResource;

	/**
	 * 加载控制器接口，只提供加载方法<br />
	 * 具体的加载策略由具体类实现，结合资源接口，针对不同的资源做不同的加载策略，如同步/异步、显示范围优先级等
	 * @author liuxin
	 * 
	 */
	public interface ILoadController
	{
		function load(resource:IResource):void;
		
		/** 同步/异步**/
		function set isSync(value:Boolean):void;
		function get isSync():Boolean;
	}
}