package potato.display3d.async
{
	/**
	 * 异步处理 
	 * @author liuxin
	 * 
	 */
	public class AsyncProcessor
	{
		public function AsyncProcessor(process:AsyncHandler,callback:AsyncHandler,info:AsyncInfo=null)
		{
			this.process=process;
			this.callback=callback;
			this.info=info;
		}
		
		public var process:AsyncHandler;
		public var callback:AsyncHandler;
		public var info:AsyncInfo;

		public function dispose():void{
			process=null;
			callback=null;
		}
	}
}