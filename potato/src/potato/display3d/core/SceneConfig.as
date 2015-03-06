package potato.display3d.core
{
	/**
	 * 场景配置 ，场景初始化信息
	 * @author liuxin
	 * 
	 */
	public class SceneConfig
	{
		public function SceneConfig()
		{
		}
		public static const CAMERA_HOVER:uint=0;
		public static const CAMERA_FOLLOW:uint=1;
		
		/////////////////////
		// view3d
		///////////////////////
		public var width:Number;
		public var height:Number;
		public var fov:Number;
		public var near:Number;
		public var far:Number;
		
		//camera
		public var cameraMode:uint=0;
		public var cameraDistance:Number=200;
		public var cameraTiltAngle:Number=45;
		public var cameraPanAngle:Number=180;
		
		/////////////////////////
		// res3d
		/////////////////////////
		//是否编辑器初始化
		public var isEditor:Boolean=false;
		//是否加载序列化资源
		public var loadBin:Boolean=false;
		//纹理路径
		public var pathTexture:String;
		//材质路径
		public var pathMaterial:String;
		//mesh
		public var pathMesh:String;
		//特效路径
		public var pathEffect:String;
		//场景路径
		public var pathScene:String;
		//地形路径
		public var pathTerrian:String;
		
		////////////////////////////
		// world
		///////////////////////////
		//使用导航网格
		public var useWalkNavMesh:Boolean=false;
	}
}