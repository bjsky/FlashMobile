package potato.display3d.resource
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import core.display.Texture;
	import core.display.TextureData;
	import core.filesystem.File;
	
	import potato.display3d.event.ResourceEvent;

	/** 纹理资源**/
	public class TextureResource extends AbsoluteResource
	{
		public function TextureResource(path:String="",args:Array=null)
		{
			super(path,args);
		}
		/** 材质**/
		static public var textureDic:Dictionary=new Dictionary();
		
		private var _tex:Texture;
		override public function get data():Object{
			return _tex;
		}
		
		/** 加载资源**/
		override public function load():void{
			if(textureDic[path]){
				_tex=textureDic[path];
			}else{
				if(path && path!=""){
					var byteArray:ByteArray=File.readByteArray(path);
					if(byteArray.bytesAvailable>0){
						var tex:Texture = new Texture(TextureData.createWithByteArray(byteArray));
					}else{
						tex=getDefaultTexture();
					}
					tex.mipmap=true;
					tex.repeat=true;
					_tex=tex;
				}else {
					_tex=getDefaultTexture();
				}
				
				textureDic[path]=_tex;
			}
			sendEvent();
		}
		
		private function sendEvent():void{
			
			dispatchEvent(new ResourceEvent(ResourceEvent.TEXTURE_COMPLETE,_tex,_args));
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