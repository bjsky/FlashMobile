package potato.display3d.data
{
    import flash.net.registerClassAlias;
    
    import core.effects.ParticleEmitter;
    import core.effects.PolarEmitter;

    public class PolarEmitterData extends ParticleEmitterData
    {
        public static function registerAlias():void
        {
            registerClassAlias("potato.effect3d.bean.PolarEmitterData",PolarEmitterData);
        }
        
        override public function newEmitter():ParticleEmitter
        {
            var e:PolarEmitter=new PolarEmitter();
            setEmitter(e);
            e.radiusStart=radiusStart;
            e.radiusEnd=radiusEnd;
            e.radiusStep=radiusStep;
            e.thetaStart=thetaStart;
            e.thetaEnd=thetaEnd;
            e.thetaStep=thetaStep;
            e.phiStart=phiStart;
            e.phiEnd=phiEnd;
            e.phiStep=phiStep;
            e.resetRadiusCount=resetRadiusCount;
            e.useStep=useStep;
            e.flipYZ=flipYZ;
            e.resetRadius=resetRadius;
            
            return e;
        }
        
        public var flipYZ:Boolean;
        public var phiEnd:Number;
        public var phiStart:Number;
        public var phiStep:Number;
        public var radiusEnd:Number;
        public var radiusStart:Number;
        public var radiusStep:Number;
        public var resetRadius:Boolean;
        public var resetRadiusCount:uint;
        public var thetaEnd:Number;
        public var thetaStart:Number;
        public var thetaStep:Number;
        public var useStep:Boolean;
		
    }
}