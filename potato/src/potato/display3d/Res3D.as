package potato.display3d
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import core.display.Texture;
	import core.display.TextureData;
	import core.filesystem.File;
	
	import potato.display3d.data.MaterialData;
	import potato.display3d.data.ParticleData;
	import potato.utils.Utils;

	public class Res3D
	{
		public function Res3D()
		{
		}
		
		static public var texturePath:String="";
		/** 材质数据**/
		static public var materialDataMap:Dictionary;
		/**
		 * 粒子数据 
		 */		
		static public var particleDataMap:Dictionary;
		/**
		 * 初始化
		 * @param matDatDic
		 * @param texPath
		 * 
		 */
		static public function init(particleData:Dictionary,materialData:Dictionary,texPath:String):void{
			var root:String=Utils.getDefaultPath('');
			//纹理
			texturePath=root+texPath;
			materialDataMap=materialData;
			particleDataMap=particleData;
		}
		
		//没做缓存
		static public function getParticleData(name:String):ParticleData{
			return particleDataMap[name];
		}
		
		//没做缓存
		static public function getMaterialData(name:String):MaterialData{
			return materialDataMap[name];
		}
		
		static public function getTexture(path:String):Texture{
			var tex:Texture;
			var texUrl:String=Res3D.texturePath+path+".png";
			if(texUrl && texUrl!=""){
				try{
					var byteArray:ByteArray=File.readByteArray(texUrl);
					if(byteArray.bytesAvailable>0){
						tex = new Texture(TextureData.createWithByteArray(byteArray));
					}else{
						tex= getDefaultTexture();
					}
				}catch(e:Error){
					tex= getDefaultTexture();
				}
				tex.mipmap=true;
				tex.repeat=true;
			}else {
				tex=getDefaultTexture();
			}
			
			return tex;
		}
		
		/** 默认texture**/
		static public function getDefaultTexture():Texture{
			var texData:TextureData=TextureData.createRGB(8, 8, false, 0);
			
			var i:uint, j:uint;
			for (i=0; i < 8; i++)
			{
				for (j=0; j < 8; j++)
				{
					if ((j ^ i) & 1)
						texData.setPixel(i, j, 0xff00ff);
				}
			}
			
			var ret:Texture=new Texture(texData);
			ret.repeat=true;
			return ret;
		}
	}
}