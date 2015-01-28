package potato.display3d
{
	import core.display3d.Object3D;
	import core.display3d.ObjectContainer3D;
	
	import potato.potato_internal;
	import potato.display3d.core.GameObject;
	import potato.display3d.core.IGameContainer;
	import potato.display3d.core.IGameObject;
	
	/**
	 * 空容器 
	 * @author liuxin
	 * 
	 */
	public class GameContainer extends ObjectContainer3D
		implements IGameContainer
	{
		public function GameContainer()
		{
			super();
		}
		use namespace potato_internal;
		
		
		/////////////////////////////////
		// children override 
		//////////////////////////////////
		override public function addChild(child:Object3D):Object3D{
			var c:Object3D=super.addChild(child);
			if(c is IGameObject)
				addGameObject(IGameObject(c));
			return c;
		}
		
		override public function removeChild(child:Object3D):Object3D{
			var c:Object3D=super.removeChild(child);
			if(c is IGameObject)
				removeGameObject(IGameObject(c));
			return c;
		}
		
		///////////////////
		// IMuComponent
		//////////////////
		private var _tag:String;
		potato_internal var _parentGameObject:IGameContainer;
		potato_internal var _childrenGameObjects:Vector.<IGameObject>=new Vector.<IGameObject>();
		/**
		 * 标签 
		 * @param name
		 * 
		 */		
		public function set tag(name:String):void{
			_tag=name;
		}
		
		public function get tag():String{
			return _tag;
		}
		
		/**
		 * 父游戏对象 
		 * @return 
		 * 
		 */
		public function get parentGameObject():IGameContainer
		{
			return _parentGameObject;
		}
		
		/**
		 * 添加子游戏对象
		 * @param object
		 * 
		 */
		public function addGameObject(object:IGameObject):void
		{
			GameObject.addGameObjects(this,object);
		}
		
		/**
		 * 移除子游戏对象
		 * @param object
		 * 
		 */
		public function removeGameObject(object:IGameObject):void
		{
			GameObject.removeGameObjects(this,object);
		}
		
		/**
		 * 获取该类型的第一个子游戏对象
		 * @param object
		 * 
		 */
		public function getGameObject(type:Class):IGameObject
		{
			return GameObject.getGameObject(this,type);
		}
		
		/**
		 * 获取该类型的所有子游戏对象
		 * @param object
		 * 
		 */
		public function getGameObjects(type:Class):Vector.<IGameObject>
		{
			return GameObject.getGameObjects(this,type);
		}
		
		/**
		 * 子游戏对象 
		 * @return 
		 * 
		 */
		public function get childrenGameObjects():Vector.<IGameObject>{
			return _childrenGameObjects;
		}
		
		override public function dispose():void{
			super.dispose();
			
			GameObject.removeGameObjects(parentGameObject,this);
		}
	}
}