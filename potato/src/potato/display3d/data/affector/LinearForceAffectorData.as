package potato.display3d.data.affector
{
	import core.display3d.Vector3D;
	import core.effects.LinearForceAffector;
	import core.effects.ParticleAffector;
	
	import potato.display3d.data.AffectorData;
	
	public class LinearForceAffectorData extends AffectorData
	{
		public function LinearForceAffectorData()
		{
			super();
		}
		
		public var app:Number=0;
		public var force:Vector3D=new Vector3D(0, -100, 0);
		
		override public function newAffector():ParticleAffector
		{
			var a:LinearForceAffector=new LinearForceAffector();
			setAffector(a);
			return a;
		}
		override public function setAffector(pa:ParticleAffector):void
		{
			super.setAffector(pa);
			LinearForceAffector(pa).app=app;
			LinearForceAffector(pa).force=force;
		}
	}
}