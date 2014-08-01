package potato.display3d.data
{
	import flash.net.registerClassAlias;
	
	import core.display3d.Matrix3D;

	/**
	 *骨骼关节数据 
	 * @author win7
	 * 
	 */
	public class SkeletonJointData
	{
		/**父关节索引**/
		public var parentIndex:int;
		/**关节名字**/
		public var name:String;
		/**反转绑定姿势**/
		public var inverseBindPose:Matrix3D;
		
		public static function registerAlias():void
		{
			registerClassAlias("potato.mirage3d.data.SkeletonJointData", SkeletonJointData);
			registerClassAlias("core.display3d.Matrix3D",Matrix3D);
		}
	}
}