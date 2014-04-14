package potato.display3d.resource
{
	/**
	 * 资源接口
	 * @author win7
	 * 
	 */
	public interface IResource
	{
		/** 资源路径**/
		function get path():String;
		function set path(value:String):void
			
		/** 加载处理中传递的参数**/
		function get args():Array;
		function set args(value:Array):void
			
		/** 加载**/
		function load():void
		
		/** 资源对象**/
		function get data():Object;
	}
}