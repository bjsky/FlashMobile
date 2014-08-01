package  potato.display3d.data
{
	import flash.net.registerClassAlias;

	public class SkillData
	{
		public static function registerAlias():void
		{
			registerClassAlias("potato.effect3d.bean.SkillData",SkillData);
		}
		
		////////////////////////////basic info//////////////////////////////
		/**技能名*/
		public var skillName:String;
		/**施法者技能动作*/
		public var actionName:String;
		/**施法者技能效果*/
		public var effectName:String;
		/**施法者技能绑定点*/
		public var attachPoint:String;
		/**声音*/
		public var soundName:String;
		
		////////////////////////////bullet/////////////////////////////
		//子弹最多有2个效果组成；
		/**子弹名字，做调试用*/
		public var bulletName:String;
		/**时间到后自动清除子弹*/
		public var bulletMaxTime:int;
		/**飞行效果开始时间(ms),默认0，即表示马上开始*/
		public var bulletBirthTime:int=0;
		/**子弹结束绑定点*/
		public var bulletAttachPoint:String;
		/**子弹事件1效果，效果1为子弹追踪阶段；效果2为子弹追踪到目标后的阶段，比如释放新的效果等等；*/
		public var bulletEvt1EffectName:String;
		/**子弹事件2效果，默认null*/
		public var bulletEvt2EffectName:String=null;
		/**是否定位0否 1是*/
		public var bulletPursuitType:int;
		/**飞行速度*/
		public var bulletPursuitSpeed:Number;
		/**与目标点多少距离以内算是到达，默认20厘米*/
		public var bulletArriveDistance:int=20;
		/**
		 *子弹结束后有最后的效果显示，该效果是否绑定到目标身上（绑上的话，效果会跟随目前而移动）; 
		 */
		public var isBulletEndEffectAttachToTarget:Boolean=true;
		
		
		public function SkillData()
		{
		}
	}
}