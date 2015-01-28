package potato.display3d.data.affector
{
	import core.display3d.Vector3D;
	import core.effects.ColorFader6Affector;
	import core.effects.ParticleAffector;
	
	import potato.display3d.data.AffectorData;
	
	public class ColorFader6AffectorData extends AffectorData
	{
		public function ColorFader6AffectorData()
		{
			super();
		}
		
		public var times:Vector.<Number>=Vector.<Number>([1,1,1,1,1,1])
		public var colours:Vector.<Vector3D>=Vector.<Vector3D>([new Vector3D(0.5,0.5,0.5,0),new Vector3D(0.5,0.5,0.5,0),new Vector3D(0.5,0.5,0.5,0)
			,new Vector3D(0.5,0.5,0.5,0),new Vector3D(0.5,0.5,0.5,0),new Vector3D(0.5,0.5,0.5,0)])
		public var fadeInTime:Number=0;
		public var fadeOutTime:Number=1;
		public var opacity:Number=1;
		public var repeatTimes:Number=1;
		
		override public function newAffector():ParticleAffector
		{
			var a:ColorFader6Affector=new ColorFader6Affector();
			setAffector(a);
			return a;
		}
		override public function setAffector(pa:ParticleAffector):void
		{
			super.setAffector(pa);
			ColorFader6Affector(pa).fadeInTime=fadeInTime;
			ColorFader6Affector(pa).fadeOutTime=fadeOutTime;
			ColorFader6Affector(pa).opacity=opacity;
			ColorFader6Affector(pa).repeatTimes=repeatTimes;
			for (var i:int=0;i<6;i++) {
				ColorFader6Affector(pa).setTimeAdjust(i,times[i]);
				ColorFader6Affector(pa).setColorAdjust(i,colours[i]);
			}
		}
	}
}