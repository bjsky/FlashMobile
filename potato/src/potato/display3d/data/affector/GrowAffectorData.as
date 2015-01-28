package potato.display3d.data.affector
{
	import core.effects.GrowAffector;
	import core.effects.ParticleAffector;
	
	import potato.display3d.data.AffectorData;
	
	public class GrowAffectorData extends AffectorData
	{
		public function GrowAffectorData()
		{
			super();
		}
		
		/**
		 * 成长 
		 */
		public var grow:Number=0;
		
		override public function newAffector():ParticleAffector
		{
			var a:GrowAffector=new GrowAffector();
			setAffector(a);
			return a;
		}
		override public function setAffector(pa:ParticleAffector):void
		{
			super.setAffector(pa);
			GrowAffector(pa).grow=grow;
		}
	}
}