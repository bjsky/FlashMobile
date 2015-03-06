package potato.display3d.core
{
    import flash.utils.Dictionary;
    
    import core.display3d.Material;
    import core.display3d.Pass;
    import core.display3d.UVAnimation;
    import core.display3d.UVMatrix;
    import core.display3d.Vector3D;
    import core.utils.WeakDictionary;
    
    import potato.potato_internal;
    import potato.display3d.data.MaterialData;
    import potato.display3d.data.PassData;

	/**
	 * 材质管理器 
	 * @author superFlash
	 * 
	 */
    public class MaterialManager
    {
		use namespace potato_internal;
        private static var _defaultMaterial:Material;

		private static var dataDict:Dictionary=new Dictionary();
        private static var materialDict:WeakDictionary=new WeakDictionary();
        
		/**
		 * 设置材质数据
		 * @param path
		 * 
		 */
		public static function setMaterialData(data:Dictionary):void{
			dataDict=data;
		}
		
		/**
		 * 获取材质 
		 * @param name
		 * @return 
		 * 
		 */
		public static function getMaterial(name:String):Material
        {
            var m:Material=materialDict[name];
            if (m)
                return m;
            var md:MaterialData=dataDict[name];
            if (md) {
                m=createMaterial(md);
                materialDict[name]=m;
				if (!m)
					trace(name);
                return m;
            }
            
            return getDefaultMaterial();
        }
        
        private static function createMaterial(md:MaterialData):Material
        {
            var m:Material=new Material();
            m.name=md.name;
            setPass(m,md.passes[0]);
            return m;
        }
		
		
		/**
		 * 克隆材质 
		 * @param name
		 * @return 
		 * 
		 */
		public static function cloneMaterial(name:String):Material
		{
			var tmpMat:Material = getMaterial(name);
			var retMat:Material = new Material();
			
			retMat.blendMode=tmpMat.blendMode;
			retMat.colorWrite=tmpMat.colorWrite;
			retMat.depthWrite=tmpMat.depthWrite;
			retMat.depthCheck=tmpMat.depthCheck;
			retMat.depthBias=tmpMat.depthBias;
			
			retMat.lightingEnabled=tmpMat.lightingEnabled;
			retMat.specular=tmpMat.specular;           
			retMat.color=tmpMat.color;
			retMat.specularColor=tmpMat.specularColor;
			retMat.gloss=tmpMat.gloss;
			retMat.alphaReject=tmpMat.alphaReject;
			
			retMat.texture=tmpMat.texture;
			
			return retMat;
		}
        
        private static function setPass(ps:Pass,pd:PassData):void
        {
			ps.blendMode=pd.blend;
			ps.colorWrite=pd.colorWrite;
			ps.depthWrite=pd.depthWrite;
			ps.depthCheck=pd.depthCheck;
			ps.depthBias=pd.depthBias;
			ps.lightingEnabled=pd.lighting;
			ps.specular=1;  //ps.ambient=ps.diffuse=
			//			ps.ambientColor=pd.ambient;
			ps.color=pd.diffuse;
			ps.specularColor=pd.specular;
			ps.gloss=pd.gloss;
			ps.alphaReject=pd.alphaReject;
			if(isHasFrame(pd.frameAnim)){
				var uv:UVAnimation = new UVAnimation();
				uv.uTile = pd.frameAnim.x;
				uv.vTile = pd.frameAnim.y;
				uv.cycles = pd.frameAnim.z;
				ps.uvMatrix=new UVMatrix();
				ps.uvMatrix.frameAnim = uv;
			}
            ps.texture=TextureManager.getTexture(pd.texture);
        }
        
		private static function isHasFrame(v:Vector3D):Boolean{
			if(v && (v.x>1 || v.y>1 || v.z>1)){
				return true;
			}
			return false;
		}
		
        public static function getDefaultMaterial():Material
        {
            if (!_defaultMaterial)
                createDefaultMaterial();
            
            return _defaultMaterial;
        }
//        
//        public static function addMaterialDataBin(path:String):void
//        {
//            MaterialData.registerAlias();
//            PassData.registerAlias();
//            
//            var b:ByteArray=File.readByteArray(path);
//            var materials:Array=b.readObject();
//            for each (var m:MaterialData in  materials) {
//                if (dataDict[m.name])
//                    throw new Error("重复的材质数据:"+m.name);
//                dataDict[m.name]=m;
//            }
//        }
        
        private static function createDefaultMaterial():void
        {
            _defaultMaterial=new Material(TextureManager.getDefaultTexture());
        }
    }
}