package potato.display3d.controller.load
{
	import potato.display3d.resource.IResource;

	/** 常用的加载控制器
	 *  @author:liuxin 
	 *  @date:2014.3.27
	 * **/
	public class CommonLoadController extends AbstractLoadController
	{
		
		/**
		 * 
		 * @param isAsyn 同步：true/异步false
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