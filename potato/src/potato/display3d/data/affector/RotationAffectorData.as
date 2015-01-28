package potato.display3d.data.affector
{
	import core.effects.ParticleAffector;
	import core.effects.RotationAffector;
	
	import potato.display3d.data.AffectorData;
	
	public class RotationAffectorData extends AffectorData
	{
		public function RotationAffectorData()
		{
			super();
		}
		public var rotationEnd:Number=0;
		public var rotationSpeedEnd:Number=0;
		public var rotationSpeedStart:Number=0;
		public var rotationStart:Number=0;
		
		override public function newAffector():ParticleAffector
		{
			var a:RotationAffector=new RotationAffector();
			setAffector(a);
			return a;
		}
		override public function setAffector(pa:ParticleAffector):void
		{
			super.setAffector(pa);
			RotationAffector(pa).rotationEnd=rotationEnd;
			RotationAffector(pa).rotationSpeedEnd=rotationSpeedEnd;
			RotationAffector(pa).rotationSpeedStart=rotationSpeedStart;
			RotationAffector(pa).rotationStart=rotationStart;
		}
	}
}