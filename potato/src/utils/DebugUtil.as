package potato.utils
{
	import flash.utils.getQualifiedClassName;
	
	import core.system.System;

	public class DebugUtil
	{
		public function DebugUtil()
		{
		}
		static public var allowTrace:Boolean=true;
		static public var validProcessKeywords:Array=[];
		static public var validObjectKeywords:Array=[];
		
		static public function traceProcessCurrent(process:String,obj:Object=null):void{
			var clsName:String=getQualifiedClassName(obj);
			if(ifShow(process,validProcessKeywords) && ifShow(clsName,validObjectKeywords)){
				if(obj)
					trace(process+"["+clsName+"]"+"");//StringUtil.getMemoryName(obj));
				else 
					trace(process);
			}
		}
		
		static public function traceNanosecondTime(process:String,startTime:Number=0):void{
			if(ifShow(process,validProcessKeywords))
				trace(process+"NanosecondTime:"+(System.getNanosecondTimer()-startTime));
		}
		
		static private function ifShow(keyword:String,arr:Array):Boolean{
			if(!allowTrace)
				return false;
			else{
				if(arr.length==0)
					return true;
				for each(var str:String in arr){
					if(keyword.indexOf(str)>-1)
						return true;
				}
				return false;
			
			}
		}
	}
}