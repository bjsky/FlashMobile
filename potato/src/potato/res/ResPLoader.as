package potato.res
{
	import core.events.Event;
	import core.events.EventDispatcher;
	
	import potato.event.HttpEvent;
	import potato.movie.MovieAsset;

	public class ResPLoader extends EventDispatcher
	{
		private var _res:Res;
		private var _resList:Array;
		private var _movieCfg:String;
		private var _resLoadedNum:int = 0;
		
		
		/**
		 *加载并解析资源配置文件； 
		 * @param resCfg			资源配置文件，e.g.[{res:"tzrescfg.txt",init:true},{res:"tztablecfg.txt",init:true}];
		 * @param movieCfg			2D动画配置文件；
		 * 
		 */
		public function ResPLoader(resCfg:Array,movieCfg:String=null)
		{
			_resList=resCfg;
			_movieCfg=movieCfg;
		}
		
		public function load():void{
			loadCfg(0);
		}
		
		private function loadCfg(num:int):void
		{
			_res = new Res();
			_res.addEventListener(HttpEvent.RES_LOAD_COMPLETE, resLoadComplete);
			_res.appendCfg(_resList[num].res, _resList[num].init);
		}
		
		private function resLoadComplete(e:HttpEvent):void
		{
			_resLoadedNum++;
			if (_resLoadedNum < _resList.length)
			{
				_res.removeEventListeners();
				_res.dispose();
				_res=null;
				loadCfg(_resLoadedNum);
			}
			else
			{
				if(_movieCfg)MovieAsset.appendConfig(_movieCfg);
				
				dispatchEvent(new Event(Event.COMPLETE));
				
			}
		}
	}
}