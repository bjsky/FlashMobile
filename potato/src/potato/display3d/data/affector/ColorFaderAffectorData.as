package potato.display3d.data.affector
{
	import core.effects.ColorFaderAffector;
	import core.effects.ParticleAffector;
	
	import potato.display3d.data.AffectorData;
	
	public class ColorFaderAffectorData extends AffectorData
	{
		public function ColorFaderAffectorData()
		{
			super();
		}
		
		public var alphaAdj:Number=0;
		public var blueAdj:Number=0;
		public var greenAdj:Number=0;
		public var redAdj:Number=0;
		
		override public function newAffector():ParticleAffector
		{
			var a:ColorFaderAffector=new ColorFaderAffector();
			setAffector(a);
			return a;
		}
		override public function setAffector(pa:ParticleAffector):void
		{
			super.setAffector(pa);
			ColorFaderAffector(pa).alphaAdj=alphaAdj;
			ColorFaderAffector(pa).blueAdj=blueAdj;
			ColorFaderAffector(pa).greenAdj=greenAdj;
			ColorFaderAffector(pa).redAdj=redAdj;
		}
	}
}