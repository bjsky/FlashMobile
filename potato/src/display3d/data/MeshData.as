package  potato.display3d.data
{
	import flash.net.registerClassAlias;
	
	import core.display3d.Vector3D;

	public class MeshData
	{
		/**mesh or skin 0:mesh, 1:skin**/
		public var type:int;
		/**名字**/
		public var name:String;
		/**min-bounds**/
		public var min:Vector3D;
		/**max-bounds**/
		public var max:Vector3D;
		/**暂未用到**/
		public var radius:Number;
		/**子几何体数组**/
		public var subGemArr:Array;
		/**材质列表，不建议使用多个，一个足以。**/
		public var materials:Array;
		public static function registerAlias():void
		{
			registerClassAlias("potato.mirage3d.data.MeshData",MeshData);
			Vector3D.registerAlias();
		}
	}
}