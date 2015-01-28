package potato.display3d.behaviour
{
	import core.display3d.Object3D;
	import core.display3d.Vector3D;
	
	import potato.display3d.Behaviour;
	import potato.display3d.core.Time;
	import potato.display3d.data.behaviour.RotationBehaviourData;
	
	/**
	 * 旋转脚本 
	 * @author win7
	 * 
	 */
	public class RotationBehaviour extends Behaviour
	{
		public function RotationBehaviour(data:RotationBehaviourData)
		{
			super();
			m_vRotationValue=data.m_vRotationValue;
		}
		
		public var m_vRotationValue:Vector3D	= new Vector3D(0, 360, 0);
		
		override public function update():void{
			//毫秒换秒
			var deltaTime:Number=Time.deltaTime/1000;
			var parentDisplay:Object3D=parentGameObject as Object3D;
			if(parentDisplay)
			{
//				trace(m_vRotationValue.x*deltaTime,m_vRotationValue.y*deltaTime,m_vRotationValue.z*deltaTime);
				parentDisplay.rotate(new Vector3D(1,0,0),m_vRotationValue.x*deltaTime);
				parentDisplay.rotate(new Vector3D(0,1,0),m_vRotationValue.y*deltaTime);
				parentDisplay.rotate(new Vector3D(0,0,1),m_vRotationValue.z*deltaTime);
			}
		}
	}
}