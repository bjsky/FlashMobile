package potato.display3d.core
{
    
    import core.display.Texture;
    import core.display.TextureData;
    import core.utils.WeakDictionary;
    
    import potato.display3d.Res3D;

	/**
	 * 纹理管理器 
	 * @author superFlash
	 * 
	 */
    public class TextureManager
    {
		public static var path:String="";
        
		private static var _defaultTexture:Texture;
		private static var dict:WeakDictionary=new WeakDictionary();
        
		public static function getTexture(name:String, isLightMap:Boolean=false):Texture
        {
            var tex:Texture=dict[name];
			var pathFile:String = "";
            if (tex)
                return tex;
            try {
				pathFile = path + Res3D.getTextureSuffix(name);
				
				tex=new Texture(TextureData.createWithFile(pathFile));
            } catch (e:Error) {
				trace(name,"not loaded!");
                tex=getDefaultTexture();
            }
			if (isLightMap)
			{
				tex.repeat = false;
				tex.mipmap=true;
			}
			else
			{
				tex.mipmap=true;
				tex.repeat=true;
			}
            dict[name]=tex;
            
            //trace(file,"loaded!");
            
            return tex;
        }
		
		
		public static function getDefaultTexture():Texture
		{
			if (!_defaultTexture)
				createDefaultTexture();
			
			return _defaultTexture;
		}
		
		private static function createDefaultTexture():void
		{
			var texData:TextureData=TextureData.createRGB(8,8,false,0);
			
			var i:uint,j:uint;
			for (i=0;i<8;i++) {
				for (j=0;j<8;j++) {
					if ((j^i)&1)
						texData.setPixel(i,j,0xff00ff);
				}
			}
			
			_defaultTexture=new Texture(texData);
			_defaultTexture.repeat=true;
		}
		
		
    }
}