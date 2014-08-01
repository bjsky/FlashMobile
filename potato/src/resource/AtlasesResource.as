package potato.resource
{
	import flash.utils.Dictionary;
	
	import core.display.Texture;

	/**
	 * 图集资源 
	 * @author liuxin
	 * 
	 */
	public class AtlasesResource
	{
		public function AtlasesResource(texture:Texture,regions:Dictionary,frames:Dictionary=null)
		{
			this.texture=texture;
			this.regions=regions;
			this.frames=frames;
		}
		
		public var texture:Texture;
		public var regions:Dictionary;
		public var frames:Dictionary;
	}
}