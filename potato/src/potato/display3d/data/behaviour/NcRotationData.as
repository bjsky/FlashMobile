package potato.display3d.data.behaviour
{
	import core.display3d.Vector3D;
	
	import potato.display3d.data.BehaviourData;

	public class NcRotationData extends BehaviourData
	{
		public var m_fUserTag:Number;
		public var m_bWorldSpace:Boolean = false;
		public var m_vRotationValue:Vector3D = new Vector3D(0, 360, 0);
		
		public static function registerAlias():void
		{
			
		}
	}
}