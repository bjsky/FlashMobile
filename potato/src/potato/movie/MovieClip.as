package potato.movie
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import core.display.Image;
	import core.display.Texture;
	import core.events.Event;
	
	import potato.res.Res;
	
	/**
	 * 播放完成.
	 * @author liuxin
	 * 
	 */
	[Event(name="complete",type="potato.movie.MovieEvent")]
	/**
	 * 进入帧.
	 * @author liuxin
	 * 
	 */
	[Event(name="movie::enterFrame",type="potato.movie.MovieEvent")]
	/**
	 * 进入关键帧.
	 * @author liuxin
	 * 
	 */
	[Event(name="enterKeyFrame",type="potato.movie.MovieEvent")]
	/**
	 * 序列帧动画.
	 * <p></p> 
	 * @author liuxin
	 * @example 包含一个动画的样例
	 * <listing>
	 *	class MovieExample{
	 *		public function MovieExample(){
	 * 
	 *			//先添加动画资源的图集
	 *			ResourceManager.addAtlases("test","zh_CN/pc/test.png","zh_CN/pc/test.xml");
	 * 
	 *			//使用数据
	 *			var md:MovieData=new MovieData("player1",9,"1,2,1,2,1,2,1,2,1",135,0,0,0.5);	//player1对应的纹理资源包含在test图集中	
	 *			var movie1:Movie=new Movie(md,true,false);										//自动播放，不循环播放		
	 *			addChild(movie1);
	 * 
	 *			//使用配置文件
	 *			ResourceManager.addMovieConfig("resource/testMovie.txt");						
	 *			var movie2:Movie=new Movie("player2");											//player2对应的动画数据在testMovie.txt中定义	
	 *			addChild(movie2,false);															//不自动播放，循环播放
	 * 
	 *			//播放控制
	 *			movie1.stop();
	 *			movie1.gotoAndPlay(3);									//跳到帧索引3播放，此处currentKeyFrame=2。帧和关键帧的起始索引都为0
	 *			movie2.play();
	 *			movie2.gotoKeyAndStop(3);								//跳到关键帧索引3停止，此处currentFrame=4。
	 * 
	 *			//添加脚本
	 *			movie1.addFrameScript(0,function(m:Movie):void{
	 *				m.gotoKeyAndPlay(1);								//第一帧添加脚本跳到第二个关键帧
	 *			});
	 * 
	 *			movie2.addKeyFrameScript(1,function(m:Movie):void{
	 *				m.gotoAndPlay(5);									//第二个关键帧添加脚本跳到第6帧
	 *			});
	 * 
	 *			//事件
	 *			movie1.addEventListener(MovieEvent.COMPLETE,onComplete); 
	 *			movie1.addEventListener(MovieEvent.ENTER_FRAME,onEnterFrame); 
	 *			movie1.addEventListener(MovieEvent.ENTER_KEY_FRAME,onEnterKeyFrame); 
	 * 
	 *		}
	 * 
	 *		private function onComplete(e:MovieEvent):void{
	 *			trace("totalFrame:"+m.totoalFrame+",totalKeyFrame:"+m.totalKeyFrame);
	 *		}
	 * 
	 *		private function onEnterFrame(e:MovieEvent):void{
	 *			trace(m.currentFrame); 
	 *		}
	 * 
	 *		private function onEnterKeyFrame(e:MovieEvent):void{
	 *			trace(m.currentKeyFrame);
	 *		}
	 * }
	 * </listing>
	 */
	public class MovieClip extends Image
		implements IMovie
	{
		/**
		 *  
		 * @param data  动画名\动画数据
		 * @param autoPlay 自动播放
		 * 
		 */
		public function MovieClip(data:*=null, autoPlay:Boolean = true,loop:Boolean=true)
		{
			super(null);
			
			_autoPlay=autoPlay;
			_loop=loop;
			if(data is String)
				this.movieName=data;
			else if(data is MovieBean)
				this.movieData=data;
		}
		
		private var _autoPlay:Boolean;
		private var _loop:Boolean;
		private var _movieName:String;
		private var _movieData:MovieBean;
		private var _scale:Number;
		
		private var _scaleX:Number=1;

		public override function set scaleX(_arg1:Number):void{
			_scaleX=_arg1;
			super.scaleX=_scaleX/_scale;
		}
		
		private var _scaleY:Number=1;
		public override function set scaleY(_arg1:Number):void{
			_scaleY=_arg1;
			super.scaleY=_scaleY/_scale;
			
		}
		//----------------------
		// private
		//-----------------------
		private var _frameScriptMap:Dictionary=new Dictionary();
		private var _keyframeScriptMap:Dictionary=new Dictionary();
		
		private var _totalKeyFrame:int=0;
		private var _totalFrame:int=0;
		//开始时间
		private var _startTime:int;
		//正在播放
		private var _isPlaying:Boolean=false;
		//当前帧
		private var _currentFrame:int=-1;
		//当前关键帧
		private var _currentKeyFrame:int=-1;
		
		private var _isreset:Boolean=false;
		
		/**
		 * 关键帧纹理
		 */
		private var _keyFrameAssets:Vector.<Texture>;
		/**
		 * 关键帧位置
		 */
		private var _keyFrameArr:Array;
		
		/**
		 * 关键帧数量 
		 */
		public function get totalKeyFrame():int
		{
			return _totalKeyFrame;
		}
		/**
		 * 帧数量 
		 * @return 
		 * 
		 */		
		public function get totalFrame():int
		{
			return _totalFrame;
		}
		/**
		 * 是否正在播放 
		 * @return 
		 * 
		 */		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		
		/**
		 * 动画数据
		 * @return 
		 * 
		 */
		public function set movieData(value:MovieBean):void
		{
			_movieData = value;
			if(_movieData){
				_totalKeyFrame=_movieData.frameNumber;
				if(_totalKeyFrame>0){
					_scale = _movieData.scale ? _movieData.scale : 1;		// 缩放要在脚点之前设置
					super.scaleX = _scaleX / _scale;
					super.scaleY = _scaleY / _scale;
					
					pivotX = -_movieData.footX * _scale;
					pivotY = -_movieData.footY * _scale;
					
					//keyframeArr转累积值
					_keyFrameArr=[];
					var frameArr:Array = _movieData.frameArr;
					
					_totalFrame=0;
					for(var index:int=0;index<frameArr.length;index++)
					{
						var intKeyFrameTime:int=int(frameArr[index]);
						if(intKeyFrameTime<1)
							intKeyFrameTime=1;
						_totalFrame+=intKeyFrameTime;
						_keyFrameArr.push(_totalFrame);
					}
					
					//关键帧资源
					_keyFrameAssets = new Vector.<Texture>(_totalKeyFrame, true);
					for (var i:int = 0; i < _totalKeyFrame; i++)
					{
						_keyFrameAssets[i] = Res.getTexture(_movieData.movieName+"_"+String(i));
					}
					
					_startTime = getTimer();
					_isreset=true;
					currentFrame=0;
					
					if (_totalKeyFrame != 1 && _autoPlay)
						play();
				}
			}
		}
		
		private function loopHandler(e:Event):void
		{
			// TODO Auto Generated method stub
			if (!_isPlaying)
				return;
			
			var currentTime:int = getTimer();
			var timespan:int = currentTime - _startTime;
			var frame:int=timespan/_movieData.speed;
			_startTime+=frame*_movieData.speed;
			//当前帧
			currentFrame+=frame;
		}
		public function get movieData():MovieBean
		{
			return _movieData;
		}
		
		/**
		 * 动画名(对应的动画配置MovieData) 
		 * @return 
		 * 
		 */
		public function get movieName():String
		{
			return _movieName;
		}

		public function set movieName(value:String):void
		{
			if (_movieName != value && value)
			{
				var bean:MovieBean= MovieAsset.getConfig(MovieAsset.CLIP_PREFIX+value);
				if(!bean){
					return;
				}
				_movieName = value;
				movieData=bean;
			}
		}
		
		/**
		 * 播放 
		 * 
		 */
		public function play():void
		{
			_isPlaying = true;
			currentFrame = _currentFrame;
			addEventListener(Event.ENTER_FRAME, loopHandler);
		}
		
		/**
		 * 停止 
		 * 
		 */
		public function stop():void
		{
			_isPlaying = false;
			removeEventListener(Event.ENTER_FRAME, loopHandler);
		}
		
		/**
		 * 跳到第几帧停止 
		 * @param frame
		 * 
		 */
		public function gotoAndStop(frame:int):void
		{
			_isPlaying = false;
			currentFrame = frame;
			removeEventListener(Event.ENTER_FRAME, loopHandler);
		}
		
		/**
		 * 跳到第几帧播放 
		 * @param frame
		 * 
		 */
		public function gotoAndPlay(frame:int):void
		{
			_isPlaying = true;
			currentFrame = frame;
			_startTime = getTimer();
			
			addEventListener(Event.ENTER_FRAME, loopHandler);
		}
		
		/**
		 * 跳到第几关键帧停止 
		 * @param keyframe
		 * 
		 */
		public function gotoKeyAndStop(keyframe:int):void{
			_isPlaying = false;
			currentFrame = keyframe==0?0:_keyFrameArr[keyframe-1];
			removeEventListener(Event.ENTER_FRAME, loopHandler);
		}
		
		/**
		 * 跳到第几关键帧播放 
		 * @param keyframe
		 * 
		 */
		public function gotoKeyAndPlay(keyframe:int):void{
			_isPlaying = true;
			currentFrame = keyframe==0?0:_keyFrameArr[keyframe-1];
			_startTime = getTimer();
			
			addEventListener(Event.ENTER_FRAME, loopHandler);
		}
		/**
		 * 当前帧 
		 * @return 
		 * 
		 */		
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		public function set currentFrame(value:int):void
		{
			this.dispatchEvent(new MovieEvent(MovieEvent.ENTER_FRAME));
			if(_currentFrame!=value || _isreset){
				if(value>=_totalFrame)
				{
					_currentFrame=value%_totalFrame;
					if(!_loop){
						gotoAndStop(_totalFrame-1);
					}
					this.dispatchEvent(new MovieEvent(MovieEvent.COMPLETE));
				}else{
					_currentFrame=value;
				}
				
				//keyFrame
//				trace("===keyframearr.length==="+_keyFrameArr.length);
				for (var i:int=0;i<_keyFrameArr.length;i++){
					if(currentFrame<_keyFrameArr[i]){
//						trace("======i======="+i+"===currentFrame====="+currentFrame+"====_keyFrameArr==="+_keyFrameArr[i]);
						currentKeyFrame=i;
						break;
					}
				}
				var script:Function=_frameScriptMap[_currentFrame];
				if(script!=null)
					script(this);
			}
		}
		
		/**
		 * 当前关键帧 
		 * @return 
		 * 
		 */
		public function get currentKeyFrame():int
		{
			return _currentKeyFrame;
		}
		
		public function set currentKeyFrame(value:int):void
		{
			this.dispatchEvent(new MovieEvent(MovieEvent.ENTER_KEY_FRAME));
			if(_currentKeyFrame !=value || _isreset){
				_isreset=false;
				_currentKeyFrame = value;
//				trace("length:"+_keyFrameAssets.length+",_currentKeyFrame:"+_currentKeyFrame);
				var texture:Texture = _keyFrameAssets[_currentKeyFrame];
				this.texture = texture;
				
				var script:Function=_keyframeScriptMap[_currentKeyFrame];
				if(script!=null)
					script(this);
			}
		}
		
		/**
		 * 为帧添加脚本 
		 * @param frame 帧索引
		 * @param script 脚本函数:function(m:MovieClip):void;
		 * 
		 */
		public function addFrameScript(frame:int,script:Function):void{
			_frameScriptMap[frame]=script;
		}
		
		/**
		 * 为关键帧添加脚本
		 * @param keyFrame 关键帧索引
		 * @param script 脚本函数:function(m:MovieClip):void;
		 * 
		 */
		public function addKeyFrameScript(keyFrame:int,script:Function):void{
			_keyframeScriptMap[keyFrame]=script;
		}
		
		public override function dispose():void{
			super.dispose();
			texture=null;
			removeEventListener(Event.ENTER_FRAME, loopHandler);
			
			for (var key:* in _frameScriptMap){
				var script:Function=_frameScriptMap[key];
				script=null;
				delete _frameScriptMap[key];
			}
			_frameScriptMap=null;
			
			for (key in _keyframeScriptMap){
				script=_keyframeScriptMap[key];
				script=null;
				delete _keyframeScriptMap[key];
			}
			_keyframeScriptMap=null;
		}
	}
}