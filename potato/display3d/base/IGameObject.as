package potato.display3d.base
{
	/** 游戏对象接口**/
	public interface IGameObject
	{
		/** 添加控制器**/
		function addGameController(name:String,value:Object):void;
		/** 移除控制器**/
		function removeGameController(name:String):void;
		/** 获取控制器**/
		function getGameController(name:String):Object;
	}
}