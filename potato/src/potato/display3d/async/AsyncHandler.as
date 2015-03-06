package potato.display3d.async
{
	public class AsyncHandler
	{
		public function AsyncHandler(func:Function,args:Array=null)
		{
			this.func=func;
			this.args=args;
		}
		public var func:Function;
		public var args:Array;
		/**
		 * 执行 
		 * 
		 */
		public function excute():void{
			func.apply(null,args);
		}
		
		/**
		 * 执行参数 
		 * @param thisargs
		 * 
		 */
		public function excuteWith(thisargs:Array):void{
			if (thisargs == null) {
				return excute();
			}
			if (func != null) {
				func.apply(null, args ? args.concat(thisargs) : thisargs);
			}
		}
	}
}