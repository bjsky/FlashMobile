package potato.display3d.data.behaviour
{
	import potato.display3d.data.BehaviourData;

	public class NcCurveAnimationData extends BehaviourData
	{
		public static function registerAlias():void
		{
//			registerClassAlias();
		}
		
		public var m_fUserTag:Number;
		public var m_fDelayTime:Number = 0;
		public var m_fDurationTime:Number = 0.6;
		public var m_bAutoDestruct:Boolean = true;
		public var m_CurveInfoList:Array = [];//NcInfoCurveData数组
	}
}