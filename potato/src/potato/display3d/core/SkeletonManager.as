package potato.display3d.core
{
    import flash.utils.ByteArray;
    
    import core.display3d.SkeletonClipSet;
    import core.filesystem.File;
    import core.utils.WeakDictionary;
    
    import potato.display3d.async.AsyncController;
    import potato.display3d.async.AsyncHandler;
    import potato.display3d.async.AsyncProcessor;
    import potato.display3d.loader.M3DParser;
    import potato.display3d.loader.ParserEvent;

    public class SkeletonManager
    {
        public static var path:String="";
        
        private static var animDict:WeakDictionary=new WeakDictionary();
        
        private static var pendingSkel:Array=[];
        private static var parser:M3DParser;
        
		private static var controller:AsyncController=new AsyncController();
		
		public static function loadSkeleton(name:String,callback:AsyncHandler):void{
			//加入一个异步过程
			var processor:AsyncProcessor=new AsyncProcessor(new AsyncHandler(loadSkeletonAsync,[name]),callback);
			controller.addProcessor(processor);
		}
		
		public static function loadSkeletonAsync(name:String):void
		{
			var pathFile:String = "";
            var anim:SkeletonClipSet=animDict[name];
            if (anim) {
				controller.complete([anim]);
                return;
            }
			var b:ByteArray;
            try {
				pathFile = path+name;
                b=File.readByteArray(pathFile);
            } catch (e:Error) {
                return;
            }
			
			parser=new M3DParser();
			parser.addEventListener(ParserEvent.PARSE_COMPLETE,onParserEnd);
            parser.parseAsync(b,null);
		}
        
        private static function onParserEnd(e:ParserEvent):void
        {
            parser.removeEventListener(ParserEvent.PARSE_COMPLETE,onParserEnd);
            parser=null;
			
			var curName:String=controller.current.process.args[0];
            var skel:SkeletonClipSet=e.parser.obj;
            if (skel) {
                animDict[curName]=skel;
				controller.complete([skel]);
            }
        }
    }
}