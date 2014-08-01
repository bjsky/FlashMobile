package potato.component
{
	import flash.utils.Dictionary;
	
	import core.display.Image;
	import core.display.Texture;
	import core.events.TimerEvent;
	import core.utils.Timer;
	
	import potato.component.data.BitmapSkin;
	import potato.resource.ResourceManager;
	import potato.utils.Size;
	
	/**
	 * 影片剪辑，实现ISprite接口是为了在编辑器中显示 
	 * @author liuxin
	 * 
	 */
	public class Clip extends Image
		implements ISprite
	{
		public function Clip(skins:String="",interval:Number=200,autoPlay:Boolean=true)
		{
			super(null);
			
			
			this.$skins=skins;
			this.$interval=interval;
			_timer=new Timer(_interval);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			this.autoPlay=autoPlay;
		}
		
		//----------------------------
		//	ISprite
		//----------------------------
		protected var _width:Number;
		protected var _height:Number;
		protected var _scale:Number;
		protected var _measureWidth:Number=0;
		protected var _measureHeight:Number=0;
		
		/**
		 * 宽度
		 * @param value
		 * 
		 */
		public function set width(value:Number):void{
			$width=value;
			render();
		}
		override public function get width():Number{
			if(!isNaN(_width))
				return _width;
			else
				return _measureWidth;
		}
		public function set $width(value:Number):void{
			_width=value;
		}
		/**
		 * 高度 
		 * @param value
		 * 
		 */
		public function set height(value:Number):void{
			$height=value;
			render();
		}
		override public function get height():Number{
			if(!isNaN(_height))
				return _height;
			else
				return _measureHeight;
		}
		public function set $height(value:Number):void{
			_height=value; 
		}
		/**
		 * 缩放 
		 * @param value
		 * 
		 */
		public function set scale(value:Number):void{
			_scale=value;
			scaleX=scaleY=_scale;
		}
		public function get scale():Number{
			return _scale;
		}
		
		//-----------------------------
		//	property
		//----------------------------
		private var _interval:Number=20;
		private var _skins:String;
		private var _frame:int=1;
		private var _totalFrame:int;
		private var _autoPlay:Boolean;
		private var _isPlaying:Boolean;
		
		/**
		 * 每帧时间间隔 单位毫秒 
		 * @return 
		 * 
		 */
		public function get interval():Number
		{
			return _interval;
		}
		
		public function set interval(value:Number):void
		{
			$interval=value;
		}
		
		public function set $interval(value:Number):void{
			if(_interval!=value){
				_interval = value;
				if(_isPlaying){
					_timer.stop();
					_timer.reset();
					_timer.removeEventListener(TimerEvent.TIMER,onTimer)
				}
				_timer=new Timer(_interval);
				_timer.addEventListener(TimerEvent.TIMER,onTimer);
				if(_isPlaying)
					play();
			}
		}
		/**
		 * 皮肤资源 
		 * @return 
		 * 
		 */
		public function get skins():String
		{
			return _skins;
		}
		
		public function set skins(value:String):void
		{
			$skins = value;
		}
		public function set $skins(value:String):void{
			_skins=value;
			_skinsArr=value.split(",");
			var maxW:Number=0,maxH:Number=0;
			for (var i:int=1;i<=_skinsArr.length;i++){
				var skinStr:String=_skinsArr[i-1];
				if(skinStr){
					var bSkin:BitmapSkin=new BitmapSkin();
					bSkin.textureName=skinStr;
					var size:Size=Bitmap.getSkinSize(bSkin);
					maxW=Math.max(maxW,size.width);
					maxH=Math.max(maxH,size.height);
					_skinsMap[i]=bSkin;
					_totalFrame=i;
				}
			}
			
			//测量宽高
			_measureWidth=maxW;
			_measureHeight=maxH;
		}
		
		/**
		 * 当前帧 
		 * @return 
		 * 
		 */
		public function get frame():int
		{
			return _frame;
		}
		public function set frame(value:int):void{
			$frame=value;
			texture=null;
			
			var tex:Texture;
			var skin:BitmapSkin=_skinsMap[_frame];
			if(skin){
				if(skin.textureData)
					tex=new Texture(skin.textureData);
				else if(skin.textureName)
					tex=ResourceManager.getTextrue(skin.textureName);
			}
			if(!tex)
				return;
			
			this.texture=tex;
		}
		public function set $frame(value:int):void{
			_frame=value;
		}
		
		/**
		 * 总帧数 
		 * @return 
		 * 
		 */
		public function get totalFrame():int
		{
			return _totalFrame;
		}
		
		
		/**
		 * 当前正在播放 
		 * @return 
		 * 
		 */
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		/**
		 * 自动播放 
		 * @return 
		 * 
		 */		
		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}
		
		public function set autoPlay(value:Boolean):void
		{
			_autoPlay = value;
			_autoPlay?play():stop();
		}
		

		//--------------------
		//	compoent
		//---------------------
		private var _timer:Timer;
		private var _skinsArr:Array=[];
		private var _skinsMap:Dictionary=new Dictionary();
		
		private function onTimer(e:TimerEvent):void{
			if(!skins) return;
			var next:int=++frame;
			if(next>totalFrame)
				next=1;
			this.frame=next;
		}
		
		/**
		 * 播放 
		 * 
		 */
		public function play():void{
			_isPlaying = true;
			frame = _frame;
			_timer.start();
		}
		/**
		 * 停止播放 
		 * 
		 */		
		public function stop():void{
			_isPlaying = false;
			_timer.stop();
			_timer.reset();
		}
		
		/**
		 * 移动到某帧播放 
		 * @param frame
		 * 
		 */
		public function goAndPlay(frame:int):void{
			if(frame>totalFrame || frame<0) return;
			this.frame=frame;
			play();
		}
		/**
		 * 移动到某帧停止 
		 * @param frame
		 * 
		 */
		public function goAndStop(frame:int):void{
			if(frame>totalFrame || frame<0) return;
			stop();
			this.frame=frame;
		}
		
		public function render():void
		{
		}
		
		override public function dispose():void{
			super.dispose();
			
			stop();
			if(_timer){
				_timer.removeEventListener(TimerEvent.TIMER,onTimer);
				_timer.dispose();
				_timer=null;
			}
			texture=null;
		}
	}
}