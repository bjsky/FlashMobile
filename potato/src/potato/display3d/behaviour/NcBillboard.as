package potato.display3d.behaviour
{
	import core.display3d.Camera3D;
	import core.display3d.Matrix3D;
	import core.display3d.Object3D;
	import core.display3d.Quaternion;
	import core.display3d.Vector3D;
	
	import potato.display3d.behaviour.common.NcEffectBehaviour;
	import potato.display3d.data.behaviour.NcBillboardData;

	public class NcBillboard extends NcEffectBehaviour
	{
		public static const AXIS_TYPE_AXIS_FORWARD:int = 0;	//AXIS_FORWARD
		public static const AXIS_TYPE_AXIS_BACK:int = 1;	//AXIS_BACK
		public static const AXIS_TYPE_AXIS_RIGHT:int = 2;	//AXIS_RIGHT
		public static const AXIS_TYPE_AXIS_LEFT:int = 3;	//AXIS_LEFT
		public static const AXIS_TYPE_AXIS_UP:int = 4;		//AXIS_UP
		public static const AXIS_TYPE_AXIS_DOWN:int = 5;	//AXIS_DOWN
		
		public static const ROTATION_NONE:int = 0;	//NONE
		public static const ROTATION_RND:int = 1;	//RND
		public static const ROTATION_ROTATE:int = 2;//NONE
		
		
		private var _cam:Camera3D=null;
		
		private var m_bFixedObjectUp:Boolean;
		private var m_bCameraLookAt:Boolean;
		private var m_bFixedStand:Boolean;
		private var m_RatationMode:int = 0;//ROTATION_NONE | ROTATION_RND | ROTATION_ROTATE
		private var m_RatationAxis:int = 0;//0:x,1:y,2:z
		private var m_FrontAxis:int;
		private var m_fRotationValue:Number=0;
		
		protected var m_fRndValue:Number;
		protected var m_fTotalRotationValue:Number;
		
		public function NcBillboard(cam:Camera3D, data:NcBillboardData)
		{
			_cam = cam;
			
			var q:Quaternion = new Quaternion(-0.1851908,0.02122085,-0.0040003,-0.9824653);
			var vec:Vector3D = q.toEuler();
			_cam.rotationX = vec.x;
			_cam.rotationY = vec.y;
			_cam.rotationZ = vec.z;
			_cam.x = 1.602507;
			_cam.y = 2.656672;
			_cam.z = -10.56599;
			
			m_fUserTag = data.fUserTag;
			m_bFixedObjectUp = data.bFixedObjectUp;
			m_bCameraLookAt = data.bCameraLookAt;
			m_bFixedStand = data.bFixedStand;
			m_RatationMode = data.ratationMode;
			m_RatationAxis = data.ratationAxis;
			m_FrontAxis = data.FrontAxis;
			m_fRotationValue = data.fRotationValue;
		}
		
		override public function update():void
		{
			if(!_cam)
				return;
			var vecUp:Vector3D;
			var matInworld:Matrix3D = getMatInWorld();
			
			if(m_bFixedObjectUp){
				var tv:Vector3D = matInworld.decompose(2)[1];
				var qw:Quaternion = new Quaternion(tv.x,tv.y,tv.z,tv.w);
				vecUp = qw.rotatePoint(new Vector3D(0,1,0));
			}else{
				var camR:Quaternion = new Quaternion();
				camR.fromEuler(_cam.rotationX, _cam.rotationY,_cam.rotationZ);
				vecUp = camR.rotatePoint(new Vector3D(0,1,0));
			}
			
			trace("vecup", vecUp.x,vecUp.y,vecUp.z);
			var obj:Object3D = container;
			if(m_bCameraLookAt){
				obj.lookAt(new Vector3D(_cam.x, _cam.y, _cam.z), vecUp);
			}else{
				var camR:Quaternion = new Quaternion();
				camR.fromEuler(_cam.rotationX, _cam.rotationY,_cam.rotationZ);
				var cam_pos:Vector3D = camR.rotatePoint(new Vector3D(0,0,-1));
				trace(cam_pos.x,cam_pos.y,cam_pos.z);
				
				var pos:Vector3D = matInworld.decompose()[0];
				trace(pos.x,pos.y,pos.z);
				pos.add(pos, cam_pos);
				trace(pos.x,pos.y,pos.z);
				
				var tm:Matrix3D = new Matrix3D();
				tm.translate(pos.x,pos.y,pos.z);
				var tm2:Matrix3D = getMatInWorld(true).clone();
				tm2.invert();
				tm.concat(tm2);
				pos = tm.decompose()[0];
				
				obj.lookAt(pos, vecUp);
			}
			var tq:Quaternion = new Quaternion();
			tq.fromEuler(obj.rotationX,obj.rotationY,obj.rotationZ);
			trace("lookat",tq.x,tq.y,tq.z,tq.w);
			
			return;
			
			switch(m_FrontAxis){
				case AXIS_TYPE_AXIS_FORWARD:	break;
				case AXIS_TYPE_AXIS_BACK:		setTransform(rotateWorld(obj.transform, new Vector3D(0,1,0), 180));	break;
				case AXIS_TYPE_AXIS_RIGHT:		setTransform(rotateWorld(obj.transform, new Vector3D(0,1,0), 270));	break;
				case AXIS_TYPE_AXIS_LEFT:		setTransform(rotateWorld(obj.transform, new Vector3D(0,1,0), 90));	break;
				case AXIS_TYPE_AXIS_UP:			setTransform(rotateWorld(obj.transform, new Vector3D(1,0,0), 90));	break;
				case AXIS_TYPE_AXIS_DOWN:		setTransform(rotateWorld(obj.transform, new Vector3D(1,0,0), 270));	break;
			}
			if(m_bFixedStand){
				var qy:Quaternion = new Quaternion();
				qy.fromAxisDegree(new Vector3D(0,1,0),obj.rotationY);
				var qz:Quaternion = new Quaternion();
				qz.fromAxisDegree(new Vector3D(0,0,1),obj.rotationZ);
				qy.multiply(qy,qz);
				var rv:Vector3D = qy.toMatrix3D().decompose()[1];
				obj.rotationX = rv.x;
				obj.rotationY = rv.y;
				obj.rotationZ = rv.z;
			}
			if(m_RatationMode == ROTATION_RND){
				if(m_RatationAxis == 0)//x
					rotateOneEular(obj.transform, m_fRndValue);
				else if(m_RatationAxis == 1)//y
					rotateOneEular(obj.transform, 0, m_fRndValue);
				else
					rotateOneEular(obj.transform, 0, 0, m_fRndValue);
			}
			if(m_RatationMode == ROTATION_ROTATE){
				var fRotValue:Number = m_fTotalRotationValue + GetEngineDeltaTime() * m_fRotationValue;
				if(m_RatationAxis == 0)//x
					rotateOneEular(obj.transform, fRotValue);
				else if(m_RatationAxis == 1)//y
					rotateOneEular(obj.transform, 0, fRotValue);
				else
					rotateOneEular(obj.transform, 0, 0, fRotValue);
				m_fTotalRotationValue = fRotValue;
			}
		}
		
		private function setTransform(mat:Matrix3D):void
		{
			var vec:Vector.<Vector3D> = mat.decompose();
			var obj:Object3D = container;
			obj.x = vec[0].x;
			obj.y = vec[0].y;
			obj.z = vec[0].z;
			obj.rotationX = vec[1].x;
			obj.rotationY = vec[1].y;
			obj.rotationZ = vec[1].z;
			obj.scaleX = vec[2].x;
			obj.scaleY = vec[2].y;
			obj.scaleZ = vec[2].z;
		}
		
		/**
		 * 获取当前对象transform对应世界空间矩阵
		 */
		private function getMatInWorld(bParent:Boolean=false):Matrix3D
		{
			var obj:Object3D = container;
			var mat:Matrix3D;
			if(bParent)
				mat = new Matrix3D();
			else
				mat = obj.transform;
			while(obj.parent){
				obj = obj.parent;
				mat.concat(obj.transform);
			}
			return mat;
		}
		
		private function rotateOneEular(matrix:Matrix3D, eulaX:Number=0, eulaY:Number=0, eulaZ:Number=0):void
		{
			var q:Quaternion = new Quaternion();
			if(eulaX != 0)
				q.fromAxisDegree(new Vector3D(1,0,0), eulaX);
			else if(eulaY != 0)
				q.fromAxisDegree(new Vector3D(0,1,0), eulaY);
			else
				q.fromAxisDegree(new Vector3D(0,0,0), eulaZ);
			var retMatrix:Matrix3D = q.toMatrix3D();
			retMatrix.concat(matrix);
			setTransform(retMatrix);
		}
		
		/**
		 * 在世界空间旋转
		 * matrix	3D对象角度
		 * axis		绕世界空间单一轴
		 * angle	相对世界空间旋转角度
		 * @return 	返回旋转后的世界矩阵
		 */
		private function rotateWorld(matrix:Matrix3D,axis:Vector3D, angle:Number):Matrix3D
		{
			var quatUp:Quaternion = new Quaternion();
			quatUp.fromAxisDegree(axis, angle);
			
			var matrixUp:Matrix3D = quatUp.toMatrix3D();
			
			matrixUp.concat(matrix);
			
			return matrixUp;
		}
		private function rotateMatrixEular(matrix:Matrix3D, eulaX:Number, eulaY:Number, eulaZ:Number):Matrix3D
		{
			var retMatrix:Matrix3D;
			
			var quatX:Quaternion = new Quaternion();
			var quatY:Quaternion = new Quaternion();
			var quatZ:Quaternion = new Quaternion();
			
			quatX.fromAxisDegree(new Vector3D(1,0,0), eulaX);
			quatY.fromAxisDegree(new Vector3D(0,1,0), eulaY);
			quatZ.fromAxisDegree(new Vector3D(0,0,1), eulaZ);
			
			var quat:Quaternion = new Quaternion();
			quat.multiply(quatY, quatX);
			quat.multiply(quat, quatZ);
			
			retMatrix = quat.toMatrix3D();
			
			retMatrix.concat(matrix);
			
			return retMatrix;
		}
		/**
		 * @matInWorld	物体矩阵转换到世界空间矩阵
		 */
		private function rotateVector(matInWorld:Matrix3D, v:Vector3D):Vector3D
		{
			var ret:Vector3D = new Vector3D();
			ret = matInWorld.transformVector(v);
			
			return ret;
		}

	}
}