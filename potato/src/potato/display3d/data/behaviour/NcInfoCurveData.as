package potato.display3d.data.behaviour
{
	public class NcInfoCurveData
	{
		public static function registerAlias():void
		{
			
		}
		public var m_bEnabled:Boolean = true;
		public var m_CurveName:String = "";
		public var m_AniCurve:AnimationCurveData = new AnimationCurveData();
		public var m_ApplyType:String = "POSITION";
		public var m_bApplyOption:Array = [false, true, false, false];
		
		public var m_bRecursively:Boolean = false;
		public var m_fValueScale:Number = 1.0;
		public var m_FromColor:Array = [1,1,1,1];//RGBA4个值
		public var m_ToColor:Array = [1,1,1,1];//RGBA4个值
	}
}