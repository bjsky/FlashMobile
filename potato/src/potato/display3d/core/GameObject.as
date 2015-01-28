package potato.display3d.core
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import core.display.DisplayObjectContainer;
	
	import potato.potato_internal;
	import potato.display3d.GameContainer;
	import potato.utils.ObjectUtil;

	/**
	 * gameObject管理器. 
	 * @author liuxin
	 * 
	 */
	public class GameObject
	{
		public function GameObject()
		{
		}
		use namespace potato_internal;
		
		/**
		 * 所以游戏对象 
		 */		
		private static var _gameObjects:Dictionary=new Dictionary();
		
		/**
		 * 启动3d管理器渲染
		 * @param main
		 * 
		 */
		public static function startup(main:DisplayObjectContainer):void{
			Time.start(main);
		}
		
		/**
		 * 关闭 
		 * 
		 */
		public static function shutdown():void{
			Time.stop();
		}
		
		
		public static function toString():String{
			return ""+ObjectUtil.countDict(_gameObjects);
		}
		/**
		 * 使用标签查找游戏对象 
		 * @param tag
		 * @return 
		 * 
		 */
		public static function findGameObjectsWithTag(tag:String):GameContainer{
			var compoents:Vector.<GameContainer>=findGameObjects(GameContainer) as Vector.<GameContainer>;
			for each(var com:GameContainer in compoents){
				if(com.tag==tag)
					return com;
			}
			return null;
		}
		
		/**
		 * 使用类型查找游戏对象 
		 * @param type
		 * @return 
		 * 
		 */
		public static function findGameObject(type:Class):IGameObject{
			var objects:Vector.<IGameObject>=findGameObjects(type);
			if(objects.length>0)
				return objects[0];
			return null;
		}
		
		/**
		 * 使用类型查找所有游戏对象 
		 * @param type
		 * @return 
		 * 
		 */		
		public static function findGameObjects(type:Class):Vector.<IGameObject>{
			var retObjects:Vector.<IGameObject>=new Vector.<IGameObject>();
			for (var obj:IGameObject in _gameObjects){
				if(obj is type)
					retObjects.push(obj);
			}
			return retObjects;
		}
		
		potato_internal static function addGameObjects(parent:IGameContainer,object:IGameObject):void{
			if(object.parentGameObject)
				object.parentGameObject.removeGameObject(object);
			//游戏对象内部处理
			Object(object)._parentGameObject=parent;
			parent.childrenGameObjects.push(object);
			
			if(!_gameObjects[object])
				_gameObjects[object]=true;
		}
		
		potato_internal static function removeGameObjects(parent:IGameContainer,object:IGameObject):void{
			if(!parent) return;
			Object(object)._parentGameObject=null;
			var index:int=parent.childrenGameObjects.indexOf(object);
			if(index>-1) 
				parent.childrenGameObjects.splice(index,1);
			
			if(_gameObjects[object])
				delete _gameObjects[object];
		}
		
		potato_internal static function getGameObject(parent:IGameContainer,type:Class):IGameObject{
			var objects:Vector.<IGameObject>=getGameObjects(parent,type);
			if(objects.length>0)
				return objects[0];
			return null;
		}
		
		potato_internal static function getGameObjects(parent:IGameContainer,type:Class):Vector.<IGameObject>{
			var retObjects:Vector.<IGameObject>=new Vector.<IGameObject>();
			for (var obj:IGameObject in parent.childrenGameObjects){
				if(obj is type)
					retObjects.push(obj);
			}
			return retObjects;
		}
	}
}