package potato.display3d.data.behaviour
{
	import potato.display3d.data.BehaviourData;

	public class NcUvAnimationData extends BehaviourData
	{
		public static function registerAlias():void
		{
			
		}
		
		public var m_fUserTag:Number=0;
		public var m_fScrollSpeedX:Number = 1.0;
		public var m_fScrollSpeedY:Number = 0.0;
		public var m_fTilingX:Number = 1;
		public var m_fTilingY:Number = 1;
		public var m_fOffsetX:Number = 0;
		public var m_fOffsetY:Number = 0;
		//以下数据暂未使用，如效果需要，请修改
		public var m_bUseSmoothDeltaTime:Boolean = false;
		public var m_bFixedTileSize:Boolean = false;
		public var m_bRepeat:Boolean = true;
		public var m_bAutoDestruct:Boolean = false;
	}
}