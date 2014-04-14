package potato.display3d.base
{
	import flash.utils.Dictionary;
	
	import core.display3d.ObjectContainer3D;

	/** 3d游戏对象，适应u3d开发方式（可以理解为实体和行为集合）
	 *  @author liuxin
	 *  @date 2014.3.11
	 * **/
	public class GameObject extends ObjectContainer3D implements IGameObject
	{
		public function GameObject()
		{
		}
		/**控制器字典**/
		protected var controllerDic:Dictionary=new Dictionary();
		
		public function addGameController(name:String,controller:Object):void{
			removeGameController(name);
			controllerDic[name]=controller;
			controller.gameObj=this;
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
			for(var key:String in controllerDic){
				removeGameController(key);
			}
			controllerDic=null;
		}
	}
}