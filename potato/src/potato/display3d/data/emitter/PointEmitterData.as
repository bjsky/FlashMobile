package potato.display3d.data.emitter
{
	import core.effects.ParticleEmitter;
	import core.effects.PointEmitter;
	
	import potato.display3d.data.EmitterData;
	
	public class PointEmitterData extends EmitterData
	{
		public function PointEmitterData()
		{
			super();
		}
		
		override public function newEmitter():ParticleEmitter
		{
			var e:PointEmitter=new PointEmitter();
			setEmitter(e);
			return e;
		}
	}
}