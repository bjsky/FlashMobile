package potato.display3d.data.emitter
{
	import core.effects.EllipsoidEmitter;
	import core.effects.ParticleEmitter;

	public class EllipsoidEmitterData extends BoxEmitterData
	{
		public function EllipsoidEmitterData()
		{
			super();
		}
		override public function newEmitter():ParticleEmitter
		{
			var e:EllipsoidEmitter=new EllipsoidEmitter();
			setEmitter(e);
			return e;
		}
	}
}