package potato.display3d.data.affector
{
	import core.effects.ParticleAffector;
	import core.effects.Scale2Affector;
	
	import potato.display3d.data.AffectorData;
	
	public class Scale2AffectorData extends AffectorData
	{
		public function Scale2AffectorData()
		{
			super();
		}
		public var doScale:Boolean=false;
		public var heightEnd:Number=0;
		public var heightStart:Number=0;
		public var rateX:Number=0;
		public var rateY:Number=0;
		public var uniformSize:Boolean=false;
		public var widthEnd:Number=0;
		public var widthStart:Number=0;
		
		override public function newAffector():ParticleAffector
		{
			var a:Scale2Affector=new Scale2Affector();
			setAffector(a);
			return a;
		}
		override public function setAffector(pa:ParticleAffector):void
		{
			super.setAffector(pa);
			Scale2Affector(pa).doScale=doScale;
			Scale2Affector(pa).heightEnd=heightEnd;
			Scale2Affector(pa).heightStart=heightStart;
			Scale2Affector(pa).rateX=rateX;
			Scale2Affector(pa).rateY=rateY;
			Scale2Affector(pa).uniformSize=uniformSize;
			Scale2Affector(pa).widthEnd=widthEnd;
			Scale2Affector(pa).widthStart=widthStart;
		}
	}
}