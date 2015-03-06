package potato.display3d.data
{
	/**
	 * 角色数据 
	 * @author liuxin
	 * 
	 */
	public class ActorData
	{
		public function ActorData()
		{
		}
		
		/**
		 * 蒙皮名 
		 */
		public var mainSkinName:String;
		/**
		 * 循环的骨骼动画名 
		 */
		public var loopClipNames:Array;
		
		/**
		 * 挂载物 
		 */
		public var mounts:Vector.<ActorMountData> = new Vector.<ActorMountData>();
		
		/**
		 * 默认动作 
		 */		
		public var defaultClipName:String;
	}
}