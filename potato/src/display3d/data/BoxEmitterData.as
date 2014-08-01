package potato.display3d.data
{
    import flash.net.registerClassAlias;
    
    import core.effects.BoxEmitter;
    import core.effects.ParticleEmitter;

    public class BoxEmitterData extends ParticleEmitterData
    {
        public static function registerAlias():void
        {
            registerClassAlias("potato.effect3d.bean.BoxEmitterData",BoxEmitterData);
        }
        
        override public function newEmitter():ParticleEmitter
        {
            var e:BoxEmitter=new BoxEmitter();
            setEmitter(e);
            e.boxWidth=boxWidth;
            e.boxHeight=boxHeight;
            e.boxDepth=boxDepth;
            
            return e;
        }
        
		public var boxDepth:Number;
		public var boxHeight:Number;
		public var boxWidth:Number;
    }
}