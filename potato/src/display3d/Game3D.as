package potato.display3d
{
	import flash.utils.Dictionary;
	
	import core.display3d.SkinnedSubGeometry;
	import core.display3d.SubGeometry;
	import core.display3d.Vector3D;
	import core.effects.ColorFader2Affector;
	import core.effects.ColorFader6Affector;
	import core.effects.ColorFaderAffector;
	import core.effects.LinearForceAffector;
	import core.effects.MotionAffector;
	import core.effects.Rotation2Affector;
	import core.effects.Rotation6Affector;
	import core.effects.RotationAffector;
	import core.effects.Scale2Affector;
	import core.effects.Scale6Affector;
	import core.effects.ScaleAffector;
	import core.filesystem.File;
	
	import potato.display3d.data.ActorEffectData;
	import potato.display3d.data.BoxEmitterData;
	import potato.display3d.data.CylinderEmitterData;
	import potato.display3d.data.EffectData;
	import potato.display3d.data.EffectElemData;
	import potato.display3d.data.EllipsoidEmitterData;
	import potato.display3d.data.HollowEllipsoidEmitterData;
	import potato.display3d.data.LocatorData;
	import potato.display3d.data.MaterialData;
	import potato.display3d.data.MeshData;
	import potato.display3d.data.ObjData;
	import potato.display3d.data.ParticleEmitterData;
	import potato.display3d.data.PassData;
	import potato.display3d.data.PointEmitterData;
	import potato.display3d.data.PolarEmitterData;
	import potato.display3d.data.RingEmitterData;
	import potato.display3d.data.SkillData;
	import potato.utils.Utils;
	
	/**
	 * 3d实例<br />
	 * @author liuxin
	 * @note 用静态实例将3d资源集中管理，统一配置
	 */
	public class Game3D
	{
		public function Game3D()
		{
			
		}
		/** 纹理路径**/
		static public var texturePath:String;
		/** 材质数据**/
		static public var materialDataMap:Dictionary;
		
		/** 场景**/
		static public var scene:Scene=new Scene();
		
		
		/**
		 * 初始化资源
		 * @param materialDataPath	材质配置路径
		 * @param _texturePath	纹理路径
		 * 
		 */
		static public function initResource(materialDataPath:String,theTexturePath:String):void{
			regist3DAlias();
			
//			var root:String=Utils.getDefaultPath('');
			//纹理
//			texturePath=root+_texturePath;
			
			//材质
//			materialDataPath=root+materialDataPath;
			texturePath=theTexturePath;
			materialDataMap=File.readByteArray(materialDataPath).readObject();
		}
		
		/**
		 * 初始化场景
		 * @w	视口宽度
		 * @h	视口高度
		 * @fov		Y方向视角
		 * @near	近平面
		 * @far		远平面
		 */
		static public function initScene(w:Number,h:Number,fov:Number,near:Number,far:Number):void{
			scene.width = w;
			scene.height = h;
			scene.fov = fov;
			scene.near = near;
			scene.far = far;
		}
		
		/**
		 *注册全部的3D引擎用到的别名； 
		 * 
		 */
		static public function regist3DAlias():void{
			MaterialData.registerAlias();
			PassData.registerAlias();
			SubGeometry.registerAlias();
			SkinnedSubGeometry.registerAlias();
			MeshData.registerAlias();
			SkillData.registerAlias();
			ParticleEmitterData.registerAlias();
			PointEmitterData.registerAlias();
			BoxEmitterData.registerAlias();
			RingEmitterData.registerAlias();
			CylinderEmitterData.registerAlias();
			HollowEllipsoidEmitterData.registerAlias();
			EllipsoidEmitterData.registerAlias();
			PolarEmitterData.registerAlias();
			ColorFaderAffector.registerAlias();
			ColorFader2Affector.registerAlias();
			ColorFader6Affector.registerAlias();
			ScaleAffector.registerAlias();
			Scale2Affector.registerAlias();
			Scale6Affector.registerAlias();
			LinearForceAffector.registerAlias();
			MotionAffector.registerAlias();
			RotationAffector.registerAlias();
			Rotation2Affector.registerAlias();
			Rotation6Affector.registerAlias();
			Vector3D.registerAlias();
			EffectData.registerAlias();
			EffectElemData.registerAlias();
			ObjData.registerAlias();
			ActorEffectData.registerAlias();
			LocatorData.registerAlias();
			Vector3D.registerAlias();
		}
	}
}