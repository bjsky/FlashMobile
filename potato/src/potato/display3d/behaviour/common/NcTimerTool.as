package potato.display3d.behaviour.common
{
	import potato.display3d.core.Time;

	public class NcTimerTool
	{
		protected var m_bEnable:Boolean;
		private var m_fLastEngineTime:Number = 0;
		private var m_fCurrentTime:Number;
		private var m_fLastTime:Number = 0;
		private var m_fTimeScale:Number = 1;
		
		private var m_fSmoothTimes:Array = null;
		private var m_fLastSmoothDeltaTime:Number;
		
		public static function GetEngineTime():Number
		{
			if (Time.time == 0)
				return 0.000001;
			return Time.time / 1000;
		}
		
		private function UpdateSmoothTime(fDeltaTime:Number):Number
		{
			return m_fLastSmoothDeltaTime;
		}
		
		private function UpdateTimer():Number
		{
			if(m_bEnable){
				if(m_fLastEngineTime != GetEngineTime()){
					m_fLastTime = m_fCurrentTime;
					m_fCurrentTime += (GetEngineTime() - m_fLastEngineTime) * GetTimeScale();
					m_fLastEngineTime = GetEngineTime();
					if(m_fSmoothTimes != null)
						UpdateSmoothTime(m_fCurrentTime - m_fLastTime);
				}
			}else{
				m_fLastEngineTime = GetEngineTime();
			}
			return m_fCurrentTime;
		}
		public function GetTime():Number
		{
			return UpdateTimer();
		}
		public function GetDeltaTime():Number
		{
			if(m_bEnable){
				UpdateTimer();
				return m_fCurrentTime - m_fLastTime;
			}
			return 0;
		}
		
		public function Start():void
		{
			m_bEnable = true;
			m_fCurrentTime = 0;
			m_fLastEngineTime = GetEngineTime() - 0.000001;
			UpdateTimer();
		}
		
		protected function GetTimeScale():Number
		{
			return m_fTimeScale;
		}
	}
}