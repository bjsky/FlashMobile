package potato.display3d.core
{
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
    import core.display3d.Geometry;
    import core.display3d.Mesh;
    import core.display3d.SkeletonClipSet;
    import core.display3d.Skin;
    import core.display3d.Vector3D;
    import core.filesystem.File;
    import core.utils.WeakDictionary;
    
    import potato.display3d.Res3D;
    import potato.display3d.async.AsyncController;
    import potato.display3d.async.AsyncHandler;
    import potato.display3d.async.AsyncProcessor;
    import potato.display3d.loader.M3DParser;
    import potato.display3d.loader.ParserEvent;

	/**
	 * 网格管理器 
	 * @author liuxin
	 * 
	 */
    public class MeshManager
    {
        public static var path:String="";
        
        private static var geoDict:WeakDictionary=new WeakDictionary();
        private static var matDict:Dictionary=new Dictionary();
        private static var boundsDict:Dictionary=new Dictionary();
        private static var animDict:Dictionary=new Dictionary();
        
        private static var pendingMesh:Array=[];
        private static var parser:M3DParser;

		
		private static var controller:AsyncController=new AsyncController();
		
		public static function loadMesh(name:String,callback:AsyncHandler):void{
			//加入一个异步过程
			var processor:AsyncProcessor=new AsyncProcessor(new AsyncHandler(loadMeshAsync,[name]),callback);
			controller.addProcessor(processor);
		}
		
		private static function loadMeshAsync(name:String):void{
			var pathFile:String = "";
			var geo:Geometry=geoDict[name];
            if (geo) {
                if (animDict[name]) {
                    var skin:Skin=createSkin(geo,name);
                    SkeletonManager.loadSkeleton(animDict[name],new AsyncHandler(skinCb,[skin])); //skinCb,[curCb,skin,curParam]
                } else {
                    var mesh:Mesh=createMesh(geo,name);
					controller.complete([mesh]);
//					curCb(mesh,curParam);
                }
				return;
            }
			var b:ByteArray;
            try {
				pathFile = path + Res3D.getMeshSuffix(name);
                b=File.readByteArray(pathFile);
            } catch (e:Error) {
                return;
            }
			parser=new M3DParser();
            parser.addEventListener(ParserEvent.PARSE_COMPLETE,onParserEnd);
            parser.parseAsync(b,null);
		}
        
        private static function createMesh(geo:Geometry,file:String):Mesh
        {
            var mesh:Mesh=new Mesh(geo);
            var mat:Array=matDict[file];
            for (var i:int=0;i<mat.length;i++) {
                mesh.subMeshes[i].material=MaterialManager.getMaterial(mat[i]);
            }
            var v:Vector.<Number>=boundsDict[file]
            mesh.setBounds(new Vector3D(v[0],v[1],v[2]),new Vector3D(v[3],v[4],v[5]));
            return mesh;
        }
        
        private static function createSkin(geo:Geometry,file:String):Skin
        {
            var skin:Skin=new Skin(geo);
            var mat:Array=matDict[file];
            for (var i:int=0;i<mat.length;i++) {
                skin.subMeshes[i].material=MaterialManager.getMaterial(mat[i]);
            }
            var v:Vector.<Number>=boundsDict[file]
            skin.setBounds(new Vector3D(v[0],v[1],v[2]),new Vector3D(v[3],v[4],v[5]));
            return skin;
        }
        
        private static function onParserEnd(e:ParserEvent):void
        {
            parser.removeEventListener(ParserEvent.PARSE_COMPLETE,onParserEnd);
            parser=null;
            
			var curName:String=controller.current.process.args[0];
			
            var mesh:Mesh=e.parser.obj;
            if (mesh) {
                geoDict[curName]=mesh.geometry;
                var mat:Array=[];
                for (var i:int=0;i<mesh.subMeshes.length;i++) {
                    mat[i]=mesh.subMeshes[i].material.name;
                }
                matDict[curName]=mat;
                boundsDict[curName]=Vector.<Number>([mesh.minX,mesh.minY,mesh.minZ,mesh.maxX,mesh.maxY,mesh.maxZ]);
                
                if (mesh is Skin) {
                    var skin:Skin=mesh as Skin;
                    animDict[curName]=skin.name;
                    SkeletonManager.loadSkeleton(skin.name,new AsyncHandler(skinCb,[skin]));  //skinCb,[curCb,skin,curParam]
                } else{
					controller.complete([mesh])
//                    curCb(mesh,curParam);
				}
                //trace(curFile,"loaded!")
            }
            
            curName=null;
        }
        
        private static function skinCb(skin:Skin,anim:SkeletonClipSet):void
        {
			skin.clipSet=anim;
			controller.complete([skin])
        }
    }
}