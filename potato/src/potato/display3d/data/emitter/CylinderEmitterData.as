package potato.display3d.data.emitter
{
	import core.effects.CylinderEmitter;
	import core.effects.ParticleEmitter;

	public class CylinderEmitterData extends BoxEmitterData
	{
		public function CylinderEmitterData()
		{
			super();
		}
		override public function newEmitter():ParticleEmitter
		{
			var e:CylinderEmitter=new CylinderEmitter();
			setEmitter(e);
			return e;
		}
	}
}