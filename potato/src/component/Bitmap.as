package potato.component
{
	import flash.geom.Rectangle;
	
	import core.display.Grid9Texture;
	import core.display.Image;
	import core.display.Texture;
	
	import potato.component.data.BitmapSkin;
	import potato.resource.ResourceManager;
	import potato.utils.DebugUtil;
	import potato.utils.Filters;
	import potato.utils.Size;
	import potato.utils.StringUtil;

	/**
	 * 图像 
	 * <br /> 组件化的图像。如果设置宽高，图像依据宽高和九宫格拉伸，否则为资源纹理的宽高。
	 * @author liuxin
	 * 
	 */
	public class Bitmap extends Image 
		implements ISprite
	{
		public function Bitmap(skin:BitmapSkin=null,width:Number=NaN,height:Number=NaN)
		{
			super(null);
			
			$skin=skin;
			$width=width;
			$height=height;
			
			render();
		}
		
		
		static private var toolBitmap:Bitmap=new Bitmap();
		
		/**
		 * 获取皮肤的默认尺寸 
		 * @param skin
		 * @return 
		 * 
		 */
		static public function getSkinSize(skin:BitmapSkin):Size{
			toolBitmap.skin=skin;
			return new Size(toolBitmap.width,toolBitmap.height);
		}
	
		//----------------------------
		//	ISprite
		//----------------------------
		protected var _width:Number;
		protected var _height:Number;
		protected var _scale:Number;
		protected var _disable:Boolean=false;
		
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
		
		
		/**
		 * 可用性 
		 * @param value
		 * 
		 */
		public function set disable(value:Boolean):void{
			_disable=value;
			this.filter=_disable?Filters.FILTER_IMG_GRAY:null;
		}
		public function get disable():Boolean{
			return _disable;
		}
		//--------------
		// properties
		//--------------
		private var _grid9Arr:Array=[0,0,0,0];
		private var _useGrid:Boolean=true;
		/**
		 * 使用网格 
		 * @return 
		 * 
		 */		
		public function get useGrid():Boolean
		{
			return _useGrid;
		}
		
		public function set useGrid(value:Boolean):void
		{
			$useGrid = value;
			render();
		}
		
		public function set $useGrid(value:Boolean):void
		{
			_useGrid = value;
		}
		
		
		private var _skin:BitmapSkin;
		
		/**
		 * 皮肤 
		 * @return 
		 * 
		 */
		public function get skin():BitmapSkin
		{
			return _skin;
		}
		
		public function set skin(value:BitmapSkin):void
		{
			$skin = value;
			render();
		}
		
		public function set $skin(value:BitmapSkin):void{
			_skin = value;
		}
		
		
		//------------------------
		//	override
		//------------------------
		public function render():void{
			DebugUtil.traceProcessCurrent("render",this);
			texture=null;
			
			var tex:Texture;
			if(_skin){
				if(_skin.textureData)
					tex=new Texture(_skin.textureData);
				else if(_skin.textureName)
					tex=ResourceManager.getTextrue(_skin.textureName);
			}
			if(!tex)
				return;
			//rectangle
			var rect:Rectangle;
			
			//size
			if(isNaN(width))
				$width=tex.width;
			if(isNaN(height))
				$height=tex.height;

			if(useGrid){
				if(_skin.grid9){
					_grid9Arr=StringUtil.fillArray(_grid9Arr,_skin.grid9,Number);
					rect=new Rectangle(_grid9Arr[0],_grid9Arr[1],tex.width-_grid9Arr[0]-_grid9Arr[2],tex.height-_grid9Arr[1]-_grid9Arr[3]);
				}else
					rect=new Rectangle(0,0,tex.width,tex.height);
				
				
				var grid9Tex:Grid9Texture=new Grid9Texture(tex,rect,width,height);
				texture=grid9Tex;
			}else{
				texture=tex;
			}
		}
		override public function dispose():void{
			if(texture){
				texture=null;
			}
		}
	}
}