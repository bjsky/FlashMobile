package potato.display3d.data.affector
{
	import core.display3d.Vector3D;
	import core.effects.MotionAffector;
	import core.effects.ParticleAffector;
	
	import potato.display3d.data.AffectorData;
	
	public class MotionAffectorData extends AffectorData
	{
		public function MotionAffectorData()
		{
			super();
		}
		
		public var force:Vector3D=new Vector3D();
		public var maxSpeed:Vector3D=new Vector3D();
		public var minSpeed:Vector3D=new Vector3D();
		public var randomnessMax:Vector3D=new Vector3D();
		public var randomnessMin:Vector3D=new Vector3D();
		public var setSpeed:Boolean=false;
		
		override public function newAffector():ParticleAffector
		{
			var a:MotionAffector=new MotionAffector();
			setAffector(a);
			return a;
		}
		override public function setAffector(pa:ParticleAffector):void
		{
			super.setAffector(pa);
			MotionAffector(pa).force=force;
			MotionAffector(pa).maxSpeed=maxSpeed;
			MotionAffector(pa).minSpeed=minSpeed;
			MotionAffector(pa).randomnessMax=randomnessMax;
			MotionAffector(pa).randomnessMin=randomnessMin;
			MotionAffector(pa).setSpeed=setSpeed;
		}
	}
}