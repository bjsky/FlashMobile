package potato.display3d.data
{
    import flash.net.registerClassAlias;
    
    import core.effects.ParticleEmitter;
    import core.effects.PointEmitter;

    public class PointEmitterData extends ParticleEmitterData
    {
        public static function registerAlias():void
        {
            registerClassAlias("potato.effect3d.bean.PointEmitterData",PointEmitterData);
        }
        
        override public function newEmitter():ParticleEmitter
        {
            var e:PointEmitter=new PointEmitter();
            setEmitter(e);
            
            return e;
        }
    }
}