package potato.display3d.data.affector
{
	import core.display3d.Vector3D;
	import core.effects.ParticleAffector;
	import core.effects.Rotation2Affector;
	
	import potato.display3d.data.AffectorData;
	
	public class Rotation2AffectorData extends AffectorData
	{
		public function Rotation2AffectorData()
		{
			super();
		}
		public var axis:Vector3D=new Vector3D();
		public var centerMax:Vector3D=new Vector3D();
		public var centerMin:Vector3D=new Vector3D();
		public var radiusInc:Number=0;
		public var speed:Number=0;
		
		override public function newAffector():ParticleAffector
		{
			var a:Rotation2Affector=new Rotation2Affector();
			setAffector(a);
			return a;
		}
		override public function setAffector(pa:ParticleAffector):void
		{
			super.setAffector(pa);
			Rotation2Affector(pa).axis=axis;
			Rotation2Affector(pa).centerMax=centerMax;
			Rotation2Affector(pa).centerMin=centerMin;
			Rotation2Affector(pa).radiusInc=radiusInc;
			Rotation2Affector(pa).speed=speed;
		}
	}
}