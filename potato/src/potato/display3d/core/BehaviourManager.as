package potato.display3d.core
{
	import flash.utils.Dictionary;
	
	import core.display.DisplayObjectContainer;
	import core.display3d.Object3D;
	
	import potato.potato_internal;
	import potato.display3d.Behaviour;

	/**
	 * 脚本管理器，存储所有对象上的挂载脚本 
	 * @author liuxin
	 * 
	 */
	public class BehaviourManager
	{
		public function BehaviourManager()
		{
		}
		use namespace potato_internal;
		
		/**
		 * 脚本字典
		 */
		private static var _objectBehaviours:Dictionary=new Dictionary();
		
		/**
		 * 脚本启动 
		 * @param main
		 * 
		 */
		public static function startup(main:DisplayObjectContainer):void{
			Time.start(main);
		}
		
		/**
		 * 脚本停止 
		 * 
		 */
		public static function stop():void{
			Time.stop();
		}
		
		/**
		 * 所有脚本数组
		 * @return 
		 * 
		 */
		public static function get behaviours():Vector.<Behaviour>
		{
			var behaivours:Vector.<Behaviour>=new Vector.<Behaviour>();
			for each(var bhs:Vector.<Behaviour> in _objectBehaviours){
				if(bhs)
					behaivours = behaivours.concat(bhs);
			}
			return behaivours;
		}
		
		
		/**
		 * 获取附加在对象上的脚本 
		 * @param object
		 * @return 
		 * 
		 */
		public static function getBehaviours(object:Object3D):Vector.<Behaviour>{
			return _objectBehaviours[object];
		}
		
		/**
		 * 获取附加在对象上某类型的脚本  
		 * @param object
		 * @param type
		 * @return 
		 * 
		 */
		public static function getBehaviour(object:Object3D,type:Class):Behaviour{
			var behaviours:Vector.<Behaviour>=getBehaviours(object);
			for each(var behaviour:Behaviour in behaviours){
				if(behaviour is type)
					return behaviour;
			}
			return null;
		}
		
		potato_internal static function cacheBehaviours(object:Object3D,behaviours:Vector.<Behaviour>):void{
			_objectBehaviours[object]=behaviours;
		}
		
		potato_internal static function disposeBehaviours(object:Object3D):void{
			if(_objectBehaviours[object]){
				var behaviours:Vector.<Behaviour>=_objectBehaviours[object];
				for each(var behaviour:Behaviour in behaviours){
					behaviour.dispose();
					behaviour=null;
				}
				delete _objectBehaviours[object];
			}
		}
	}
}