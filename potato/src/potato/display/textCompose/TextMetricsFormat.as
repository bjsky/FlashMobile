package potato.display.textCompose
{
	public class TextMetricsFormat
	{
		public function TextMetricsFormat(fName:String="Verdana",fontSize:Number=12,fontColor:uint=0x0
										  ,isBold:Boolean=false,isItalic:Boolean=false,isUnderline:Boolean=false){
			this.fontName=fName;
			this.fontSize=fontSize;
			this.fontColor=fontColor;
			this.isBold=isBold;
			this.isItalic=isItalic;
			this.isUnderline=isUnderline;
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
	}
}