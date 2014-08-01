package potato.resource
{
	import flash.utils.Dictionary;
	
	import core.display.Texture;
	import core.display.TextureData;

	/**
	 * 纹理管理器接口 
	 * @author liuxin
	 * 
	 */
	public interface ITextureManager
	{
		/**
		 * 获取纹理资源  
		 * @param atlasesMap
		 * @param name
		 * @return 
		 * 
		 */
		function getTexture(atlasesMap:Dictionary,name:String):Texture;
	}
}