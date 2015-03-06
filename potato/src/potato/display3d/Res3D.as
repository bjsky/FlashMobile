package potato.display3d
{
	import flash.utils.Dictionary;
	
	import core.filesystem.File;
	import core.filesystem.FileInfo;
	
	import potato.display3d.core.EffectManager;
	import potato.display3d.core.MaterialManager;
	import potato.display3d.core.MeshManager;
	import potato.display3d.core.ParticleManager;
	import potato.display3d.core.SkeletonManager;
	import potato.display3d.core.TextureManager;
	import potato.display3d.data.EffectData;
	import potato.display3d.data.MaterialData;
	import potato.display3d.data.ParticleData;
	import potato.display3d.loader.EffectParser;
	import potato.display3d.loader.MaterialParser;
	import potato.display3d.loader.ParticleParser;
	import potato.utils.Utils;

	/**
	 * 全局资源配置 ，资源接口和版本管理
	 * @author liuxin
	 * 
	 */
	public class Res3D
	{
		public function Res3D()
		{
		}
		
		public static const SUFFIX_TEXTUREPNG:String=".png";
		public static const SUFFIX_MESHM3D:String=".m3d";
		public static const SUFFIX_SCENECFG:String=".cfg";
		/**
		 * 获取png后缀的纹理文件名 
		 * @param name
		 * @return 
		 * 
		 */
		public static function getTextureSuffix(name:String):String{
			if(Utils.pathSuffix(name)!="")
				return name;
			else
				return name + SUFFIX_TEXTUREPNG;
		}
		
		/**
		 * 获取m3d后缀的mesh文件名 
		 * @param name
		 * @return 
		 * 
		 */
		public static function getMeshSuffix(name:String):String{
			if(Utils.pathSuffix(name)!="")
				return name;
			else
				return name + SUFFIX_MESHM3D;
		}
		
		/**
		 * 获取场景后缀文件 
		 * @param name
		 * @return 
		 * 
		 */
		public static function getSceneSuffix(name:String):String{
			if(Utils.pathSuffix(name)!="")
				return name;
			else
				return name + SUFFIX_SCENECFG;
		}
		
		/**
		 * 初始化编辑器资源 
		 * @param texturePath
		 * @param materialData
		 * @param particleData
		 * @param effectData
		 * @param meshPath
		 * @param skeletonPath
		 * 
		 */
		public static function initEditorRes(texturePath:String,meshPath:String,skeletonPath:String,
											 materialData:Dictionary,particleData:Dictionary,effectData:Dictionary):void{
			
			TextureManager.path=texturePath;
			MeshManager.path=meshPath;
			SkeletonManager.path=skeletonPath;
			MaterialManager.setMaterialData(materialData);
			ParticleManager.setParticleData(particleData);
			EffectManager.setEffectData(effectData);
		}
		
		/**
		 * 初始化文本配置资源，指材质和效果 
		 * @param effectPath
		 * @param materialPath
		 * 
		 */
		public static function initTxtRes(effectPath:String,materialPath:String):void{
			var effectDic:Dictionary=new Dictionary();
			var particleDic:Dictionary=new Dictionary();
			var materialDic:Dictionary=new Dictionary();
			
			var effectFileName:String;
			var arr:Array = File.getDirectoryListing(effectPath);
			
			var fi:FileInfo;
			for each(fi in arr)
			{
				if (fi.isDirectory)
					continue;
				
				effectFileName = fi.name;
				var effectFileArr:Array = effectFileName.split(".");
				if(effectFileArr.length>2)
					continue;
				effectFileName = effectFileArr[1];
				
				if (effectFileName != "effect")
				{
					continue;
				}
				effectFileName = effectPath + '/' + fi.name;
				trace("effect file name:", effectFileName);
				var eParser:EffectParser=new EffectParser();
				var item:EffectData = eParser.parse(effectFileName);
				effectDic[item.effectName] = item;
				
				var _curParticleParser:ParticleParser=new ParticleParser();
				var _particles:Vector.<ParticleData> = _curParticleParser.parse(effectFileName);//,e.effectElemDataArr);
				_particles.forEach(function(item:*, index:int, array:Vector.<ParticleData>):void{
					particleDic[(item as ParticleData).elemName]=(item as ParticleData);
				});
			}
			
			var matFileName:String;
			arr = File.getDirectoryListing(materialPath);
			
			var mParser:MaterialParser = new MaterialParser();
			for each(fi in arr)
			{
				if (fi.isDirectory)
					continue;
				
				matFileName = fi.name;
				var matFileArr:Array = matFileName.split(".");
				if(matFileArr.length>2)
					continue;
				matFileName = matFileArr[1];
				if (matFileName != "material")
				{
					continue;
				}
				
				matFileName = materialPath+"/"+fi.name;
				trace("meterial file name:", matFileName);
				var mats:Vector.<MaterialData>=mParser.parse(matFileName);
				mats.forEach(function(item:*, index:int, array:Vector.<MaterialData>):void{
					materialDic[(item as MaterialData).name]=(item as MaterialData);
				});
			}
			
			EffectManager.setEffectData(effectDic);
			ParticleManager.setParticleData(particleDic);
			MaterialManager.setMaterialData(materialDic);
		}
	}
}