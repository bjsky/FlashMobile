package potato.component.data
{
	import flash.net.registerClassAlias;

	/**
	 * 填充
	 * @author liuxin
	 * 
	 */
	public class Padding
	{
		public function Padding(paddingLeft:Number=0,paddingTop:Number=0,paddingRight:Number=0,paddingBottom:Number=0)
		{
			this.paddingLeft=paddingLeft;
			this.paddingRight=paddingRight;
			this.paddingTop=paddingTop;
			this.paddingBottom=paddingBottom;
		}
		/**
		 * 注册别名 
		 * 
		 */
		static public function registerAlias():void{
			registerClassAlias("potato.component.data.Padding",Padding);
		}
//		/**
//		 * 创建一个填充 
//		 * @param paddingLeft
//		 * @param paddingTop
//		 * @param paddingRight
//		 * @param paddingBottom
//		 * @return 
//		 * 
//		 */
//		static public function create(paddingLeft:Number=0,paddingTop:Number=0,paddingRight:Number=0,paddingBottom:Number=0):Padding{
//			var padding:Padding=new Padding();
//			padding.paddingLeft=paddingLeft;
//			padding.paddingRight=paddingRight;
//			padding.paddingTop=paddingTop;
//			padding.paddingBottom=paddingBottom;
//			return padding;
//		}
		
		private var _paddingLeft:Number=0;
		private var _paddingRight:Number=0;
		private var _paddingTop:Number=0;
		private var _paddingBottom:Number=0;
		
		/**
		 * 左填充 
		 * @param value
		 * 
		 */
		public function set paddingLeft(value:Number):void{
			_paddingLeft=value;
		}
		public function get paddingLeft():Number{
			return _paddingLeft;
		}
		/**
		 * 右填充 
		 * @param value
		 * 
		 */
		public function set paddingRight(value:Number):void{
			_paddingRight=value;
		}
		public function get paddingRight():Number{
			return _paddingRight;
		}
		/**
		 * 上填充 
		 * @param value
		 * 
		 */
		public function set paddingTop(value:Number):void{
			_paddingTop=value;
		}
		public function get paddingTop():Number{
			return _paddingTop;
		}
		/**
		 * 下填充 
		 * @param value
		 * 
		 */
		public function set paddingBottom(value:Number):void{
			_paddingBottom=value;
		}
		public function get paddingBottom():Number{
			return _paddingBottom;
		}
		
	}
}