package potato.display3d.data
{
	/**
	 * 挂载 
	 * @author liuxin
	 * 
	 */
	public class ActorMountData
	{
		public function ActorMountData(boneName:String,meshName:String)
		{
			this.boneName = boneName;
			this.meshName = meshName;
		}
		
		/**
		 * 骨骼名 
		 */
		public var boneName:String;
		/**
		 * mesh名 
		 */
		public var meshName:String;
	}
}