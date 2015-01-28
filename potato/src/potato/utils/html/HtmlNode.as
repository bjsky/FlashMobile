package potato.utils.html
{
	import flash.utils.Dictionary;

	public class HtmlNode
	{
		public function HtmlNode()
		{
		}
		//标签名
		public var name:String;
		//属性
		public var attributes:Dictionary;
		//内容
		public var text:String;
		//子节点
		public var children:Vector.<HtmlNode>;
	}
}