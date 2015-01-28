package potato.display3d.data.behaviour
{
	import core.display3d.Vector3D;
	
	import potato.display3d.data.BehaviourData;
	
	public class RotationBehaviourData extends BehaviourData
	{
		public function RotationBehaviourData(vRotationValue:Vector3D)
		{
			super();
			m_vRotationValue = vRotationValue;
		}
		
		public var m_vRotationValue:Vector3D	= new Vector3D(0, 360, 0);
		
	}
}