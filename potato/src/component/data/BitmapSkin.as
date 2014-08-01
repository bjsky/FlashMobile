package potato.component.data
{
	import flash.net.registerClassAlias;
	
	import core.display.TextureData;

	public class BitmapSkin
	{
		public function BitmapSkin(textureData:TextureData=null,textureName:String="",grid9:String="")
		{
			this.textureData=textureData;
			this.textureName=textureName;
			this.grid9=grid9;
		}

		/**
		 * 注册别名 
		 * 
		 */
		static public function registerAlias():void{
			registerClassAlias("potato.component.data.BitmapSkin",BitmapSkin);
		}
		
//		/**
//		 * 创建皮肤 
//		 * @param texture
//		 * @param grid9
//		 * @return 
//		 * 
//		 */
//		static public function create(texture:Texture,grid9:String=""):BitmapSkin{
//			var skin:BitmapSkin=new BitmapSkin();
//			skin.texture=texture;
//			skin.grid9=grid9;
//			return skin;
//		}
//		
//		/**
//		 * 从纹理名创建皮肤 
//		 * @param textureName
//		 * @param grid9
//		 * @return 
//		 * 
//		 */
//		static public function createWithName(textureName:String,grid9:String=""):BitmapSkin{
//			var skin:BitmapSkin=new BitmapSkin();
//			skin.textureName=textureName;
//			skin.grid9=grid9;
//			return skin;
//		}
		
		private var _textureName:String;
		private var _grid9:String;
		private var _textureData:TextureData
		
		/**
		 * textureData 
		 * @return 
		 * 
		 */
		public function get textureData():TextureData
		{
			return _textureData;
		}
		
		public function set textureData(value:TextureData):void
		{
			_textureData = value;
		}
		

		/**
		 * grid9 
		 * @return 
		 * 
		 */
		public function get grid9():String
		{
			return _grid9;
		}

		public function set grid9(value:String):void
		{
			_grid9 = value;
		}

		/**
		 * 纹理名 
		 * @return 
		 * 
		 */
		public function get textureName():String
		{
			return _textureName;
		}

		public function set textureName(value:String):void
		{
			_textureName = value;
		}

	}
}