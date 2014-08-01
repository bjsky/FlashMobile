package potato.display3d.data
{
    import flash.net.registerClassAlias;

    public class MaterialData
    {
        public static function registerAlias():void
        {
            registerClassAlias("potato.mirage3d.data.MaterialData",MaterialData);
        }
        
        public var name:String;
        public var template:String;
		/**
		 *渲染通道，目前avm只支持一个通道，故此不能实现一个材质多纹理的情况；
		 * 比如《奇迹》中的装备流光效果 
		 */
        public var passes:Array=[];
        public var useProgram:Boolean;
    }
}