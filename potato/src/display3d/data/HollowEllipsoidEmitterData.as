package potato.display3d.data
{
    import flash.net.registerClassAlias;

    public class HollowEllipsoidEmitterData extends BoxEmitterData
    {
        public static function registerAlias():void
        {
            registerClassAlias("potato.effect3d.bean.HollowEllipsoidEmitterData",HollowEllipsoidEmitterData);
        }
        
        public var innerWidth:Number;
        public var innerHeight:Number;
        public var innerDepth:Number;
    }
}