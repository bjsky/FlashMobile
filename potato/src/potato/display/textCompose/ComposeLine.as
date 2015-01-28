package potato.display.textCompose
{
	public class ComposeLine
	{
		public function composeLine():void{
			
		}
		//ascent
		public var ascent:Number=0;
		//descent
		public var descent:Number=0
		//行距
		public var leading:Number=2;
		//行的起始位置
		public var x:Number=0;
		//度量数
		public var numMetrics:Number=0;
		
		public var y:Number=0;
		
		public function get lineHeight():Number{
			return height+leading;
		}
		
		public var height:Number=0;
		
		public var width:Number=0;
	}
}