package potato.display3d.core
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import core.display.DisplayObjectContainer;
	import core.display.Texture;
	import core.display.TextureData;
	import core.display3d.Camera3D;
	import core.display3d.Fog;
	import core.display3d.Material;
	import core.display3d.Matrix3D;
	import core.display3d.Mesh;
	import core.display3d.Object3D;
	import core.display3d.Quaternion;
	import core.display3d.Scene3D;
	import core.display3d.SubGeometry;
	import core.display3d.UVMatrix;
	import core.display3d.Vector3D;
	import core.display3d.View3D;
	import core.filesystem.File;
	import core.terrain.BlendTerrain;
	import core.terrain.BlendTerrainBlock;
	
	import potato.potato_internal;
	import potato.display3d.Res3D;
	import potato.display3d.async.AsyncHandler;
	import potato.display3d.controller.camera.AbstractCameraController;
	import potato.display3d.controller.camera.FollowCameraController;
	import potato.display3d.controller.camera.HoverCameraController;
	import potato.utils.Utils;

	/**
	 * 场景管理器 
	 * @author liuxin
	 * 
	 */
	public class SceneManager
	{
		public function SceneManager()
		{
		}
		use namespace potato_internal;
		
		private static const MARK_UNITY_SCENE:String="_unity_scene";
		private static const MARK_UNITY_NAV:String="_unity_nav.nav";
		private static const MARK_TERRIAN_CFG:String="_unity_ter.cfg";
		private static const MARK_NAV_MAPO:String=".mapo";
		
		private static var _main:DisplayObjectContainer;
		private static var _mainView:View3D;
		private static var _terrain:BlendTerrain;
		private static var _cameraController:AbstractCameraController;
		
		private static var _config:SceneConfig;
		
		
		public static var path:String;
		public static var terrianPath:String;
		/**
		 * 主摄像头 
		 * @return 
		 * 
		 */
		public static function get camera():Camera3D{
			return _mainView?_mainView.camera:null;
		}
		
		/**
		 * 悬停摄像头控制器
		 * @return 
		 * 
		 */		
		public static function get hoverCamera():HoverCameraController{
			return _cameraController as HoverCameraController;
		}
		
		public static function get followCamera():FollowCameraController{
			return _cameraController as FollowCameraController;
		}
		
		/**
		 * 主场景 
		 * @return 
		 * 
		 */
		public static function get scene():Scene3D{
			return _mainView?_mainView.scene:null;
		}
		
		/**
		 * 地形区域 
		 * @return 
		 * 
		 */
		public static function get terrianRect():Rectangle{
			return new Rectangle(_terrain.x,_terrain.y,xblock * xblockW, zblock * zblockH);
		}
		
		/**
		 * 设置场景大小 
		 * @param width
		 * @param height
		 * 
		 */
		public static function setSize(width:Number,height:Number):void{
			if(_mainView){
				_mainView.width=width;
				_mainView.height=height;
			}
		}
		
		/**
		 * 获取地形高度 
		 * @param x
		 * @param z
		 * @return 
		 * 
		 */
		public static function getHeight(x:Number,z:Number):Number
		{
			if (!parsedHeight)
				return 0;
			x = x - _terrain.x;
			z = z - _terrain.z;
			if (x<0)
				x=0;
			if (x>=xblockW * xblock)
				x = xblockW * xblock - 0.1;
			if (z<0)
				z=0;
			if (z>=zblockH * zblock)
				z = zblockH * zblock - 0.1;
			//trace(x, z, xblockW, zblockH);
			x = x / (xblockW * xblock) * (m3dTerW-1);
			z = z / (zblockH * zblock) * (m3dTerH-1);
			
			
			var xi:int=Math.floor(z);
			var zi:int=Math.floor(x);
			var xf:Number=z-xi;
			var zf:Number=x-zi;
			
			
			var t:Number;
			var h:Number;
			if (x+z<1) {
				t=terrainHeight[xi][zi];
				h=t+(terrainHeight[xi+1][zi]-t)*xf+(terrainHeight[xi][zi+1]-t)*zf;
			} else {
				
				t=terrainHeight[xi+1][zi+1];
				h=t+(terrainHeight[xi+1][zi]-t)*(1-zf)+(terrainHeight[xi][zi+1]-t)*(1-xf);
			}
			
			return h;
		}
		
		/**
		 * 是否可行走 
		 * @param x
		 * @param z
		 * @return 
		 * 
		 */
		public static function isWalkable(x:Number,z:Number):Boolean{
			if(!_config.useWalkNavMesh)
				return true;
			//trace("heroMove");
			var gridx:int = x; 
			var gridz:int =(logicHeight - z-1);
			var index:int = (gridz) * logicWidth +gridx;
			if (btCol[index]==1)
				return false;
			else
				return true;
		}
		
		
		/**
		 * 启动场景 
		 * @param main 主程序
		 * @param config 场景配置
		 * @param startScene 初始场景
		 */
		public static function startup(main:DisplayObjectContainer,config:SceneConfig,startScene:String=""):void{
			_main = main;
			_config = config;
			
			_mainView=new View3D();
			_main.addChild(_mainView);
			
			initConfig();
			if(startScene!=""){
				//加载场景
				loadScene(startScene);
			}
			
			//启动脚本
			BehaviourManager.startup(main);
		}
		
		/**
		 * 初始化配置 
		 * 
		 */
		private static function initConfig():void
		{
			if(_mainView){
				_mainView.width = _config.width;
				_mainView.height = _config.height;
				_mainView.fov = _config.fov;
				_mainView.near = _config.near;
				_mainView.far = _config.far;
			}
			
			if(_config.isEditor)		//编辑器取消
				return;
			
			//camera
			switch(_config.cameraMode){
				case SceneConfig.CAMERA_HOVER: 
					_cameraController = new HoverCameraController(_mainView.camera); 
					hoverCamera.distance=_config.cameraDistance;
					hoverCamera.tiltAngle=_config.cameraTiltAngle;
					hoverCamera.panAngle=_config.cameraPanAngle;
					break;
				case SceneConfig.CAMERA_FOLLOW: 
					_cameraController = new FollowCameraController(_mainView.camera); 
					followCamera.distance=_config.cameraDistance;
					followCamera.tiltAngle=_config.cameraTiltAngle;
					followCamera.panAngle=_config.cameraPanAngle;
					break;
				default: 
					break;
			}
			
			var root:String=Utils.getDefaultPath("");
			
			if(!_config.loadBin){
				//path
				TextureManager.path = root + _config.pathTexture;
				MeshManager.path = root + _config.pathMesh;
				SkeletonManager.path = root + _config.pathMesh;
				path = root + _config.pathScene;
				terrianPath = root + _config.pathTerrian;
				
				var effectPath:String = root + _config.pathEffect;
				var materialPath:String = root + _config.pathMaterial;
				Res3D.initTxtRes(effectPath,materialPath)
			}
		}
		
		
		/**
		 * 加载场景 
		 * @param name
		 * 
		 */
		public static function loadScene(name:String):void
		{
			//remove prevScene
			
			//nav mapo
			readMapo(path + name +MARK_NAV_MAPO);
			
			var cfgPath:String = path + Res3D.getSceneSuffix(name + MARK_UNITY_SCENE)
			var b:ByteArray=File.readByteArray(cfgPath);
			b.endian = Endian.LITTLE_ENDIAN;
			
			var i:int = 0;
			var mesh:Object3D;
			
			var cnt:int=0;
			
			while(b.bytesAvailable)
			{
				var type:int = b.readInt();
				
				//雾
				if (type==3)
				{
					var fogColor:uint;
					
					var fogStartDistance:Number;
					var fogEndDistance:Number;
					
					fogColor = b.readUnsignedInt();
					
					fogStartDistance = b.readFloat();
					fogEndDistance = b.readFloat();
					
					var fog:Fog  = new Fog();
					fog.color = fogColor;
					fog.minDistance = fogStartDistance;
					fog.maxDistance = fogEndDistance;
					
					_mainView.scene.fog = fog;
					_mainView.far = fogEndDistance;
					continue;
				}
				
				var lenName:int = b.readInt();
				var meshFileName:String = b.readMultiByte(lenName, ".936");
				var rawData:Vector.<Number> = new Vector.<Number>();
				var newRawData:Vector.<Number>;
				
				
				//地形
				if (type==1)
				{
					for (i=0;i<10;i++)
					{
						rawData.push(b.readFloat());
					}
					
					loadTerrain(name);
					_terrain.x = rawData[0]*scaleUnityToM3D;
					_terrain.y = rawData[1]*scaleUnityToM3D;
					_terrain.z = rawData[2]*scaleUnityToM3D;
					
					_mainView.scene.addChild(_terrain);
				}
				else if (type==2) //mesh
				{
					// pos rot scale
					for (i=0;i<10;i++)
					{
						rawData.push(b.readFloat());
					}
					
					var quat:Quaternion = new Quaternion(rawData[3], rawData[4], rawData[5], rawData[6]);
					var quatMatrix:Matrix3D = quat.toMatrix3D();
					var vecs:Vector.<Vector3D> = quatMatrix.decompose();
					
					var mat:Array = [];
					mat.push(rawData[0]);
					mat.push(rawData[1]);
					mat.push(rawData[2]);
					mat.push(vecs[1].x);
					mat.push(vecs[1].y);
					mat.push(vecs[1].z);
					mat.push(rawData[7]);
					mat.push(rawData[8]);
					mat.push(rawData[9]);
					
					// 是否有uv 光线阴影图
					var flagUV:Boolean = b.readUnsignedByte();
					if (flagUV)
					{
						var uvLightMapName:String = b.readUTF();
						var lum:Number = b.readFloat();
						var scaleU:Number = b.readFloat();
						var scaleV:Number = b.readFloat();
						var offsetU:Number = b.readFloat();
						var offsetV:Number = b.readFloat();

						mat.push(name + uvLightMapName);
						mat.push(lum);
						mat.push(scaleU);
						mat.push(scaleV);
						mat.push(offsetU);
						mat.push(offsetV);
						
						MeshManager.loadMesh(meshFileName,new AsyncHandler(staticEntityCb,[mat]));
					}
					else
					{
						MeshManager.loadMesh(meshFileName,new AsyncHandler(staticEntityCb,[mat]));
					}
				}
			}
		}
		
		private static var btCol:Array=[];
		private static var logicWidth:int;
		private static var logicHeight:int;
		private static function readMapo(mapo:String):void
		{
			//trace(mapo);
			var btmapo:ByteArray;
			btmapo= File.readByteArray(mapo);
			btmapo.endian = Endian.LITTLE_ENDIAN;
			var len:int=btmapo.length;
			var vernum:int = btmapo.readUnsignedShort();// vernum
			logicWidth=btmapo.readUnsignedShort();// groundwidth
			logicHeight=btmapo.readUnsignedShort();// groundheigh
			logicWidth=btmapo.readUnsignedShort();//logicwidth
			logicHeight=btmapo.readUnsignedShort();//logicheigh;
			//trace(logicWidth, logicHeight);
			btmapo.readUnsignedByte(); // dir
			
			
			var size:int = btmapo.readInt();
			var j:int = 0;
			
			while (size > 0)
			{
				var b:int = btmapo.readUnsignedByte();
				var l:int = btmapo.readUnsignedByte();
				while (l > 0)
				{
					btCol[j++] = b;
					l--;
				}
				size=size-2;
			}
		}
		
		private static function staticEntityCb(pos:Array,mesh:Mesh):void
		{
			if (pos) {
				mesh.x=pos[0];
				mesh.y=pos[1];
				mesh.z=pos[2];
				
				mesh.scaleX=pos[6];
				mesh.scaleY=pos[7];
				mesh.scaleZ=pos[8];
				
				mesh.rotationX=pos[3];
				mesh.rotationY=pos[4];
				mesh.rotationZ=pos[5];
			}
			
			if (pos.length > 9)
			{
				var dMat:Material;// = MaterialManager.cloneMaterial(name);
				var dTex:Texture = TextureManager.getTexture(pos[9], true);
				//dMat.luminance = pos[10];
				var uvMatrixLightmap:UVMatrix = new UVMatrix();
				uvMatrixLightmap.scaleU = pos[11];
				uvMatrixLightmap.scaleV = pos[12];
				uvMatrixLightmap.offsetU = pos[13];
				uvMatrixLightmap.offsetV = pos[14];
				
				//trace(";;;",uvMatrixLightmap.scaleU,uvMatrixLightmap.scaleV, uvMatrixLightmap.offsetU, uvMatrixLightmap.offsetV)
				
				//dMat.uv2Matrix = uvMatrixLightmap;
				// 70 561 
				var iSub:int = 0;
				for (iSub=0;iSub<mesh.subMeshes.length;iSub++)
				{
					dMat = MaterialManager.cloneMaterial(mesh.subMeshes[iSub].material.name);
					dMat.lightMap = dTex;
					dMat.uv2Matrix = uvMatrixLightmap;
					dMat.luminance = pos[10];
					mesh.subMeshes[iSub].material = dMat;
					//trace(iSub);
				}
			}
			_mainView.scene.addChild(mesh);
		}
		
		private static var xblock:int = 7;
		private static var zblock:int = 7;
		private static var xblockW:Number = 300;
		private static var zblockH:Number = 300;
		private static var uvScale:int = 1;
		private static var m3dTerW:int;
		private static var m3dTerH:int;
		private static var parsedHeight:Boolean = false;
		private static var terrainHeight:Array;
		private static var scaleUnityToM3D:int = 1;// unity单 位为米，m3d单位为厘米 
		
		private static var brushNames:Vector.<Texture> = new Vector.<Texture>();
		
		/**
		 * 加载 地形
		 * @param name
		 * 
		 */		
		private static function loadTerrain(name:String):void{
			parseHeight(terrianPath + name + MARK_UNITY_NAV);
			
			var b:ByteArray=File.readByteArray(terrianPath + name + MARK_TERRIAN_CFG);
			b.endian=Endian.LITTLE_ENDIAN;
			xblock = b.readInt();
			zblock = b.readInt();
			uvScale = b.readInt();
			xblockW = b.readFloat() * scaleUnityToM3D;
			zblockH = b.readFloat() * scaleUnityToM3D;
			
			var m3dverts:int = b.readInt();
			var m3dLightWeight:Number = b.readFloat();
			
			var lenBrushNames:int = b.readUnsignedByte();
			var texName:String;
			while(lenBrushNames--)
			{
				texName = b.readUTF();
				brushNames.push(TextureManager.getTexture(texName));	
			}
			
			_terrain=new BlendTerrain(new Material(null));
			
			_terrain.UVScale=uvScale;
			_terrain.material.luminance = m3dLightWeight;
			for (var i:int=0;i<zblock;i++) {
				for (var j:int=0;j<xblock;j++) {
					var tb:BlendTerrainBlock=new BlendTerrainBlock();
					tb.x=j*xblockW;
					tb.z=i*zblockH;
					tb.lightMap=new Texture(
						TextureData.createWithFile((terrianPath + name +"_lightMap_"+i+"_"+j+".png")));
					tb.lightMap.repeat=false;
					
					// 加载混合图.用到的图id, 以及ng数据
					parseBlendMap(tb,name + "_blendMap_"+i+"_"+j);
					
					tb.geometry=parseGeo(name +"_unity_"+i+"_"+j, i, j);
					
					_terrain.addChild(tb);
				}
			}
		}
		private static function parseHeight(path:String):void
		{
			var b:ByteArray=File.readByteArray(path);
			b.endian = Endian.LITTLE_ENDIAN;
			m3dTerW  = b.readInt();
			m3dTerH = b.readInt();
			//trace(m3dTerW, m3dTerH);
			
			terrainHeight=[];
			for (var ii:int=0;ii<m3dTerH;ii++)
				terrainHeight[ii]=[];
			
			var x:int;
			var z:int;
			var height:Number;
			
			for (z = 0; z < m3dTerH; z++)
			{
				for (x = 0; x < m3dTerW; x++)
				{
					height = b.readFloat();
					terrainHeight[z][x] = height;
				}
			}
			
			parsedHeight = true;
		}
		
		private static function parseBlendMap(tb:BlendTerrainBlock, blendmapName:String):void
		{
			var pureColorTex:Texture = new Texture(TextureData.createRGB(1, 1, true, 0x000000));
			var b:ByteArray=File.readByteArray(terrianPath + blendmapName + ".blend");
			b.endian = Endian.LITTLE_ENDIAN;
			var len:int = b.readUnsignedByte(); // 有几个画刷图[1-4]
			var idBrushName:int;
			tb.brushA = pureColorTex;
			tb.brushR = pureColorTex;
			tb.brushG = pureColorTex;
			tb.brushB = pureColorTex;
			if (len&2)
			{
				idBrushName = b.readUnsignedByte();
				tb.brushA=brushNames[idBrushName];
			}
			if (len&4)
			{
				
				idBrushName = b.readUnsignedByte();
				tb.brushR=brushNames[idBrushName];
			}
			if (len&8)
			{
				
				idBrushName = b.readUnsignedByte();
				tb.brushG=brushNames[idBrushName];
			}
			if (len&16)
			{
				
				idBrushName = b.readUnsignedByte();
				tb.brushB=brushNames[idBrushName];
			}
			
			tb.blendMap =new Texture(
				TextureData.createWithFile(terrianPath + blendmapName + ".png"));
			tb.blendMap.repeat = false;
		}
		
		private static function parseGeo(name:String, blockRow:int, blockColumn:int):SubGeometry
		{
			var b:ByteArray=File.readByteArray(terrianPath + name +".geo");
			b.endian = Endian.LITTLE_ENDIAN;
			var numVertices:int = b.readInt();
			
			var numfaces:int = b.readInt();
			
			var verts:Vector.<Number> = new Vector.<Number>;
			var uvs:Vector.<Number> = new Vector.<Number>;
			var indexs:Vector.<uint> = new Vector.<uint>;
			
			for (var iVertice:int = 0; iVertice<numVertices; iVertice++)
			{
				var x : Number = b.readFloat() * scaleUnityToM3D;
				var y : Number = b.readFloat() * scaleUnityToM3D;
				var z : Number = b.readFloat() * scaleUnityToM3D;
				var u : Number = b.readFloat();
				var v : Number = b.readFloat();
				verts.push(x);
				verts.push(y);
				verts.push(z);
				uvs.push(u);
				uvs.push(v);
			}
			for (var ifaces:int = 0; ifaces<numfaces; ifaces++)
			{
				var v0:int = b.readUnsignedShort();
				var v1:int = b.readUnsignedShort();
				var v2:int = b.readUnsignedShort();
				indexs.push(v0);
				indexs.push(v1);
				indexs.push(v2);
				
			}
			
			var geo:SubGeometry=new SubGeometry();
			geo.updateIndexData(indexs);
			geo.updateVertexData(verts);
			geo.updateUVData(uvs);
			
			return geo;
		}
	}
}
