package potato.component.data
{
	import flash.net.registerClassAlias;
	
	import core.display.Texture;
	import core.display.TextureData;
	
	import potato.res.Res;

	/**
	 * 皮肤.
	 * <p>可以设置纹理名/纹理数据/纹理和九宫格字符串，自动适配参数类型</p>
	 * @author liuxin
	 * 
	 */
	public class BitmapSkin
	{
		/**
		 * 创建纹理皮肤 
		 * @param texture 纹理名/纹理数据/纹理
		 * @param grid9
		 * 
		 */
		public function BitmapSkin(texture:*=null,grid9:String="")
		{
			if(texture is String)
				this.textureName=texture as String;
			else if(texture is TextureData)
				this.textureData=texture as TextureData;
			else if(texture is Texture)
				this.textrue=texture as Texture;
			this.grid9=grid9;
			_textureValidate=false;
		}

		/**
		 * 注册别名 
		 * 
		 */
		static public function registerAlias():void{
			registerClassAlias("potato.component.data.BitmapSkin",BitmapSkin);
		}
		
		
		
		private var _textureName:String;
		private var _grid9:String;
		private var _grid9Arr:Array=[0,0,0,0];
		private var _textureData:TextureData
		private var _textrue:Texture;
		private var _textureValidate:Boolean=false;
		private var _cacheTexture:Texture;
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
			_textureValidate=false;
		}
		
		/**
		 * 纹理数据
		 * @return 
		 * 
		 */
		public function get textureData():TextureData
		{
			return  _textureData;
		}
		
		public function set textureData(value:TextureData):void
		{
			_textureData = value;
			_textureValidate=false;
		}
		
		/**
		 * 纹理 
		 * @return 
		 * 
		 */
		public function get textrue():Texture
		{
			return _textrue;
		}
		
		public function set textrue(value:Texture):void
		{
			_textrue = value;
			_textureValidate=false;
		}
		
		
		/**
		 * 九宫格字符串，格式：左,上,右,下
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
		
		
		public function getTexture():Texture{
			if(!_textureValidate){
				_textureValidate=true;
				if(_textrue)
					_cacheTexture = _textrue;
				else if(_textureData)
					_cacheTexture = new Texture(_textureData);
				else if(_textureName)
					_cacheTexture = Res.getTexture(_textureName);
				else 
					_cacheTexture = null;
			}
			return _cacheTexture;
		}
		
		public function get width():Number{
			return getTexture()?getTexture().width:0;
		}
		
		public function get height():Number{
			return getTexture()?getTexture().height:0;
		}
	}
}