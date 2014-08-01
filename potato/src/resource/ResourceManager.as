package potato.resource
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import core.display.Texture;
	import core.display.TextureData;
	import core.filesystem.File;

	/**
	 * 资源管理器
	 * @author liuxin
	 * 
	 */
	public class ResourceManager
	{
		public function ResourceManager()
		{
		}
		
		static public const DEFAULT:String="default";
		/**
		 * 纹理管理器
		 */
		static public var textrueManager:ITextureManager=new LocalTextureManager();

		/**
		 * 图集字典
		 */
		static private var AtlasesResourceMap:Dictionary=new Dictionary();
		/**
		 * 添加一个图集  
		 * @param path 图集路径
		 * @param configFileName 配置文件名
		 * @param atlasesName	图集名
		 * 
		 */		
		static public function addAtlases(path:String,configFileName:String,name:String=DEFAULT):void{
			var atlasXml:XML=XML(File.read(path+configFileName));
			
			var regions:Dictionary=new Dictionary();
			var frames:Dictionary=new Dictionary();
			　for each (var subTexture:XML in atlasXml.sprite) {
				　var n:String        = subTexture.attribute("n");
				　var x:Number           = parseFloat(subTexture.attribute("x"));
				　var y:Number           = parseFloat(subTexture.attribute("y"));
				　var width:Number       = parseFloat(subTexture.attribute("w"));
				　var height:Number      = parseFloat(subTexture.attribute("h"));
				　regions[n]=new Rectangle(x,y,width,height);
				　var frameWidth:Number  = parseFloat(subTexture.attribute("oW"));
				　var frameHeight:Number = parseFloat(subTexture.attribute("oH"));
				　if (frameWidth>0 && frameHeight>0) {
					var frameX:Number  = parseFloat(subTexture.attribute("oX"));
					　var frameY:Number  = parseFloat(subTexture.attribute("oY"));
					frames[n]=new Rectangle(frameX,frameY,frameWidth,frameHeight);
				　}
			　}
			
			var textureName:String=atlasXml.attribute("imagePath");
			var texture:Texture=new Texture(TextureData.createWithFile(path+textureName))
			AtlasesResourceMap[name]=new AtlasesResource(texture,regions,frames);
		}
		
		
		/**
		 * 获取纹理 
		 * @param name	纹理名
		 * @return 
		 * 
		 */
		static public function getTextrue(name:String):Texture{
			if(textrueManager)	
				return textrueManager.getTexture(AtlasesResourceMap,name);
			else
				return null;
		}
		
	}
}