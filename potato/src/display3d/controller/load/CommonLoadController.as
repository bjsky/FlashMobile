package potato.display3d.controller.load
{
	import potato.display3d.resource.IResource;

	/**
	 * 常用的加载控制器
	 * @author win7
	 * 
	 */
	public class CommonLoadController extends AbstractLoadController
	{
		
		/**
		 *  
		 * @param isSync 同步true/异步false
		 * 
		 */
		public function CommonLoadController(isSync:Boolean=true)
		{
			super(isSync)	
		}
		
		override public function load(resource:IResource):void
		{
			if(isSync){
				//同步无策略直接加载
				resource.load();
			}else{
				//异步加载处理..
			}
		}
	}
}