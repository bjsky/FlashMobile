package  potato.display3d.data.affector
{
	import core.effects.ColorFader2Affector;
	import core.effects.ParticleAffector;
	
	import potato.display3d.data.AffectorData;
	
	public class ColorFader2AffectorData extends AffectorData
	{
		public function ColorFader2AffectorData()
		{
			super();
		}
		
		public var alphaAdj:Number=0;
		public var alphaAdj2:Number=0;
		public var blueAdj:Number=0;
		public var blueAdj2:Number=0;
		public var greenAdj:Number=0;
		public var greenAdj2:Number=0;
		public var redAdj:Number=0;
		public var redAdj2:Number=0;
		public var stateChange:Number=1;
		
		override public function newAffector():ParticleAffector
		{
			var a:ColorFader2Affector=new ColorFader2Affector();
			setAffector(a);
			return a;
		}
		override public function setAffector(pa:ParticleAffector):void
		{
			super.setAffector(pa);
			ColorFader2Affector(pa).alphaAdj=alphaAdj;
			ColorFader2Affector(pa).alphaAdj2=alphaAdj2;
			ColorFader2Affector(pa).blueAdj=blueAdj;
			ColorFader2Affector(pa).blueAdj2=blueAdj2;
			ColorFader2Affector(pa).greenAdj=greenAdj;
			ColorFader2Affector(pa).greenAdj2=greenAdj2;
			ColorFader2Affector(pa).redAdj=redAdj;
			ColorFader2Affector(pa).redAdj2=redAdj2;
			ColorFader2Affector(pa).stateChange=stateChange;
		}
	}
}