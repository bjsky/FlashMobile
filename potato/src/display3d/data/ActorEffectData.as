package potato.display3d.data
{
	import flash.net.registerClassAlias;

	public class ActorEffectData
	{
		/*
		<Effects>
			<Effect name="glow" effect="eft_02"  locator="bodycenter" translateAll="false"/>
		</Effects>
		*/
		
		public var name:String;
		public var effect:String;
		public var locator:String;
//		public var translateAll:Boolean;
		
		public function ActorEffectData()
		{
		}
		
		public static function registerAlias():void
		{
			registerClassAlias("potato.mirage3d.data.ActorEffectData",ActorEffectData);
		}
	}
}