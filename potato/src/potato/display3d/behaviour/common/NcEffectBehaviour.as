package potato.display3d.behaviour.common
{
	import potato.display3d.Behaviour;
	import potato.display3d.core.Time;

	public class NcEffectBehaviour extends Behaviour
	{
		private static var m_bShuttingDown:Boolean = false;
		
		public var m_fUserTag:Number;
		
		public function NcEffectBehaviour()
		{
			
		}
		
		/**
		 * 单位为秒
		 */
		public static function GetEngineTime():Number
		{
			if(Time.time == 0)
				return 0.000001;
			return Time.time / 1000;
		}
		/**
		 * 单位为秒
		 */
		public static function GetEngineDeltaTime():Number
		{
			return Time.deltaTime / 1000;
		}
		public static function IsSafe():Boolean
		{
			return !m_bShuttingDown;
		}
		
		/**
		 * 1 = ing, 0 = stop, -1 = none
		 */
		public function GetAnimationState():int
		{
			return -1;
		}
		//显示对象销毁时所有脚本调用销毁函数
		protected function OnDestroy():void
		{
			
		}
		public function OnApplicationQuit():void
		{
			m_bShuttingDown = true;
		}
		public function OnUpdateEffectSpeed(fSpeedRate:Number, bRuntime:Boolean):void
		{
		}
		
		public function OnUpdateToolData():void
		{
		}
	}
}