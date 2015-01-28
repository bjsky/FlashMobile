package potato.display3d.data
{
	public class EffectData
	{
		public function EffectData()
		{
			super();
		}
		/**效果名字*/
		public var effectName:String;
		/**效果存活时间（ms）*/
		public var lifeTime:int;
		
		/**
		 * 子元素 
		 */		
		public var effectElemDataArr:Vector.<ElemData>=new Vector.<ElemData>();
		/**
		 * 脚本 
		 */		
		public var behaviourArr:Vector.<BehaviourData>=new Vector.<BehaviourData>();
		
	}
}