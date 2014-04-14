package potato.display3d.controller.load
{
	import potato.display3d.resource.IResource;
	
	/**
	 * 抽象场景加载
	 * @author liuxin
	 * 
	 */
	public class AbstractLoadController implements ILoadController
	{
		public function AbstractLoadController(isSync:Boolean=true)
		{
			_isSynchronize=isSync;
		}
		protected var _isSynchronize:Boolean;
		
		public function get isSync():Boolean
		{
			return _isSynchronize;
		}
		
		public function set isSync(value:Boolean):void
		{
			_isSynchronize=value;
		}
		
		public function load(resource:IResource):void
		{
		}
	}
}