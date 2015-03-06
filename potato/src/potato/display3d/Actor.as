package potato.display3d
{
	import core.display3d.Mesh;
	import core.display3d.ObjectContainer3D;
	import core.display3d.Skin;
	
	import potato.display3d.async.AsyncHandler;
	import potato.display3d.core.MeshManager;
	import potato.display3d.core.SceneManager;
	import potato.display3d.data.ActorData;
	import potato.display3d.data.ActorMountData;
	
	/**
	 * 角色 
	 * @author liuxin
	 * 
	 */
	public class Actor extends ObjectContainer3D
	{
		public function Actor()
		{
			super();
		}
		
		private var _skin:Skin;
		private var _loaded:Boolean = false;
		
		private var _data:ActorData;
		private var _loadMountCount:int=0;
		
		public function initWithData(data:ActorData):void{
			_data = data;
			MeshManager.loadMesh(_data.mainSkinName, new AsyncHandler(skinHandler));
			this.addEventListener(ActorEvent.LOADCOMPLETE,loadCompleteHandler);
		}
		
		private function loadCompleteHandler(e:ActorEvent):void
		{
			_skin.play(_data.defaultClipName);
		}
		
		private function skinHandler(skin:Skin):void
		{
			_skin = skin;
			_skin.rotationY=180;
			this.addChild(_skin);
			_skin.scale(0.01);
			for each(var name:String in _data.loopClipNames){
				_skin.clipSet.getClipByName(name).looping = true;
			}
			//挂载
			for each(var mountdata:ActorMountData in _data.mounts){
				attachToLocatorWithName(mountdata.boneName,mountdata.meshName);
			}
		}
		
		/**
		 * 在骨骼上挂载mesh 
		 * @param boneName
		 * @param meshName
		 * 
		 */
		public function attachToLocatorWithName(boneName:String,meshName:String):void{
			MeshManager.loadMesh(meshName , new AsyncHandler(mountHandler,[boneName]));
		}
		
		private function mountHandler(boneName:String,mesh:Mesh):void
		{
			_skin.addChild(mesh);
			_skin.attachChildToBone(boneName, mesh);
			
			_loadMountCount++;
			if(_loadMountCount == _data.mounts.length){
				_loaded = true;
				this.dispatchEvent(new ActorEvent(ActorEvent.LOADCOMPLETE));
			}
		}
		
		private var _curClipName:String;
		/**
		 * 播放动画 
		 * @param clipName
		 * 
		 */
		public function play(clipName:String):void{
			if(!_loaded) return;
			if(clipName != _curClipName){
				_skin.play(clipName);
				_curClipName=clipName;
			}
		}
		
		/**
		 * 地形上向前移动 
		 * @param distance
		 * 
		 */
		public function moveForwardTerrian(distance:Number):void{
			var prex:Number = x;
			var prez:Number = z;
			var prey:Number = y;
			this.moveForward(distance);
			this.y=SceneManager.getHeight(x,z);
			var walkable:Boolean=SceneManager.isWalkable(x,z);
			if(!walkable){
				x = prex;
				z = prez;
				y =prey;
			}
		}
		
		/**
		 * 地形上向后移动 
		 * @param distance
		 * 
		 */
		public function moveBackwardTerrian(distance:Number):void{
			var prex:Number = x;
			var prez:Number = z;
			var prey:Number = y;
			this.moveBackward(distance);
			this.y=SceneManager.getHeight(x,z);
			var walkable:Boolean=SceneManager.isWalkable(x,z);
			if(!walkable){
				x = prex;
				z = prez;
				y =prey;
			}
		}
		
		/**
		 * 移动 
		 * @param dx
		 * @param dz
		 * 
		 */
		public function move(dx:Number,dz:Number):void{
			var walkable:Boolean=SceneManager.isWalkable(x+dx,z+dz);
			if(walkable){
				this.x=x+dx;
				this.z=z+dz;
				this.y=SceneManager.getHeight(x,z);
			}
		}
	}
}