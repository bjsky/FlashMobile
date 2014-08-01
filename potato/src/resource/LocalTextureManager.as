package potato.resource
{
	import flash.utils.Dictionary;
	
	import core.display.SubTexture;
	import core.display.Texture;	
	/**
	 * 本地纹理管理器 
	 * @author liuxin
	 * 
	 */
	public class LocalTextureManager implements ITextureManager
	{
		public function LocalTextureManager()
		{
		}
		/**
		 *  分隔符
		 */		
		static public var separator:String="::";
		
		public function getTexture(atlasesMap:Dictionary,name:String):Texture
		{
			var atlasesName:String;
			var textureName:String;
			var arr:Array=name.split(separator);
			if(arr.length>1){
				atlasesName=arr[0];
				textureName=arr[1];
			}else{
				atlasesName=ResourceManager.DEFAULT;
				textureName=arr[0];
			}
			
			var atlasesResource:AtlasesResource=atlasesMap[atlasesName];
			if(atlasesResource){
				if(atlasesResource.regions[textureName]){
					var subtexTure:SubTexture = new SubTexture(atlasesResource.texture,atlasesResource.regions[textureName],atlasesResource.frames[textureName]);
					return 	subtexTure;
				}else
					return null;
			}else
				return null;
		}
	}

}