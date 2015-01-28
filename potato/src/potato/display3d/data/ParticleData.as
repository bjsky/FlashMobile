package potato.display3d.data
{
	import core.display3d.Vector3D;

	public class ParticleData
	{
		public function ParticleData()
		{
		}
		public var elemName:String='';
		
//		/**mesh名字*/
//		public var meshName:String;
//		/**纹理名字，带后缀*/
//		public var textureName:String;
//		/**纹理数量*/
//		public var textureNum:int;
//		/**纹理切换速率（ms）*/
//		public var textureSec:int;
//		/**透明拒绝*/
//		public var alphaReject:Number;
		
		
		
		///////////////////////////////////////////技能编辑器能编辑的参数///////////////////////////////////////
//		/**效果类型，表征该数据是粒子系统需要的数据还是广告版数据，具体参数参见Movie3DManager静态常量*/
//		public var effectType:int = 1;//1表示该效果是粒子效果，效果编辑器里面该值可以不设；
		/**发射器数组*/
		public var emitters:Vector.<EmitterData>=new Vector.<EmitterData>();
		/**影响器数组*/
		public var affectors:Vector.<AffectorData>=new Vector.<AffectorData>();
		
		///////////////////////////////////////////PaticleSystem需要的数据///////////////////////////////////////
		//TODO:查阅commonDirection与commonUp
		/**通用方向，用在精灵板计算物体坐标系的过程中*/
		public var commonDirection:Vector3D;
		/**顶点，具体意思需要详查*/
		public var commonUp:Vector3D;
		public var defaultHeight:Number;
		public var defaultWidth:Number;
		public var emitting:Boolean = true;
		/**材质名字*/
		public var material:String;
		/**粒子系统的数量*/
		public var quota:uint;
//		public var rotationX:Number=0;
//		public var rotationY:Number=0;
//		public var rotationZ:Number=0;
//		public var scaleX:Number = 1.0;
//		public var scaleY:Number = 1.0;
//		public var scaleZ:Number = 1.0;
		public var speed:Number = 1.0;
		/**广告版类型*/
		public var type:uint;
		public var visible:Boolean = true;
//		public var x:Number=0;
//		public var y:Number=0;
//		public var z:Number=0;
		
		/** 是否发射到世界空间**/
		public var worldSpace:Boolean=false;
		/////////////////////////////////////////end of PaticleSystem需要的数据////////////////////////////////////
		///////////////////////////////////////////enf of 模型编辑器能编辑的参数///////////////////////////////////////
		
	}
}