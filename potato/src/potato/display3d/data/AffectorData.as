package potato.display3d.data
{
	import flash.utils.getQualifiedClassName;
	
	import core.effects.ParticleAffector;

	public class AffectorData
	{
		public function AffectorData()
		{
		}
		
		public function newAffector():ParticleAffector
		{
			throw new Error("newAffector not implement for "+getQualifiedClassName(this));
		}
		public function setAffector(pa:ParticleAffector):void
		{
			
		}
		
	}
}