package potato.display3d.data
{
    import flash.net.registerClassAlias;

    public class EllipsoidEmitterData extends BoxEmitterData
    {
        public static function registerAlias():void
        {
            registerClassAlias("potato.effect3d.bean.EllipsoidEmitterData",EllipsoidEmitterData);
        }
    }
}