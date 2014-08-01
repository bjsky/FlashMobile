package potato.display3d.data
{
    import flash.net.registerClassAlias;

    public class PassData
    {
        public static function registerAlias():void
        {
            registerClassAlias("potato.mirage3d.data.PassData",PassData);
        }
        
        public var blend:int;
        
        public var depthCheck:Boolean=true;
        public var depthWrite:Boolean=true;
        public var depthBias:Number=0;
        public var colorWrite:Boolean=true;

        public var lighting:Boolean=true;
        public var ambient:uint=0xffffff;
        public var diffuse:uint=0xffffff;
        public var specular:uint;
        public var gloss:Number=0;
        public var alphaReject:Number=0;
        
		/**
		 *纹理图片的名字 
		 */
        public var texture:String;
        
        public var texture_num:int;
    }
}