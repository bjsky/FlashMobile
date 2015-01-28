package potato.display3d.data.emitter
{
	import core.effects.BoxEmitter;
	import core.effects.ParticleEmitter;
	
	import potato.display3d.data.EmitterData;
	
	public class BoxEmitterData extends EmitterData
	{
		public function BoxEmitterData()
		{
			super();
		}
		public var boxDepth:Number=100;
		public var boxHeight:Number=100;
		public var boxWidth:Number=100;
		
		override public function newEmitter():ParticleEmitter
		{
			var e:BoxEmitter=new BoxEmitter();
			setEmitter(e);
			return e;
		}
		
		override public function setEmitter(pe:ParticleEmitter):void{
			super.setEmitter(pe);
			BoxEmitter(pe).boxWidth=boxWidth;
			BoxEmitter(pe).boxHeight=boxHeight;
			BoxEmitter(pe).boxDepth=boxDepth;
			
		}
	}
}