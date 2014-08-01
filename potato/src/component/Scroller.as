package potato.component
{
	import flash.utils.Dictionary;
	
	import core.display.DisplayObjectContainer;
	import core.display.Shape;
	import core.display.Texture;
	import core.display.TextureData;
	import core.events.Event;
	
	import potato.component.data.BitmapSkin;
	import potato.event.GestureEvent;
	import potato.gesture.PanGesture;
	import potato.utils.DebugUtil;
	import potato.utils.Size;
	import potato.utils.StringUtil;
	
	public class Scroller extends DisplayObjectContainer
		implements ISprite
	{
		public function Scroller(skins:String="",direction:String="vertical",width:Number=NaN,height:Number=NaN,thumbRatio:Number=0.5,val=0)
		{
			super();
			
			createChildren();
			
			$skins=skins;
			$direction=direction;
			$thumbRatio=thumbRatio;
			$val=val;
			$width=width;
			$height=height;
			render();
		}
		
		public function setSkins(barSkin:BitmapSkin=null,thumbSkin:BitmapSkin=null):void{
			$barSkin=barSkin;
			$thumbSkin=thumbSkin;
			render();
		}
		
		static public const VERTICAL:String="vertical";
		static public const HORIZONTAL:String="horizontal";
		
		static private const HORIZONTAL_MIN:Number=200;
		static private const VERTICAL_MIN:Number=20;
		static private const BAR:uint=0;		
		static private const THUMB:uint=1;
	
		//----------------------------
		//	ISprite
		//----------------------------
		protected var _width:Number;
		protected var _height:Number;
		protected var _scale:Number;
		
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
			return _width;
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
			return _height;
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
		//------------------------
		// assets
		//------------------------
		private var _thumb:Bitmap;
		private var _bar:Bitmap;
		private var _pan:PanGesture;
		private function createChildren():void{
			_bar=new Bitmap();
			addChild(_bar);
			_thumb=new Bitmap();
			addChild(_thumb);
			
			_pan=new PanGesture(this);
			_pan.addEventListener(GestureEvent.PAN_MOVE,onPan);
		}
		
		private function onPan(e:Event):void{
			var offset:Number=(direction==HORIZONTAL)?_pan.offsetX:_pan.offsetY;
			var len:Number=(direction==HORIZONTAL)?width-_thumb.width:height-_thumb.height;
			
			this.val+=offset/len;
		}
		
		private var _direction:String="vertical";
		private var _val:Number=0;
		private var _skins:String;
		private var _skinsArr:Array=["",""];
		private var _skinsMap:Dictionary=new Dictionary();
		private var _skin:BitmapSkin;
		private var _thumbSkin:BitmapSkin;
		private var _thumbRatio:Number=0.5;
		
		/**
		 * 方向 
		 * @param value
		 * 
		 */
		public function set direction(value:String):void{
			$direction=value;
			render();
		}
		public function get direction():String{
			return _direction;
		}
		public function set $direction(value:String):void{
			_direction=value;
		}
		/**
		 * 皮肤字符串:"路径，按钮" 
		 * @param value
		 * 
		 */		
		public function set skins(value:String):void{
			$skins=value;
			render();
		}
		public function get skins():String{
			return _skins;
		}
		public function set $skins(value:String):void{
			_skins=value;
			_skinsArr=StringUtil.fillArray(_skinsArr,value,String);
			for (var i:int=0;i<_skinsArr.length;i++){
				var skinStr:String=_skinsArr[i];
				if(skinStr){
					var bSkin:BitmapSkin=new BitmapSkin();
					bSkin.textureName=skinStr;
					_skinsMap[i]=bSkin;//BitmapSkin.createWithName(skinStr);
				}
			}
		}
		/**
		 * 路径皮肤 
		 * @param value
		 * 
		 */
		public function set barSkin(value:BitmapSkin):void{
			$barSkin=value;
			render();
		}
		public function get barSkin():BitmapSkin{
			return _skinsMap[BAR];
		}
		public function set $barSkin(value:BitmapSkin):void{
			_skinsMap[BAR]=value;
		}
		/**
		 * 按钮皮肤 
		 * @param value
		 * 
		 */
		public function set thumbSkin(value:BitmapSkin):void{
			$thumbSkin=value;
			render();
		}
		public function get thumbSkin():BitmapSkin{
			return _skinsMap[THUMB];
		}
		public function set $thumbSkin(value:BitmapSkin):void{
			_skinsMap[THUMB]=value;
		}
		/**
		 * 按钮大小比率，从0到1；
		 * @param value
		 * 
		 */		
		public function set thumbRatio(value:Number):void{
			$thumbRatio=value;
			render();
		}
		public function get thumbRatio():Number{
			return _thumbRatio;
		}
		public function set $thumbRatio(value:Number):void{
			_thumbRatio=value;
			if(_thumbRatio>1)
				_thumbRatio=1;
			if(_thumbRatio<0)
				_thumbRatio=0;
		}
		
		/**
		 * 当前值,从0到1
		 * @param value
		 * 
		 */
		public function set val(value:Number):void{
			$val=value;
			renderPosition();
		}
		public function get val():Number{
			return _val;
		}
		
		public function set $val(value:Number):void{
			_val=value;
			if(_val>1)
				_val=1;
			if(_val<0)
				_val=0;
		}
		
		//------------------------
		// 渲染
		//------------------------
		
		public function render():void{
			DebugUtil.traceProcessCurrent("render",this);
			//计算组件宽高
			var compW:Number=0,compH:Number=0;
			var barSize:Size=barSkin?Bitmap.getSkinSize(barSkin):null;
			if(!isNaN(width)){		//显式设置直接取宽度
				compW=width;
			}else{
				compW=barSize?barSize.width:((direction==HORIZONTAL)?HORIZONTAL_MIN:VERTICAL_MIN);
			}
			
			if(!isNaN(height)){
				compH=height;
			}else{
				compH=barSize?barSize.height:((direction==HORIZONTAL)?VERTICAL_MIN:HORIZONTAL_MIN);
			}
			_width=compW;
			_height=compH;
			
			if(width<=0 || height<=0) return;
			
			_bar.$width=width;
			_bar.$height=height;
			if(barSkin){		//使用皮肤
				_bar.$skin=barSkin;
				_bar.render();
				_bar.alpha=1;
			}else{			//使用矢量绘图
				var bartd:TextureData=TextureData.createRGB(_bar.width,_bar.height);
				var barSha:Shape=new Shape();
				barSha.graphics.beginFill(0x777777);
				barSha.graphics.drawRect(0,0,_bar.width,_bar.height);
				barSha.graphics.endFill();
				bartd.draw(barSha);
				_bar.texture=new Texture(bartd);
				_bar.alpha=0.67;
			}
			
			//滑块
			if(direction==HORIZONTAL){
				_thumb.$width=thumbRatio*width;
				_thumb.$height=thumbSkin?NaN:height;
			}else{
				_thumb.$height=thumbRatio*height;
				_thumb.$width=thumbSkin?NaN:width;
			}
			
			if(thumbSkin){
				_thumb.$skin=thumbSkin;
				_thumb.render();
				_thumb.alpha=1;
			}else{
				var thutd:TextureData=TextureData.createRGB(_thumb.width,_thumb.height);
				var thuSha:Shape=new Shape();
				thuSha.graphics.beginFill(0x333333);
				thuSha.graphics.drawRect(0,0,_thumb.width,_thumb.height);
				thuSha.graphics.endFill();
				thutd.draw(thuSha);
				_thumb.texture=new Texture(thutd);
				_thumb.alpha=0.67;
			}
			
			//渲染滑块位置
			renderPosition();
		}
		
		private function renderPosition():void{
			if(direction==HORIZONTAL){
				_thumb.x=(_bar.width-_thumb.width)*val;
				_thumb.y=(_bar.height-_thumb.height)/2;
			}else{
				_thumb.x=(_bar.width-_thumb.width)/2;
				_thumb.y=(_bar.height-_thumb.height)*val;
			}
		}
		
		override public function dispose():void{
			super.dispose();
			
			if(_thumb){
				removeChild(_thumb);
				_thumb.dispose();
				_thumb=null;
			}
			if(_bar){
				removeChild(_bar);
				_bar.dispose();
				_bar=null;
			}
			if(_pan){
				_pan.removeEventListener(GestureEvent.PAN_MOVE,onPan);
				_pan.dispose();
				_pan=null;
			}
		}
	}
}