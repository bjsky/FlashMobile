package potato.component
{
	import core.display.DisplayObjectContainer;
	
	import potato.event.UIEvent;
	
	/**
	 * 空容器 
	 * @author liuxin
	 * 
	 */
	public class Container extends DisplayObjectContainer
		implements IContainer
	{
		public function Container(width:Number=NaN,height:Number=NaN)
		{
			super();
			this.$width=width;
			this.$height=height;
			render();
		}
		
		//----------------------------
		//	ISprite
		//----------------------------
		protected var _width:Number;
		protected var _height:Number;
		protected var _scale:Number;
		
		/**
		 * 宽度
		 * @param value
		 * 
		 */
		public function set width(value:Number):void{
			$width=value;
			render();
		}
		override public function get width():Number{
			return _width;
		}
		public function set $width(value:Number):void{
			_width=value;
		}
		/**
		 * 高度 
		 * @param value
		 * 
		 */
		public function set height(value:Number):void{
			$height=value;
			render();
		}
		override public function get height():Number{
			return _height;
		}
		public function set $height(value:Number):void{
			_height=value;
		}
		/**
		 * 缩放 
		 * @param value
		 * 
		 */
		public function set scale(value:Number):void{
			_scale=value;
			scaleX=scaleY=_scale;
		}
		public function get scale():Number{
			return _scale;
		}
		
		
		public function render():void{
			
			dispatchEvent(new UIEvent(UIEvent.RENDER));
		}
	}
}