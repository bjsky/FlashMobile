package potato.display
{
	import core.display.Image;
	
	/**
	 * 文字排版，支持图文混排，字符位置索引，光标等。比textField提供更丰富的功能，当然，效率也低一点。
	 * @author liuxin
	 * 
	 */
	public class TextCompose extends Image
	{
		public function TextCompose(text:String="")
		{
			super(null);
		}
		
		/**
		 * 横排 
		 */
		public static const HORIZONTAL:String="horizontal";
		/**
		 * 竖排 
		 */
		public static const VERTICAL:String="vertical";
		
		private var _direction:String="horizontal";

		/**
		 * 排版方向 
		 * @return 
		 * 
		 */
		public function get direction():String
		{
			return _direction;
		}

		public function set direction(value:String):void
		{
			_direction = value;
		}
		
		
	}
}
import core.filters.Filter;

class composeFormat{
	public function composeFormat(){
		
	}
	// 字体名
	public var fontName:String;
	//字号
	public var fontSize:Number;
	//字体颜色
	public var fontColor:uint;
	//加粗
	public var isBold:Boolean;
	//斜体
	public var isItalic:Boolean;
	//下划线
	public var isUnderline:Boolean;
	//滤镜
	public var filter:Filter;
	//水平对齐
	public var hAlign:uint;
	//垂直对齐
	public var vAlign:uint;
}