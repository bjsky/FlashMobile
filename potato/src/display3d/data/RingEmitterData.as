package  potato.display3d.data
{
    import flash.net.registerClassAlias;
    
    import core.effects.ParticleEmitter;
    import core.effects.RingEmitter;

    public class RingEmitterData extends BoxEmitterData
    {
        public static function registerAlias():void
        {
            registerClassAlias("potato.effect3d.bean.RingEmitterData",RingEmitterData);
        }
        
        override public function newEmitter():ParticleEmitter
        {
            var e:RingEmitter=new RingEmitter();
            setEmitter(e);
            e.boxWidth=boxWidth;
            e.boxHeight=boxHeight;
            e.boxDepth=boxDepth;
            e.innerWidth=innerWidth;
            e.innerHeight=innerHeight;
            
            return e;
        }
        
        public var innerWidth:Number;
        public var innerHeight:Number;
    }
}