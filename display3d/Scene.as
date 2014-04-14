package potato.display3d
{
	import flash.utils.Dictionary;
	
	import core.display3d.ObjectContainer3D;
	import core.display3d.View3D;
	import core.terrain.TileTerrain;
	
	import potato.display3d.base.IGameObject;
	import potato.display3d.controller.camera.AbstractCameraController;
	import potato.display3d.controller.camera.HoverCameraController;
	import potato.display3d.controller.load.AbstractLoadController;
	import potato.display3d.controller.load.CommonLoadController;
	import potato.display3d.event.ResourceEvent;
	import potato.display3d.resource.TerrainResource;
	
	/** 场景类
	 *  author:liuxin
	 *  date:2014.3.17**/
	public class Scene extends View3D implements IGameObject
	{
		public function Scene()
		{
			initialize();
		}
		
		private var _cameraController:AbstractCameraController;	
		private var _loadController:AbstractLoadController;
		
		protected var _terrain:ObjectContainer3D;
		
		/** 地形**/
		public function get terrain():ObjectContainer3D{
			return _terrain;
		}
		public function set terrain(value:ObjectContainer3D):void{
			if(_terrain){	//移除地形
				if(_terrain.parent && _terrain.parent==scene){
					scene.removeChild(_terrain);
				}
				_terrain.dispose();
			}
			if(value){
				_terrain=value;
				scene.addChild(_terrain);
			}
		}
		
		/** 默认相机**/
		public function get cameraController():AbstractCameraController{
			return _cameraController;
		}
		
		public function get loadController():AbstractLoadController{
			return _loadController;	
		}
		public function set loadController(value:AbstractLoadController):void{
			_loadController=value;
		}
		
		/** 初始化**/
		private function initialize():void{
			//默认控制器 
			_cameraController=new HoverCameraController(camera);		//悬停相机
			_loadController=new CommonLoadController(true);		//默认加载器
		}
		
		/**
		 * 加载场景 
		 * @param scenePath 场景配置文件路径，为空加载默认场景
		 * 
		 */		
		public function loadScene(scenePath:String):void{
			if(scenePath!=""){
				var terRes:TerrainResource=new TerrainResource(scenePath);
				terRes.addEventListener(ResourceEvent.TERRAIN_COMPLETE,onTerrainLoaded);
				loadController.load(terRes);
			}else{ //默认场景
				terrain=new Coordinate3D();
				loadedSetCamera();
			}
		}
		
		//地形加载完成设置相机
		private function onTerrainLoaded(e:ResourceEvent):void{
			var res:TerrainResource=e.currentTarget as TerrainResource;
			res.removeEventListener(ResourceEvent.TERRAIN_COMPLETE,onTerrainLoaded);
			
			terrain=e.resource as TileTerrain;
			
			loadedSetCamera();
		}
		
		private function loadedSetCamera():void{
			var camera:HoverCameraController=cameraController as HoverCameraController;
			camera.tiltAngle=18;
			camera.panAngle=0;
			camera.distance=1000;
			//观察圆点
			var lo:ObjectContainer3D=new ObjectContainer3D();
			lo.x=0;
			lo.z=0;
			if(terrain is TileTerrain){
				var tt:TileTerrain=terrain as TileTerrain;
				lo.y=tt.getHeightAt(lo.x,lo.z);
			}
			camera.lookAtObject=lo;
		}
		
		/**控制器字典**/
		protected var controllerDic:Dictionary=new Dictionary();
		public function addGameController(name:String,controller:Object):void{
			removeGameController(name);
			controllerDic[name]=controller;
		}
		public function removeGameController(name:String):void{
			if(controllerDic[name]){
				delete controllerDic[name];
			}
		}		
		public function getGameController(name:String):Object{
			if(controllerDic[name])
				return controllerDic[name] as Object;
			else
				return null;
		}
		
		override public function dispose():void{
			super.dispose();
			_terrain.dispose();
		}
	}
}