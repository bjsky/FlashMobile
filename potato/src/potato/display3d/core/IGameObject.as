package potato.display3d.core
{
	
	/**
	 * 游戏对象接口 
	 * @author liuxin
	 * 
	 */
	public interface IGameObject
	{
		function get parentGameObject():IGameContainer;

		function set tag(name:String):void;
		function get tag():String;

		function dispose():void;
	}
}