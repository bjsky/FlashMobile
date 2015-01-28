package potato.display3d.data.affector
{
	import core.effects.ParticleAffector;
	import core.effects.ScaleAffector;
	
	import potato.display3d.data.AffectorData;
	
	public class ScaleAffectorData extends AffectorData
	{
		public function ScaleAffectorData()
		{
			super();
		}
		
		public var rate:Number=0;
		
		override public function newAffector():ParticleAffector
		{
			var a:ScaleAffector=new ScaleAffector();
			setAffector(a);
			return a;
		}
		override public function setAffector(pa:ParticleAffector):void
		{
			super.setAffector(pa);
			ScaleAffector(pa).rate=rate;
		}
		
	}
}