package potato.display3d.data
{
	import core.display3d.Vector3D;

	public class PassData
	{
		public function PassData()
		{
		}
		
		public var blend:int;
		
		public var depthCheck:Boolean=true;
		public var depthWrite:Boolean=true;
		public var depthBias:Number=0;
		public var colorWrite:Boolean=true;
		
		public var lighting:Boolean=true;
		public var ambient:uint=0xffffff;
		public var diffuse:uint=0xffffff;
		public var specular:uint=0xffffff;
		public var gloss:Number=0;
		public var alphaReject:Number=0;
		public var frameAnim:Vector3D;
		/***/
		/**
		 *纹理图片的名字 
		 */
		public var texture:String;
		
		public var texture_num:int;
	}
}