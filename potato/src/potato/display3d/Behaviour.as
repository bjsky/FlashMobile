package potato.display3d
{
	import potato.potato_internal;
	import potato.display3d.core.GameObject;
	import potato.display3d.core.IGameContainer;
	import potato.display3d.core.IGameObject;

	/**
	 * 脚本基类. 
	 * @author liuxin
	 * 
	 */
	public class Behaviour extends Object
		implements IGameObject
	{
		public function Behaviour()
		{
		}
		
		use namespace potato_internal;
		
		potato_internal var _isStart:Boolean=false;
		potato_internal var _enable:Boolean=true;
		
		public function set enable(value:Boolean):void{
			_enable=value;
		}
		public function get enable():Boolean{
			return _enable;
		}
		
		/**
		 * 第一次被调用 
		 * 
		 */
		public function start():void{
			
		}
//		/**
//		 * 脚本开启 
//		 * 
//		 */
//		public function onEnable():void{
//			
//		}
		
		/**
		 * 固定时间更新(timer)
		 * 
		 */
		public function fixedUpdate():void{
			
		}
		
		/**
		 * 帧更新（enterframe） 
		 * 
		 */
		public function update():void{
			
		}
		
		/**
		 * 发生在帧更新之后 
		 * 
		 */
		public function laterUpdate():void{
			
		}
//		
//		/**
//		 * 脚本禁用 
//		 * 
//		 */
//		public function onDisable():void{
//			
//		}
//		
		
		///////////////////
		// IGameObject
		//////////////////
		private var _tag:String;
		potato_internal var _parentGameObject:IGameContainer;
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
		 * 清理 
		 * 
		 */		
		public function dispose():void{
			GameObject.removeGameObjects(parentGameObject,this);
		}
	}
}