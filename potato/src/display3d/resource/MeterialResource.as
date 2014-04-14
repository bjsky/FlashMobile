package potato.display3d.resource
{
	import flash.utils.Dictionary;
	
	import core.display.Texture;
	import core.display3d.Material;
	import core.display3d.Pass;
	
	import potato.display3d.GameInstance;
	import potato.display3d.event.ResourceEvent;
	import potato.mirage3d.data.MaterialData;
	import potato.mirage3d.data.PassData;

	/**
	 * 材质资源
	 * @author liuxin
	 * 
	 */
	public class MeterialResource extends AbsoluteResource
	{
		public function MeterialResource(path:String="",args:Array=null)
		{
			super(path,args);
		}
		
		/** 材质**/
		static public var materialDic:Dictionary=new Dictionary();
		
		private var _met:Material;
		override public function get data():Object{
			return _met;
		}
		private var _md:MaterialData;
		
		override public function load():void{
			if(materialDic[path]){
				_met=materialDic[path];
				sendEvent();
			}else{
				_md= GameInstance.materialDataDic[path];
				if (_md)
				{
					var pd:PassData=_md.passes[0];
					var texUrl:String=GameInstance.texturePath+pd.texture;
					var texRes:TextureResource=new TextureResource(texUrl);		//声明一个纹理资源
					texRes.addEventListener(ResourceEvent.TEXTURE_COMPLETE,onTextureLoaded);
					//场景的加载器去加载
					GameInstance.scene.loadController.load(texRes);
					
				}else{
					_met=getDefaultMaterial();
					materialDic[path]=_met;
					sendEvent();
				}
			}
		}
		
		private function sendEvent():void{
			dispatchEvent(new ResourceEvent(ResourceEvent.MATERIAL_COMPLETE,_met,_args));
		}
		
		private function onTextureLoaded(e:ResourceEvent):void{
			var tex:Texture=e.resource as Texture;
			var tmpMat:Material=new Material();
			tmpMat.name=_md.name;
			setPassData(tmpMat,_md.passes[0],tex);
			
			_met=tmpMat;
			materialDic[path]=_met;
			sendEvent();
		}
		
		
		private static function setPassData(ps:Pass, pd:PassData,tex:Texture):void
		{
			ps.blendMode=pd.blend;
			ps.colorWrite=pd.colorWrite;
			ps.depthWrite=pd.depthWrite;
			ps.depthCheck=pd.depthCheck;
			ps.depthBias=pd.depthBias;
			ps.lightingEnabled=pd.lighting;
			ps.ambient=ps.diffuse=ps.specular=1;
			ps.ambientColor=pd.ambient;
			ps.diffuseColor=pd.diffuse;
			ps.specularColor=pd.specular;
			ps.gloss=pd.gloss;
			ps.alphaReject=pd.alphaReject;
			ps.texture=tex;
		}

		
		static private function getDefaultMaterial():Material
		{
			var tex:Texture=TextureResource.getDefaultTexture();
			return new Material(tex);
		}
	}
}