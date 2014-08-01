package potato.display3d.data
{
	import flash.net.registerClassAlias;

	public class SkeletonClipSetData
	{
		/**SkeletonJointData数组**/
		public var skeletonJointDataArr:Array;
		/**skeletonClip name 数组**/
		public var clipNameArr:Array;
		/**name对应的skeletonPose数组的个数**/
		public var frameLensArr:Array;
		/**skeletonPose数组**/
		public var skeletonPoseArr:Array;
		
		public static function registerAlias():void
		{
			registerClassAlias("potato.mirage3d.data.SkeletonClipSetData", SkeletonClipSetData);
		}
	}
}