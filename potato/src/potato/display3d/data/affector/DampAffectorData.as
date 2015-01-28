package potato.display3d.data.affector
{
	import core.effects.DampAffector;
	import core.effects.ParticleAffector;
	
	import potato.display3d.data.AffectorData;
	
	public class DampAffectorData extends AffectorData
	{
		public function DampAffectorData()
		{
			super();
		}
		
		/**
		 * 阻尼系数 
		 */
		public var damp:Number=1;
		
		override public function newAffector():ParticleAffector
		{
			var a:DampAffector=new DampAffector();
			setAffector(a);
			return a;
		}
		override public function setAffector(pa:ParticleAffector):void
		{
			super.setAffector(pa);
			DampAffector(pa).damp=damp;
		}
	}
}