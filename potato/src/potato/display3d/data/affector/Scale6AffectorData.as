package potato.display3d.data.affector
{
	import core.display3d.Vector3D;
	import core.effects.ParticleAffector;
	import core.effects.Scale6Affector;
	
	import potato.display3d.data.AffectorData;
	
	public class Scale6AffectorData extends AffectorData
	{
		public function Scale6AffectorData()
		{
			super();
		}
		public var time:Vector.<Number>=new Vector.<Number>(6);
		public var scale:Vector.<Vector3D>=new Vector.<Vector3D>(6);
		public var repeatTimes:Number=0;
		
		override public function newAffector():ParticleAffector
		{
			var a:Scale6Affector=new Scale6Affector();
			setAffector(a);
			return a;
		}
		override public function setAffector(pa:ParticleAffector):void
		{
			super.setAffector(pa);
			Scale6Affector(pa).repeatTimes=repeatTimes;
			for (var i:int=0;i<6;i++) {
				Scale6Affector(pa).setTimeAdjust(i,time[i]);
				Scale6Affector(pa).setScaleAdjust(i,scale[i]?scale[i].x:0,scale[i]?scale[i].y:0);
			}
		}
	}
}