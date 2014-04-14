package potato.display3d.controller.camera
{
	import core.display3d.Camera3D;
	import core.display3d.ObjectContainer3D;
	
	/** 跟随相机
	 *  author:liuxin
	 *  date:2014.3.12
	 *  **/
	public class FollowCameraController extends HoverCameraController
	{
		/** 相机，观察对象，观察点距离，y轴旋转角度，仰角度，最大y轴旋转角度，最小y轴旋转角度，最大仰角，最小仰角**/
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
	}
}