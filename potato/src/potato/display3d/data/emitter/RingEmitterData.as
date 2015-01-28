package potato.display3d.data.emitter
{
	import core.effects.ParticleEmitter;
	import core.effects.RingEmitter;

	public class RingEmitterData extends BoxEmitterData
	{
		public function RingEmitterData()
		{
			super();
		}
		
		public var innerWidth:Number=0.5;
		public var innerHeight:Number=0.5;
		override public function newEmitter():ParticleEmitter
		{
			var e:RingEmitter=new RingEmitter();
			setEmitter(e);
			
			return e;
		}
		override public function setEmitter(pe:ParticleEmitter):void{
			super.setEmitter(pe);
			RingEmitter(pe).innerWidth=innerWidth;
			RingEmitter(pe).innerHeight=innerHeight;
		}
	}
}