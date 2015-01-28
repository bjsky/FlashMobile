package potato.display3d.data.emitter
{
	import core.effects.HollowEllipsoidEmitter;
	import core.effects.ParticleEmitter;

	public class HollowEllipsoidEmitterData extends BoxEmitterData
	{
		public function HollowEllipsoidEmitterData()
		{
			super();
		}
		public var innerWidth:Number=0.5;
		public var innerHeight:Number=0.5;
		public var innerDepth:Number=0.5;
		
		override public function newEmitter():ParticleEmitter
		{
			var e:HollowEllipsoidEmitter=new HollowEllipsoidEmitter();
			setEmitter(e);
			return e;
		}
		override public function setEmitter(pe:ParticleEmitter):void{
			super.setEmitter(pe);
			HollowEllipsoidEmitter(pe).innerWidth=innerWidth;
			HollowEllipsoidEmitter(pe).innerHeight=innerHeight;
			HollowEllipsoidEmitter(pe).innerDepth=innerDepth;
		}
	}
}