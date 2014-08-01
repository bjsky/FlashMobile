package potato.display3d.data
{
	import flash.net.registerClassAlias;

	/**
	 * 效果数据里面可能包含不限于1个的粒子数据，这些数据放在effectElemDataArr数组里面； 
	 * 字段lifeTime是整个效果的持续时间，并非其中某一个粒子系统的持续时间，
	 * 单个粒子系统的时间在EffectElemData结构体里面保存；
	 * @author win7
	 * 
	 */
	public class EffectData
	{
		public static function registerAlias():void
		{
			registerClassAlias("potato.effect3d.bean.EffectData",EffectData);
		}
		
		/**效果名字*/
		public var effectName:String;
		/**效果存活时间（ms）*/
		public var lifeTime:int;
		/**效果数据*/
		public var effectElemDataArr:Array=[];
		
		public function EffectData()
		{
		}
	}
}