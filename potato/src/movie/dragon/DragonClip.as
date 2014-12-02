package potato.movie.dragon
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import core.display.DisplayObjectContainer;
	import core.display.Image;
	import core.events.Event;
	import core.filters.ColorMatrixFilter;
	
	import potato.movie.IMovie;
	import potato.movie.MovieAsset;
	import potato.movie.MovieEvent;
	import potato.res.Res;
	
	/**
	 * 优化后的龙骨动画.
	 * <p>提供帧率控制</p>
	 * @author liuxin
	 * 
	 */
	public class DragonClip extends DisplayObjectContainer
		implements IMovie
	{
		public function DragonClip(movieName:String,autoPlay:Boolean = true,loop:Boolean=true)
		{
			super();
			_autoPlay=autoPlay;
			_loop=loop;
			this.movieName=movieName;
		}
		
		private var _autoPlay:Boolean;
		private var _loop:Boolean;
		private var _movieName:String;
		private var _frameArr:Array;
		private var _speed:Number=50;
		
		//开始时间
		private var _startTime:int;
		//正在播放
		private var _isPlaying:Boolean=false;
		//当前帧
		private var _currentFrame:int=-1;
		
		private var _totalFrame:int=0;
		
		private var cacheName:Array = [];
		private var cacheImage:Array = [];
		
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
		 * 帧速，单位毫秒 
		 * @return 
		 * 
		 */
		public function get speed():Number
		{
			return _speed;
		}

		public function set speed(value:Number):void
		{
			_speed = value;
		}

		/**
		 * 龙骨数据 
		 * @return 
		 * 
		 */
		public function get frameArr():Array
		{
			return _frameArr;
		}

		public function set frameArr(value:Array):void
		{
			_frameArr = value;
			
			if(_frameArr){
				if(_frameArr.length>0){
					_totalFrame=_frameArr.length;
					
					_startTime = getTimer();
					currentFrame=0;
					
					if (_totalFrame != 1 && _autoPlay)
						play();
				}
			}
		}

		/**
		 * 动画名 
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
				var arr:Array= MovieAsset.getDragonConfig(value) as Array;
				if(!arr){
					return;
				}
				_movieName = value;
				frameArr=arr;
			}
		}

		private function loopHandler(e:Event):void
		{
			// TODO Auto Generated method stub
			if (!_isPlaying)
				return;
			
			var currentTime:int = getTimer();
			var timespan:int = currentTime - _startTime;
			var info:ActionInfo=findActionInfo(_currentFrame);
			var frameSpeed:Number= info && !isNaN(info.speed) ?info.speed:_speed;
			var frame:int=timespan/frameSpeed;
			_startTime+=frame*frameSpeed;
			//当前帧
			currentFrame+=frame;
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
			if(_currentFrame!=value){
				if(value>=_totalFrame)
				{
					this.dispatchEvent(new MovieEvent(MovieEvent.COMPLETE));
					_currentFrame=value%_totalFrame;
					if(!_loop){
						gotoAndStop(_totalFrame-1);
					}
				}else{
					_currentFrame=value;
				}
				showImg(_currentFrame);
			}
			this.dispatchEvent(new MovieEvent(MovieEvent.ENTER_FRAME));
		}
		
		private function showImg(frame:int):void
		{
			// TODO Auto Generated method stub
			if(!_frameArr ||_frameArr.length<frame)
			{
				trace("动作为空",frame);
			}
			var arr:Array = _frameArr[frame];
			if(!arr)
				return;
			
			var tempName:Array = [];
			var tempImage:Array = [];
			var update:Boolean = false;
			if(arr.length != numChildren)
			{
				update = true;
			}
			for (var i:int = 0,l:int = arr.length; i < l; i++) 
			{
				var fd:FrameData = arr[i];
				var img:Image;
				if(cacheName[i] == fd.texName && !update)
				{
					img = cacheImage[i];
				}
				else
				{
					if(cacheImage[i])
						removeChildAt(i);
					img = Res.getImage(fd.texName);
					addChildAt(img, i);
				}
				
				tempName[i] = fd.texName;
				tempImage[i] = img;
				
				img.x = fd.x;
				img.y = fd.y;
				img.scaleX = fd.scaleX;
				img.scaleY = fd.scaleY;
				img.rotation = fd.rotation;
				img.pivotX = fd.px;
				img.pivotY = fd.py;
				if(fd.changeTransframe)
				{
					if(fd.transframe == null)
						img.filter = null;
					else
						img.filter = new ColorMatrixFilter(fd.transframe);
				}
			}
			cacheName = tempName;
			cacheImage = tempImage;
			removeChildren(i);
		}
		
		private function removeChildren(startIndex:int = 0):void
		{
			cacheImage.splice(startIndex, numChildren - startIndex);
			cacheName.splice(startIndex, numChildren - startIndex);
			
			for (var i:int = 0, l:int = numChildren - startIndex; i < l; i++)
			{
				removeChildAt(startIndex);
			}
		}
		
		
		public function play():void
		{
			_isPlaying = true;
			currentFrame = _currentFrame;
			addEventListener(Event.ENTER_FRAME, loopHandler);
		}
		
		public function stop():void
		{
			_isPlaying = false;
			removeEventListener(Event.ENTER_FRAME, loopHandler);
		}
		
		public function gotoAndStop(frame:int):void
		{
			_isPlaying = false;
			currentFrame = frame;
			removeEventListener(Event.ENTER_FRAME, loopHandler);
		}
		
		public function gotoAndPlay(frame:int):void
		{
			_isPlaying = true;
			currentFrame = frame;
			_startTime = getTimer();
			
			addEventListener(Event.ENTER_FRAME, loopHandler);
		}
		
		private var _actionMap:Dictionary=new Dictionary();
		private var _actionInfo:ActionInfo;
		/**
		 * 设置动作 
		 * @param name 动作名
		 * @param begin 开始帧
		 * @param end 结束帧
		 * @param speed 动作帧数
		 * 
		 */
		public function setAction(name:String,begin:int,end:int,speed:Number=NaN):void{
			_actionMap[name]=new ActionInfo(begin,end,speed);
		}
		
		private function findActionInfo(frame:int):ActionInfo{
			for each(var info:ActionInfo in _actionMap){
				if(frame<info.end && frame>=info.begin)
					return info;
			}
			return null;
		}
		
		/**
		 * 播放动作 
		 * @param name 动作名
		 * @param loop 是否循环
		 * 
		 */
		public function playAction(name:String,loop:Boolean=false):void{
			var info:ActionInfo=_actionMap[name];
			info.loop=loop;
			_actionInfo=info;
			
			gotoAndPlay(_actionInfo.begin);
			addEventListener(MovieEvent.ENTER_FRAME,actionHandler);
		}
		
		private function actionHandler(e:MovieEvent):void
		{
			if(!_actionInfo) return;
			if(currentFrame>=_actionInfo.end){
				dispatchEvent(new MovieEvent(MovieEvent.ACTION_COMPLETE));
				if(_actionInfo.loop){
					gotoAndPlay(_actionInfo.begin);
				}else{
					stop();
					removeEventListener(MovieEvent.ENTER_FRAME,actionHandler);
					_actionInfo=null;
				}
			}
		}
		
		override public function dispose():void
		{
			stop();
			removeEventListener(MovieEvent.ENTER_FRAME,actionHandler);
			_actionInfo=null;
			_frameArr=[];
			cacheName = [];
			cacheImage = [];
			removeChildren();
			super.dispose();
		}
	}
}

class ActionInfo{
	public function ActionInfo(b:int,e:int,s:Number=NaN):void{
		begin=b;
		end=e;
		speed=s;
	}
	
	public var begin:int;
	public var end:int;
	public var speed:Number=NaN;
	public var loop:Boolean=false;
}