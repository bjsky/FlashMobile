package potato.display3d.async
{
	/**
	 * 异步控制器 ，可以根据info处理异步加载策略
	 * @author liuxin
	 * 
	 */
	public class AsyncController
	{
		public function AsyncController()
		{
		}
		
		private var _doing:Boolean=false;
		
		private var _processors:Vector.<AsyncProcessor>=new Vector.<AsyncProcessor>();
		
		private var _processor:AsyncProcessor;
		/**
		 * 当前的处理 
		 * @return 
		 * 
		 */		
		public function get current():AsyncProcessor{
			return _processor;
		}
		/**
		 * 添加异步过程 
		 * @param processor
		 * 
		 */
		public function addProcessor(processor:AsyncProcessor):void{
			_processors.push(processor);
			if(!_doing)
				next();
		}
		
		public function complete(args:Array):void{
			if(_processor){
				_processor.callback.excuteWith(args);
				_processor.dispose();
				_processor=null;
				
				_doing=false;
				next();
			}
		}
		
		private function next():void{
			trace(_processors.length)
			
			if(_processors.length>0){
				//顺序加载
				_processor=_processors.shift();
				_doing=true;
				if(_processors.length==0)
					trace("__")
				_processor.process.excute();
			}
		}
	}
}