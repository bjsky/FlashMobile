package potato.editor.layoutUI
{
	import potato.component.Bitmap;
	import potato.component.data.BitmapSkin;
	import potato.editor.layout.LayoutElement;
	
	/**
	 * 布局图像. 
	 * @author liuxin
	 * 
	 */
	public class BitmapUI extends Bitmap
		implements ILayoutUI
	{
		public function BitmapUI(skin:BitmapSkin=null, width:Number=NaN, height:Number=NaN)
		{
			_layout=new LayoutElement(this);
			super(skin, width, height);
		}
		
		protected var  _layout:LayoutElement;
		public function get layout():LayoutElement{
			return _layout;
		}
		
		
		///////////////////////////
		// layout Property
		///////////////////////////
		/**
		 * 重写宽度为布局的宽度 
		 * @param value
		 * 
		 */
		override public function set width(value:Number):void
		{
			_layout.width=value;
		}
		/**
		 * 真实的宽度由布局设置 
		 * @param value
		 * 
		 */
		public function set $width(value:Number):void{
			super.width=value;
		}
		
		override public function set height(value:Number):void
		{
			_layout.height=value;
		}
		public function set $height(value:Number):void{
			super.height=value;
		}
		
		override public function set x(_arg1:Number):void{
			_layout.x=_arg1;
		}
		public function set $x(value:Number):void{
			super.x=value;
		}
		
		override public function set y(_arg1:Number):void{
			_layout.y=_arg1;
		}
		public function set $y(value:Number):void{
			super.y=value;
		}
		
		override public function set scaleX(_arg1:Number):void{
			_layout.scaleX=_arg1;
		}
		public function set $scaleX(value:Number):void{
			super.scaleX=value;
		}
		
		override public function set scaleY(_arg1:Number):void{
			_layout.scaleY=_arg1;
		}
		public function set $scaleY(value:Number):void{
			super.scaleY=value;
		}

		public function get left():Number
		{
			return _layout.left;
		}
		
		public function set left(value:Number):void
		{
			_layout.left = value;
		}
		
		public function get right():Number
		{
			return _layout.right;
		}
		
		public function set right(value:Number):void
		{
			_layout.right = value;
		}
		
		public function get top():Number
		{
			return _layout.top;
		}
		
		public function set top(value:Number):void
		{
			_layout.top = value;
		}
		
		public function get bottom():Number
		{
			return _layout.bottom;
		}
		
		public function set bottom(value:Number):void
		{
			_layout.bottom = value;
		}
		
		public function get centerX():Number
		{
			return _layout.centerX;
		}
		
		public function set centerX(value:Number):void
		{
			_layout.centerX = value;
		}
		
		
		public function get centerY():Number
		{
			return _layout.centerY;
		}
		
		public function set centerY(value:Number):void
		{
			_layout.centerY = value;
		}
		
	}
}