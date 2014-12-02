package potato.display3d.controller.camera
{
	import core.display3d.Camera3D;
	import core.display3d.ObjectContainer3D;
	
	/**
	 *  悬停相机
	 * @author liuxin
	 * 
	 */
	public class HoverCameraController extends LookAtCameraController
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
		public function HoverCameraController(camera:Camera3D, lookAtObject:ObjectContainer3D=null,distance:Number=0,panAngle:Number=0,tiltAngle:Number=90
			,maxPanAngle:Number=NaN,minPanAngle:Number=NaN,maxTiltAngle:Number=90,minTiltAngle:Number=-90)
		{
			super(camera, lookAtObject);
			_distance=distance;
			_panAngle=panAngle;
			_tiltAngle=tiltAngle;
			_maxPanAngle=maxPanAngle || Infinity;
			_minPanAngle=minPanAngle || -Infinity;
			_maxTiltAngle=maxTiltAngle;
			_minTiltAngle=minTiltAngle;
		}
		
		private var _distance:Number=0;
		private var _panAngle:Number=0;
		private var _tiltAngle:Number=90;
		private var _maxPanAngle:Number=Infinity;
		private var _minPanAngle:Number=-Infinity;
		private var _maxTiltAngle:Number=90;
		private var _minTiltAngle:Number=-90;
		
		override protected function update():void{
			if(!_camera) return;
			var panRadians:Number=_panAngle*Math.PI/180;
			var tiltRadians:Number=_tiltAngle*Math.PI/180;
			
			_camera.x = _positionVector.x + _distance*Math.sin(panRadians)*Math.cos(tiltRadians);
			_camera.z = _positionVector.z + _distance*Math.cos(panRadians)*Math.cos(tiltRadians);
			_camera.y = _positionVector.y + _distance*Math.sin(tiltRadians)*2;
			
			super.update();
		}
		
		///////////////////////
		// 属性
		/////////////////////////
		/** 观察点的距离**/
		public function set distance(v:Number):void{
			if (_distance == v)
				return;
			_distance = v;
			update();
		}
		public function get distance():Number{
			return _distance;
		}
		
		/** y轴旋转的度**/
		public function set panAngle(v:Number):void{
			v = Math.max(_minPanAngle, Math.min(_maxPanAngle, v));			
			if (_panAngle == v)
				return;			
			_panAngle = v;
			update();
		}
		public function get panAngle():Number{
			return _panAngle;
		}

		/** 仰角的度**/
		public function set tiltAngle(v:Number):void{
			v = Math.max(_minTiltAngle, Math.min(_maxTiltAngle, v));			
			if (_tiltAngle == v)
				return;			
			_tiltAngle = v;
			update();
		}
		public function get tiltAngle():Number{
			return _tiltAngle;
		}
		
		/** y轴最大旋转的度**/
		public function set maxPanAngle(v:Number):void{
			if (_maxPanAngle == v)
				return;			
			_maxPanAngle = v;			
			panAngle = Math.max(_minPanAngle, Math.min(_maxPanAngle, _panAngle));
		}
		public function get maxPanAngle():Number{
			return _maxPanAngle;
		}
		
		/** y轴最小旋转的度**/
		public function set minPanAngle(v:Number):void{
			if (_minPanAngle == v)
				return;		
			_minPanAngle = v;
			panAngle = Math.max(_minPanAngle, Math.min(_maxPanAngle, _panAngle));
		}
		public function get minPanAngle():Number{
			return _minPanAngle;
		}
		
		/** 仰角最大的度**/
		public function set maxTiltAngle(v:Number):void{
			if (_maxTiltAngle == v)
				return;		
			_maxTiltAngle = v;			
			tiltAngle = Math.max(_minTiltAngle, Math.min(_maxTiltAngle, _tiltAngle));
		}
		public function get maxTiltAngle():Number{
			return _maxTiltAngle;
		}
		
		/** 仰角最小的度**/
		public function set minTiltAngle(v:Number):void{
			if (_minTiltAngle == v)
				return;			
			_minTiltAngle = v;		
			tiltAngle = Math.max(_minTiltAngle, Math.min(_maxTiltAngle, _tiltAngle));
		}
		public function get minTiltAngle():Number{
			return _minTiltAngle;
		}
	}
}