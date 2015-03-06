package potato.display3d.behaviour
{
	import core.display3d.Object3D;
	import core.display3d.Quaternion;
	import core.display3d.Vector3D;
	
	import potato.display3d.behaviour.common.NcEffectBehaviour;
	import potato.display3d.data.behaviour.NcRotationData;

	public class NcRotation extends NcEffectBehaviour
	{
		public var m_bWorldSpace:Boolean = false;
		public var m_vRotationValue:Vector3D = new Vector3D(0, 360, 0);
		
		public function NcRotation(data:NcRotationData)
		{
			m_bWorldSpace = data.m_bWorldSpace;
			m_vRotationValue = data.m_vRotationValue;
		}
		
		override public function update():void
		{
			var dt:Number = GetEngineDeltaTime();
			
			var qb:Quaternion = new Quaternion();
			qb.fromEuler(container.rotationX, container.rotationY, container.rotationZ);
			var qr:Quaternion = new Quaternion();
			qr.fromEulerZXY(m_vRotationValue.x*dt, m_vRotationValue.y*dt, m_vRotationValue.z*dt);
			var vecR:Vector3D;
			
			if(m_bWorldSpace){
				var qp:Quaternion = new Quaternion();
				var tq:Quaternion = new Quaternion();
				var o:Object3D = container;
				while(o.parent){
					o = o.parent;
					tq.fromEuler(o.rotationX, o.rotationY, o.rotationZ);
					qp.multiply(tq,qp);
				}
				var _qp:Quaternion = new Quaternion(-qp.x,-qp.y,-qp.z,qp.w);
				var oq:Quaternion = new Quaternion();
				oq.multiply(oq,_qp);
				oq.multiply(oq,qr);
				oq.multiply(oq,qp);
				oq.multiply(oq,qb);
				vecR = oq.toEuler();
				container.rotationX = vecR.x;
				container.rotationY = vecR.y;
				container.rotationZ = vecR.z;
			}else{//绕父空间对应unity transform.Rotate(x,y,z,Space.Self)
				qb.multiply(qb, qr);
				vecR = qb.toEuler();
				container.rotationX = vecR.x;
				container.rotationY = vecR.y;
				container.rotationZ = vecR.z;
			}
		}
	}
}