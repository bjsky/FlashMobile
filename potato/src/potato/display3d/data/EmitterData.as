package potato.display3d.data
{
	import flash.utils.getQualifiedClassName;
	
	import core.display3d.Vector3D;
	import core.effects.ParticleEmitter;

	public class EmitterData
	{
		public function EmitterData()
		{
		}
		
		//Particle Emitter properties;
		public var angle:Number = 0.0;
		public var colorRangeEnd:Vector3D=new Vector3D(1, 1, 1, 1);
		public var colorRangeStart:Vector3D =new Vector3D(1, 1, 1, 1);
		public var emitDirection:Vector3D=new Vector3D(0, 0, -1);
		public var emitPosition:Vector3D=new Vector3D();
		//no use for a perid of time :public var emittedEmitterData:ParticleEmitterData;
		public var maxDuration:Number=0;
		public var maxRepeatDelay:Number=0;
		public var maxSpeed:Number = 1.0;
		public var maxTTL:Number=5;
		public var minDuration:Number=0;
		public var minRepeatDelay:Number=0;
		public var minSpeed:Number = 1.0;
		public var minTTL:Number=5;
		public var rate:Number = 10.0;
		public var startTime:Number=0;
		/*集中发射数*/
		public var burstEmitCount:int=0;
		
		public function newEmitter():ParticleEmitter
		{
			throw new Error("newEmitter not implement for "+getQualifiedClassName(this));
		}
		public function setEmitter(pe:ParticleEmitter):void
		{
			pe.angle=angle;
			pe.colorRangeEnd=colorRangeEnd;
			pe.colorRangeStart=colorRangeStart;
			pe.emitDirection=emitDirection;
			pe.emitPosition=emitPosition;
			pe.maxDuration=maxDuration;
			pe.maxRepeatDelay=maxRepeatDelay;
			pe.maxSpeed=maxSpeed;
			pe.maxTTL=maxTTL;
			pe.minDuration=minDuration;
			pe.minRepeatDelay=minRepeatDelay;
			pe.minSpeed=minSpeed;
			pe.minTTL=minTTL;
			pe.rate=rate;
			if(startTime!=0)pe.startTime=startTime;
			pe.burstEmitCount=burstEmitCount;
		}
		
		
	}
}