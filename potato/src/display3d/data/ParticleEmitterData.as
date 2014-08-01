package potato.display3d.data
{
    import flash.net.registerClassAlias;
    import flash.utils.getQualifiedClassName;
    
    import core.display3d.Vector3D;
    import core.effects.ParticleEmitter;

	/**
	 * 粒子系统发射器数据结构体； 
	 * @author SuperFlash
	 * 
	 */
    public class ParticleEmitterData
    {
        public static function registerAlias():void
        {
            registerClassAlias("potato.effect3d.bean.ParticleEmitterData",ParticleEmitterData);
        }
        
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
        }
        
		//Particle Emitter properties;
        public var angle:Number = 0.0;
        public var colorRangeEnd:Vector3D;
        public var colorRangeStart:Vector3D;
		public var emitDirection:Vector3D;
		public var emitPosition:Vector3D;
		//no use for a perid of time :public var emittedEmitterData:ParticleEmitterData;
		public var maxDuration:Number;
		public var maxRepeatDelay:Number;
        public var maxSpeed:Number = 1.0;
        public var maxTTL:Number;
        public var minDuration:Number;
        public var minRepeatDelay:Number;
        public var minSpeed:Number = 1.0;
        public var minTTL:Number;
		public var rate:Number = 1.0;
		public var startTime:Number=0;
		
		//base class Particle properties;
//		public var totalTimeToLive:Number;
//		public var timeToLive:Number;
//		public var rotationSpeed:Number;
//		public var rotation:Number;
//		public var color:Vector3D;
//		public var height:Number;
//		public var width:Number;
//		public var direction:Vector3D;
//		public var position:Vector3D;
		
    }
}