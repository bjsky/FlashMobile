package potato.display3d.data.behaviour
{
	import potato.display3d.data.BehaviourData;

	public class NcBillboardData extends BehaviourData
	{
		public var fUserTag:Number;
		public var bCameraLookAt:Boolean = false;
		public var bFixedObjectUp:Boolean = false;
		public var bFixedStand:Boolean = false;
		public var FrontAxis:int = 0;
		public var ratationMode:int = 0;
		public var ratationAxis:int = 0;
		public var fRotationValue:Number=0;
		
		public static function registerAlias():void
		{
			
		}
	}
}