package potato.display3d.controller.camera
{
	import core.display3d.Camera3D;
	import core.display3d.ObjectContainer3D;
	import core.display3d.Vector3D;

	/** 观察相机
	 *  author:liuxin
	 *  date:2014.3.12
	 **/
	public class LookAtCameraController extends AbstractCameraController
	{
		/** （相机，观察对象）**/
		public function LookAtCameraController(camera:Camera3D,lookAtObject:ObjectContainer3D=null)
		{
			_camera=camera;
			_lookAtObject=lookAtObject;
			_positionVector=_lookAtObject?new Vector3D(_lookAtObject.x,_lookAtObject.y,_lookAtObject.z):new Vector3D;
		}
		/** 相机**/
		protected var _camera:Camera3D;
		protected var _lookAtObject:ObjectContainer3D;
		/** 观察对象的位置信息**/
		protected var _positionVector:Vector3D;
		
		/** 观察的对象**/
		public function set lookAtObject(v:ObjectContainer3D):void{
			_lookAtObject=v;
			_positionVector=_lookAtObject?new Vector3D(_lookAtObject.x,_lookAtObject.y,_lookAtObject.z):new Vector3D;
			update();
		}
		public function get lookAtObject():ObjectContainer3D{
			return _lookAtObject;
		}
		
		/** 更新**/
		protected function update():void{
			if(!_camera) return;
			_camera.lookAt(_positionVector);
		}
	}
}