package potato.res.particle2DSystem
{
	import flash.utils.Dictionary;
	
	import core.display.ParticleSystem2D;
	import core.display.Texture;
	import core.display.TextureData;
	import core.filesystem.File;
	
	import potato.editor.fileBox.FileBox;
	import potato.editor.fileBox.FileBoxDefine;

	public class PexFileUtil
	{
		/**
		 * 2D粒子系统纹理属性名称
		 * **/
		private static const TEXTURE:String="texture";
		/**
		 * 2D粒子系统纹理路径属性名称
		 * **/
		private static const TEXTUREPATH:String="texturePath";
		/**
		 * 粒子系统发射时长
		 */
		private static const DURATION:String="duration";
		/**xml格式中的属性，单独符合属性已经拆分为了单条属性加.分割父子*/
		private static const XML_PROPERTY:Array=["texture","sourcePosition.x","sourcePosition.y","sourcePositionVariance.x","sourcePositionVariance.y","speed","speedVariance","particleLifeSpan","particleLifespanVariance","angle","angleVariance","gravity.x","gravity.y","radialAcceleration","tangentialAcceleration","radialAccelVariance","tangentialAccelVariance","startColor.red","startColor.green","startColor.blue","startColor.alpha","startColorVariance.red","startColorVariance.green","startColorVariance.blue","startColorVariance.alpha","finishColor.red","finishColor.green","finishColor.blue","finishColor.alpha","finishColorVariance.red","finishColorVariance.green","finishColorVariance.blue","finishColorVariance.alpha","maxParticles","startParticleSize","startParticleSizeVariance","finishParticleSize","FinishParticleSizeVariance","emitterType","maxRadius","maxRadiusVariance","minRadius","rotatePerSecond","rotatePerSecondVariance","rotationStart","rotationStartVariance","rotationEnd","rotationEndVariance","duration","blendMode","emissionRate","textruePath"];
		/**对应XML_PROPERTY中次序的属性名称*/
		private static const PROPERTY:Array=["texture","emitterX","emitterY","emitterXVariance","emitterYVariance","speed","speedVariance","lifespan","lifespanVariance","emitAngle","emitAngleVariance","gravityX","gravityY","radialAcceleration","tangentialAcceleration","radialAccelerationVariance","tangentialAccelerationVariance","startColorRed","startColorGreen","startColorBlue","startColorAlpha","startColorRedVariance","startColorGreenVariance","startColorBlueVariance","startColorAlphaVariance","endColorRed","endColorGreen","endColorBlue","endColorAlpha","endColorRedVariance","endColorGreenVariance","endColorBlueVariance","endColorAlphaVariance","maxNumParticles","startSize","startSizeVariance","endSize","endSizeVariance","emitterType","maxRadius","maxRadiusVariance","minRadius","rotatePerSecond","rotatePerSecondVariance","startRotation","startRotationVariance","endRotation","endRotationVariance","duration","blendMode","emissionRate"];
		/**
		 * 字典<br>
		 * key：xml中的属性名<br>
		 * value：粒子系统属性名<br>
		 * （读取pex数据使用）<br>
		 */
		private static var X2P_DIC:Dictionary;// xml存储名称对应的属性名称
		
		/** 
		 * 读取指定路径的的pex（XML）文件，设置数值
		 *  * （读取pex数据使用）<br>
		 */
		public static function loadPexFile(filePath:String,ps:ParticleSystem2D):Number
		{
			var configXmlList:XMLList=new XMLList(File.read(filePath));
			var propertys:XMLList=configXmlList.children();
			var obj:Object={};
			for(var i:int=0;i<propertys.length();i++)
			{
				var temp:XMLList =  propertys[i].attributes(); 
				var pName:String=propertys[i].localName();
				var xd:PexBean=new PexBean();
				xd.setData(propertys[i]);
				setPropertyByNode(obj,xd);
			}
			if(obj[TEXTUREPATH])// 如果配置文件中有texturePath属性，则覆盖texture属性
			{
				obj[TEXTURE]=obj[TEXTUREPATH];
			}
			for(i=0;i<PROPERTY.length;i++)
			{
				if(PROPERTY[i]!=TEXTURE&&PROPERTY[i]!=DURATION&&obj[PROPERTY[i]]!=null)
				{
					ps[PROPERTY[i]]=obj[PROPERTY[i]];
				}
			}
			if(obj["blendMode"]==null)
			{
				ps.blendMode=3;
			}
			if(obj["emissionRate"]==null)
			{
				ps.emissionRate=60;
			}
			if(obj[TEXTURE]==null)
			{
				throw new Error("2D粒子配置文件："+filePath+"中缺少纹理属性！");
			}
			var texturePath:String=obj[TEXTURE] as String;
			//			trace(filePath+"/../"+texturePath);
//			if(File.exists(texturePath))// 尝试采用编辑器路径图片
//			{
//				ps.texture=new Texture(TextureData.createWithFile(texturePath as String));
//			} 
//			else 
//			{
				var picName:String=new String(texturePath);
				picName=picName.replace(new RegExp(FileBoxDefine.DIRECTORY_SEPATRATOR+"$"),"");// 去掉末尾可能的FileBox.DIRECTORY_SEPATRATOR
				var lastIndex:int=picName.lastIndexOf(FileBoxDefine.DIRECTORY_SEPATRATOR);
				if(lastIndex>-1)
				{
					picName=picName.substr(lastIndex+1);
				}
				var pStr:String=new String(filePath);
				var lastIndexInPath:int=pStr.lastIndexOf(FileBoxDefine.DIRECTORY_SEPATRATOR);
				if(lastIndexInPath>-1)
				{
					pStr=pStr.substring (0,lastIndexInPath+1);
				}
				var newPath:String=pStr+picName;
				trace(newPath);
				if(File.exists(newPath))// 尝试找pex同一目录中的纹理（兼容pex）
				{
					ps.texture=new Texture(TextureData.createWithFile(newPath));
//					trace("2D粒子配置文件："+filePath+"中纹理图片建议采用："+filePath+"/../"+texturePath);
				}
				else
				{
					throw new Error("2D粒子配置文件："+filePath+"中纹理图片"+obj[TEXTURE]+"不存在！");
				}
//			}
//				trace(DURATION);
			return obj[DURATION] as Number;
		}
		/**初始化X2P_DIC字典，只做一次*/
		private static function initX2P():void
		{
			if(X2P_DIC)return;
			X2P_DIC=new Dictionary();
			for(var i:int=0;i<XML_PROPERTY.length;i++)
			{
				X2P_DIC[XML_PROPERTY[i]]=PROPERTY[i];
			}
		}
		/**
		 * 读取一个XmlData实例中的数据<br>
		 * （getPvalue方法可以根据2D粒子系统的属性获取到这些数据）
		 *  * （读取pex数据使用）<br>
		 */
		private static function setPropertyByNode(obj:Object,data:PexBean):void
		{
			initX2P();
			var pName:String="";
			if(data.getType()==PexBean.TYPE_SIMPLE)// 处理单一属性的情况
			{
				if(!X2P_DIC[data.pName])
				{
					//					trace("pex配置文件中多余属性："+data.pName);
					if(data.pName==TEXTUREPATH)
					{
						obj[TEXTUREPATH]=data.values[0]["value"];
					}else
					{
						return;
					}
				}
				if(data.values[0]["value"])
				{
					obj[X2P_DIC[data.pName]]=new Number(data.values[0]["value"]);
				}else
				{
					obj[X2P_DIC[data.pName]]=data.values[0]["name"];//
				}
				
			}else if(data.getType()==PexBean.TYPE_MULTIPLE)// 复合属性
			{
				for(var i:int=0;i<data.values.length;i++)
				{
					for(var key:* in data.values[i])
					{
						if(key.indexOf("Blue")!=-1||key.indexOf("Green")!=-1||key.indexOf("Red")!=-1)
						{
							obj[X2P_DIC[data.pName+"."+key]]=new Number(data.values[i][key])*255;
						}
						else
						{
							obj[X2P_DIC[data.pName+"."+key]]=data.values[i][key];
						}
					}
				}
			}
		}
	}
}
