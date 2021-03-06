package potato.display3d.controller.camera
{
	import core.display3d.Camera3D;
	import core.display3d.ObjectContainer3D;
	import core.events.Event;
	
	/**
	 *  跟随相机
	 * @author liuxin
	 * 
	 */	
	public class FollowCameraController extends HoverCameraController
	{
		/**
		 *  
		 * @param camera 相机
		 * @param lookAtObject 观察对象
		 * @param distance 观察点距离
		 * @param panAngle y轴旋转角度
		 * @param tiltAngle 仰角度
		 * @param maxPanAngle 最大y轴旋转角度
		 * @param minPanAngle 最小y轴旋转角度
		 * @param maxTiltAngle 最大仰角
		 * @param minTiltAngle 最小仰角
		 * 
		 */
		public function FollowCameraController(camera:Camera3D, lookAtObject:ObjectContainer3D=null, distance:Number=0, panAngle:Number=0, tiltAngle:Number=90, maxPanAngle:Number=NaN, minPanAngle:Number=NaN, maxTiltAngle:*=90, minTiltAngle:*=-90)
		{
			super(camera, lookAtObject, distance, panAngle, tiltAngle, maxPanAngle, minPanAngle, maxTiltAngle, minTiltAngle);
		}
		
		override protected function update():void
		{
			if (!lookAtObject)
				return;                
			
			panAngle = _lookAtObject.rotationY - 180;
			super.update();
			
		}               

		private var _preX:Number=0;
		private var _preY:Number=0;
		private var _preZ:Number=0;
		private var _preRX:Number=0;
		private var _preRY:Number=0;
		private var _preRZ:Number=0;
		override protected function enterframeHandler(e:Event):void
		{
			if(lookAtObject.x != _preX || lookAtObject.y != _preY || lookAtObject.z!=_preZ
				|| lookAtObject.rotationX != _preRX || lookAtObject.rotationY != _preRY || lookAtObject.rotationZ!= _preRZ){
				lookAtObject = lookAtObject;
				_preX = lookAtObject.x;
				_preY = lookAtObject.y;
				_preZ = lookAtObject.z;
				_preRX = lookAtObject.rotationX;
				_preRY = lookAtObject.rotationY;
				_preRZ = lookAtObject.rotationZ;
			}
		}
	}
}