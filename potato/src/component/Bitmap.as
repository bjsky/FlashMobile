package potato.component
{
	import flash.geom.Rectangle;
	
	import core.display.Grid9Texture;
	import core.display.Image;
	import core.display.Texture;
	import core.display.TextureData;
	
	/**
	 * 图像组件
	 * @author liuxin
	 * 
	 */
	public class Bitmap extends UIComponent
	{
		public function Bitmap(textureData:TextureData=null)
		{
			super();
			
			//图像
			_img=new Image(null);
			addChild(_img);
			
			if(textureData)
				texture=new Texture(textureData);
		}
		
		/** 图片的源**/
		private var _textureData:TextureData;
		/** 纹理**/
		private var _texture:Texture;
		private var _textureChanged:Boolean;
		
		private var _img:Image;
		
		/** 纹理**/
		public function set texture(value:Texture):void{
			_texture=value;
			_textureChanged=true;
			
			invalidateDisplayList();
		}
		public function get texture():Texture{
			return _texture;
		}
		
		/** 纹理数据**/
		public function set textureData(value:TextureData):void{
			_textureData=value;
			if(textureData)
				texture=new Texture(textureData);
			
			invalidateDisplayList();
		}
		public function get textureData():TextureData{
			return _textureData;
		}
		
		/** 重写图片的默认大小**/
		override protected function measure():void{
			super.measure();
			_measureMinWidth=_texture.width;
			_measureMinHeight=_texture.height;
		}
		
		/** 更新图片显示列表**/
		override protected function updateDisplayList():void{
			super.updateDisplayList();
			if(_textureChanged){
				_textureChanged=false;
				
				var _grid9:Grid9Texture=new Grid9Texture(_texture,new Rectangle(0,0,_texture.width,_texture.height),width,height);
				_img.texture=_grid9;
			}
		}
		
		override public function dispose():void{
			super.dispose();
			_img.texture=null;
			_img.dispose();
			this.removeChild(_img);
		}
	}
}