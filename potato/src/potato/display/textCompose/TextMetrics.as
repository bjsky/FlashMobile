package potato.display.textCompose
{
	import core.text.CharMetrics;

	/**
	 * 文本度量. 
	 * @author liuxin
	 * 
	 */
	public class TextMetrics
	{
		public function TextMetrics()
		{
		}
		//符号
		public var symbol:String;
		//字符
		public var char:CharMetrics;
		//x
		public var x:Number;
		//y
		public var y:Number;
		//宽度
		public var width:Number=0;
		//高度
		public var height:Number=0;
		//样式
		public var format:TextMetricsFormat;
		//是否图片
		public var isImg:Boolean=false;
	}
}