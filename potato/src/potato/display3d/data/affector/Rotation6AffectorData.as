package potato.display3d.data.affector
{
	import core.display3d.Vector3D;
	import core.effects.ParticleAffector;
	import core.effects.Rotation6Affector;
	
	import potato.display3d.data.AffectorData;
	
	public class Rotation6AffectorData extends AffectorData
	{
		public function Rotation6AffectorData()
		{
			super();
		}
		public var time:Vector.<Number>=new Vector.<Number>(6);
		public var radius:Vector.<Number>=new Vector.<Number>(6);
		public var axis:Vector3D=new Vector3D();
		public var centerMax:Vector3D=new Vector3D();
		public var centerMin:Vector3D=new Vector3D();
		public var repeatTimes:Number=0;
		public var speed:Number=0;
		
		override public function newAffector():ParticleAffector
		{
			var a:Rotation6Affector=new Rotation6Affector();
			setAffector(a);
			return a;
		}
		override public function setAffector(pa:ParticleAffector):void
		{
			super.setAffector(pa);
			Rotation6Affector(pa).axis=axis;
			Rotation6Affector(pa).centerMax=centerMax;
			Rotation6Affector(pa).centerMin=centerMin;
			Rotation6Affector(pa).repeatTimes=repeatTimes;
			Rotation6Affector(pa).speed=speed;
			for (var i:int=0;i<6;i++) {
				Rotation6Affector(pa).setTimeAdjust(i,time[i]);
				Rotation6Affector(pa).setRadiusAdjust(i,radius[i]);
			}
		}
	}
}