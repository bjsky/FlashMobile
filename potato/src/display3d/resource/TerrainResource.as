package potato.display3d.resource
{
	import core.terrain.TileTerrain;
	
	/**
	 * 地形资源
	 * @author liuxin
	 * 
	 */
	public class TerrainResource extends AbsoluteResource
	{
		public function TerrainResource(path:String="",args:Array=null)
		{
			super(path,args);
		}
		private var _ter:TileTerrain;
		override public function get data():Object{
			return _ter;
		}
		
//		public static const CONFIG_TER:int = 1;
//		public static const CONFIG_SENCE:int = 2;
//		public static const CONFIG_COL:int = 3;
//		public static const CONFIG_PATH:int = 4;
//		public static const CONFIG_LIGHT:int = 5;
//		public static const CONFIG_RES:int = 6;
//		
//		private var musicstr:String;		//音乐文件，保留
//		private var waterDic:Dictionary;
//		private var terData:ByteArray;		//用完释放
//		private var senceData:ByteArray;	//用完释放
//		private var colData:ByteArray;		//用完释放
//		private var pathData:ByteArray;		//mapo文件:保留
//		private var lightData:ByteArray;	//用完释放
//		private var resData:ByteArray;		//用完释放
//		
//		
//		
//		override public function load():void{
//			
//			waterDic = new Dictionary();
//			
//			terData = new ByteArray();
//			senceData = new ByteArray();
//			colData = new ByteArray();
//			pathData = new ByteArray();
//			lightData = new ByteArray();
//			resData = new ByteArray();
//			terData.endian = senceData.endian = colData.endian = pathData.endian = lightData.endian = resData.endian = Endian.LITTLE_ENDIAN;
//			
//			var root:String=Utils.getDefaultPath("");
//			path=root+path;
//			var cfg:ByteArray = File.readByteArray(path);
//			if(cfg){
//				parseConfig(cfg);
//				
//				var mat:Material=new Material();
//				var tex:Texture = new Texture(TextureData.createWithByteArray(resData));
//				tex.mipmap=true;
//				mat.texture=tex;
//				tex = new Texture(TextureData.createWithByteArray(lightData));
//				//tex.mipmap=true;
//				mat.lightMap=tex;
//				
//				_ter=new TileTerrain(mat);
//				_ter.loadTerrainData(terData);
//				
//			}else{
//				throw new Error("文件未配置或文件本地不存在");
//			}
//			
//			//派发事件
//			dispatchEvent(new ResourceEvent(ResourceEvent.TERRAIN_COMPLETE,_ter,_args));
//		}
//		
//		
//		//解析地形配置文件
//		private function parseConfig(cfg:ByteArray):void
//		{
//			cfg.endian = Endian.LITTLE_ENDIAN;
//			
//			musicstr = cfg.readUTF();
//			var key:int;
//			var len:int;
//			while(cfg.bytesAvailable)
//			{
//				key = cfg.readUnsignedByte();
//				len = cfg.readUnsignedInt();
//				
//				switch(key)
//				{
//					case CONFIG_TER:
//						cfg.readBytes(terData, 0, len);
//						break;
//					case CONFIG_SENCE:
//						cfg.readBytes(senceData, 0, len);
//						break;
//					case CONFIG_COL:
//						cfg.readBytes(colData, 0, len);
//						break;
//					case CONFIG_PATH:
//						cfg.readBytes(pathData, 0, len);
//						break;
//					case CONFIG_LIGHT:
//						cfg.readBytes(lightData, 0, len);
//						break;
//					case CONFIG_RES:
//						cfg.readBytes(resData, 0, len);
//						break;
//				}
//			}
//		}
	}
}