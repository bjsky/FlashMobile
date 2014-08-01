package potato.display3d.data
{
	import flash.net.registerClassAlias;
	
	import core.display3d.Vector3D;

	public class EffectElemData
	{

		public static function registerAlias():void
		{
			registerClassAlias("potato.effect3d.bean.EffectElemData",EffectElemData);
		}
		public var elemName:String='';
		
		/**mesh名字*/
		public var meshName:String;
		/**纹理名字，带后缀*/
		public var textureName:String;
		/**纹理数量*/
		public var textureNum:int;
		/**纹理切换速率（ms）*/
		public var textureSec:int;
		/**透明拒绝*/
		public var alphaReject:Number;
		
		
		
		///////////////////////////////////////////技能编辑器能编辑的参数///////////////////////////////////////
		/**效果类型，表征该数据是粒子系统需要的数据还是广告版数据，具体参数参见Movie3DManager静态常量*/
		public var effectType:int = 1;//1表示该效果是粒子效果，效果编辑器里面该值可以不设；
		/**开始播放时间*/
		public var startTime:int = 0;//整个效果元素的开始时间，具体的发射器也有自己的开始时间，发射器的开始时间是在该值基础上再做的延迟；
		/**该效果元素的生存时间，注意：一个效果元素可能包含好多发射器，每一个发射器都有自己独立的生存时间。*/
		public var lifeTime:int;//整个效果元素的持续时间，主要用来在到期后销毁资源、派发播放完成事件，具体的发射器可能存活的时间比这个长，两者没有关系。
		/**坐标偏移*/
		public var positon:Vector3D;
		/**朝向*/
		public var orientation:Vector3D;
		/**发射器数组*/
		public var emitters:Array;
		/**影响器数组*/
		public var affectors:Array;
		
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
		public var rotationX:Number=0;
		public var rotationY:Number=0;
		public var rotationZ:Number=0;
		public var scaleX:Number = 1.0;
		public var scaleY:Number = 1.0;
		public var scaleZ:Number = 1.0;
		public var speed:Number = 1.0;
		/**广告版类型*/
		public var type:uint;
		public var visible:Boolean = true;
		public var x:Number=0;
		public var y:Number=0;
		public var z:Number=0;
		/////////////////////////////////////////end of PaticleSystem需要的数据////////////////////////////////////
		///////////////////////////////////////////enf of 模型编辑器能编辑的参数///////////////////////////////////////
		
		public function EffectElemData()
		{
		}
	}
}