package potato.display3d.core
{
	/**
	 * 组件接口
	 * @author liuxin
	 * 
	 */
	public interface IGameContainer
		extends IGameObject
	{
		function addGameObject(object:IGameObject):void;
		function removeGameObject(object:IGameObject):void;
		
		function getGameObject(type:Class):IGameObject;
		function getGameObjects(type:Class):Vector.<IGameObject>;
		
		function get childrenGameObjects():Vector.<IGameObject>;
	}
}