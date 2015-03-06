package potato.display3d
{
	import core.display3d.Object3D;
	import core.display3d.ObjectContainer3D;
	
	import potato.potato_internal;

	/**
	 * 脚本基类. 
	 * @author liuxin
	 * 
	 */
	public class Behaviour
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
		
		private var _target:Object3D;
		potato_internal function setTarget(v:Object3D):void{
			_target=v;
		}
		
		/**
		 * 附加的容器 
		 * @return 
		 * 
		 */
		public function get container():ObjectContainer3D{
			return _target as ObjectContainer3D;
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
		/**
		 * 释放引用 
		 * 
		 */		
		public function dispose():void{
			_target=null;
		}
	}
}