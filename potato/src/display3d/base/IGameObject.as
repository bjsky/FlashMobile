package potato.display3d.base
{
	/**
	 * 游戏对象接口
	 * @author liuxin
	 * 
	 */
	public interface IGameObject
	{
		
		/**
		 * 添加控制器
		 * @param name 控制器名称
		 * @param value 控制器
		 * 
		 */
		function addGameController(name:String,value:Object):void;
		
		/**
		 * 移除控制器
		 * @param name 控制器名称
		 * 
		 */
		function removeGameController(name:String):void;
		
		/**
		 * 获取控制器
		 * @param name 控制器名称
		 * @return 
		 * 
		 */
		function getGameController(name:String):Object;
	}
}