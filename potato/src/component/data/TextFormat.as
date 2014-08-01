package potato.component.data
{
	import flash.net.registerClassAlias;
	
	import core.filters.Filter;
	import core.text.TextField;

	/**
	 * 文本样式 
	 * @author liuxin
	 * 
	 */
	public class TextFormat
	{
		public function TextFormat(font:String="",size:Number=12,color:uint=0x0
										  ,hAlign:uint=TextField.ALIGN_CENTER,vAlign:uint=TextField.ALIGN_CENTER,filter:Filter=null)
		{
			if(!font)
				this.font="Verdana";
			else
				this.font=font;
			this.size=size;
			this.color=color;
			this.hAlign=hAlign;
			this.vAlign=vAlign;
			this.filter=filter;
		}
		/**
		 * 注册别名 
		 * 
		 */
		static public function registerAlias():void{
			registerClassAlias("potato.component.data.TextFormat",TextFormat);
		}
//		/**
//		 * 创建一个文本样式 
//		 * @param font	字体
//		 * @param size	字号
//		 * @param color	颜色
//		 * @param filter	滤镜
//		 * @return 
//		 * 
//		 */
//		static public function create(font:String="Verdana",size:Number=12,color:uint=0x0
//									  ,hAlign:uint=TextField.ALIGN_CENTER,vAlign:uint=TextField.ALIGN_CENTER,filter:Filter=null):TextFormat{
//			var format:TextFormat=new TextFormat();
//			format.font=font;
//			format.size=size;
//			format.color=color;
//			format.hAlign=hAlign;
//			format.vAlign=vAlign;
//			format.filter=filter;
//			return format;
//		}
		
		private var _font:String;
		private var _size:Number;
		private var _color:uint;
		private var _filter:Filter;
		private var _hAlign:uint;
		private var _vAlign:uint;
		
		/**
		 * 文字 
		 * @param value
		 * 
		 */
		public function set font(value:String):void{
			_font=value;
		}
		public function get font():String{
			return _font;
		}
		
		/**
		 * 字号 
		 * @param value
		 * 
		 */
		public function set size(value:Number):void{
			_size=value;
		}
		public function get size():Number{
			return _size;
		}
		
		/**
		 * 颜色 
		 * @param value
		 * 
		 */
		public function set color(value:uint):void{
			_color=value;
		}
		public function get color():uint{
			return _color;
		}
		
		/**
		 * 滤镜 
		 * @param value
		 * 
		 */
		public function set filter(value:Filter):void{
			_filter=value;
		}
		public function get filter():Filter{
			return _filter;
		}
		
		/**
		 * 文字在显示区域中的水平对齐方式 
		 * @param value
		 * 
		 */
		public function set hAlign(value:uint):void{
			_hAlign=value;
		}
		public function get hAlign():uint{
			return _hAlign;
		}
		
		/**
		 *  文字在显示区域中的垂直对齐方式  
		 * @param value
		 * 
		 */
		public function set vAlign(value:uint):void{
			_vAlign=value;
		}
		public function get vAlign():uint{
			return _vAlign;
		}
		
		
		/**
		 * 应用文字样式 
		 * @param field
		 * 
		 */
		public function apply(field:TextField):void{
			field.fontName=font;
			field.fontSize=size;
			field.textColor=color;
			field.filter=filter;
			field.hAlign=hAlign;
			field.vAlign=vAlign;
		}
	}
}