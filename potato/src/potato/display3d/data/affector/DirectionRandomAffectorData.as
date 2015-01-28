package potato.display3d.data.affector
{
	import core.effects.DirectionRandomAffector;
	import core.effects.ParticleAffector;
	
	import potato.display3d.data.AffectorData;
	
	public class DirectionRandomAffectorData extends AffectorData
	{
		public function DirectionRandomAffectorData()
		{
			super();
		}
		
		public var keepVelocity:Boolean=false;
		public var randomness:Number=0;
		public var scope:Number=0;
		
		override public function newAffector():ParticleAffector
		{
			var a:DirectionRandomAffector=new DirectionRandomAffector();
			setAffector(a);
			return a;
		}
		override public function setAffector(pa:ParticleAffector):void
		{
			super.setAffector(pa);
			DirectionRandomAffector(pa).keepVelocity=keepVelocity;
			DirectionRandomAffector(pa).randomness=randomness;
			DirectionRandomAffector(pa).scope=scope;
		}
	}
}