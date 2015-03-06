package potato.display3d.behaviour.common
{
	import core.display3d.Vector3D;

	public class Vector4
	{
		private var _x:Number;//R
		private var _y:Number;//G
		private var _z:Number;//B
		private var _w:Number;//A
		
		public function Vector4(x:Number,y:Number,z:Number,w:Number)
		{
			_x = x;
			_y = y;
			_z = z;
			_w = w;
		}
		
		public function toColor():uint
		{
			return (_w*255)<<24|(_x*255)<<16|(_y*255)<<8|(_z*255);
		}
		public function toVector3D():Vector3D
		{
			return new Vector3D(_x,_y,_z,_w);
		}
		public function getValue(index:int):Number
		{
			if(0 == index)
				return _x;
			else if(1 == index)
				return _y;
			else if(2 == index)
				return _z;
			else if(3 == index)
				return _w;
			return 0;
		}
		public function setValue(index:int,v:Number):void
		{
			if(0 == index)
				_x = v;
			else if(1 == index)
				_y = v;
			else if(2 == index)
				_z = v;
			else if(3 == index)
				_w = v;
		}
	}
}