package potato.display3d.behaviour.common
{
	public class NcEffectAniBehaviour extends NcEffectBehaviour
	{
		protected var m_Timer:NcTimerTool;
		protected var m_bEndAnimation:Boolean = false;
		public var m_OnEndAniFunction:String = "OnEndAnimation";
		
		public function IsEndAnimation():Boolean
		{
			return m_bEndAnimation;
		}
		
		protected function InitAnimationTimer():void
		{
			if(m_Timer == null)
				m_Timer = new NcTimerTool();
			m_bEndAnimation = false;
			m_Timer.Start();
		}
		
		protected function OnEndAnimation():void
		{
			m_bEndAnimation = true;
			m_Timer = null;
		}
	}
}