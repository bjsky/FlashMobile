package potato.component
{
	import flash.utils.Dictionary;
	
	import core.display.DisplayObjectContainer;
	import core.display.Shape;
	import core.display.Texture;
	import core.display.TextureData;
	import core.events.Event;
	
	import potato.component.data.BitmapSkin;
	import potato.component.data.Padding;
	import potato.component.interf.IDataBinding;
	import potato.component.interf.ISprite;
	import potato.event.GestureEvent;
	import potato.gesture.PanGesture;
	import potato.manager.RenderManager;
	import potato.utils.StringUtil;

	/**
	 * 滑块.
	 * @author liuxin
	 * 
	 */
	public class Slider extends DisplayObjectContainer
		implements ISprite,IDataBinding
	{
		/**
		 *  
		 * @param skins
		 * @param direction
		 * @param width
		 * @param height
		 * @param val
		 * 
		 */
		public function Slider(skins:String="",direction:String="horizontal",width:Number=NaN,height:Number=NaN,val:Number=0,thumbPadding:Padding=null)
		{
			super();
			createChildren();
			
			this.skins=skins;
			this.direction=direction;
			this.val=val;
			this.width=width;
			this.height=height;
			this.thumbPadding=thumbPadding;
		}
		
		
		static public const VERTICAL:String="vertical";
		static public const HORIZONTAL:String="horizontal";
		
		static private const HORIZONTAL_MIN:Number=200;
		static private const VERTICAL_MIN:Number=20;
		static private const BAR_SKIN:uint=0;		
		static private const THUMB_SKIN:uint=1;
		
		//----------------------------
		//	ISprite
		//----------------------------
		private var _width:Number;
		private var _height:Number;
		private var _scale:Number;
		private var _validateMode:uint=RenderManager.CALLLATER;
		private var _dataProvider:Object;
		
		/**
		 * 数据绑定 
		 * @return 
		 * 
		 */
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:Object):void
		{
			_dataProvider = value;
			for (var prop:String in _dataProvider) {
				if (hasOwnProperty(prop)) {
					if(this[prop] is IDataBinding)
						IDataBinding(this[prop]).dataProvider=_dataProvider[prop];
					else
						this[prop] = _dataProvider[prop];
				}
			}
		}
		
		/**
		 * 渲染模式
		 * @return 
		 * 
		 */
		public function get validateMode():uint
		{
			return _validateMode;
		}
		
		public function set validateMode(value:uint):void
		{
			_validateMode = value;
			RenderManager.validateNow(this);
		}
		
		/**
		 * 组件失效
		 * @param method
		 * @param args
		 * 
		 */
		public function invalidate(method:Function, args:Array = null):void{
			RenderManager.invalidateProperty(this,method,args);
		}
		
		/**
		 * 验证
		 * 
		 */
		public function validate():void{
			render();
		}
		
		/**
		 * 宽度
		 * @param value
		 * 
		 */
		public function set width(value:Number):void{
			if(_width!=value){
				_width=value;
				invalidate(render);
			}
		}
		override public function get width():Number{
			if(!isNaN(_width))
				return _width;
			else
				return barSkin?barSkin.width:((direction==HORIZONTAL)?HORIZONTAL_MIN:VERTICAL_MIN);
		}
		
		/**
		 * 高度 
		 * @param value
		 * 
		 */
		public function set height(value:Number):void{
			if(_height!=value){
				_height=value;
				invalidate(render);
			}
		}
		override public function get height():Number{
			if(!isNaN(_height))
				return _height;
			else
				return barSkin?barSkin.height:((direction==HORIZONTAL)?VERTICAL_MIN:HORIZONTAL_MIN);
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
		protected var _thumb:Bitmap;
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
		private var _skins:*;
		private var _skinsArr:Array=[null,null];
		private var _skinsMap:Dictionary=new Dictionary();
		private var _skin:BitmapSkin;
		private var _thumbSkin:BitmapSkin;
		private var _thumbPadding:Padding;
		
		/**
		 * 方向 
		 * @param value
		 * 
		 */
		public function set direction(value:String):void{
			if(_direction!=value){
				_direction=value;
				invalidate(render);
			}
		}
		public function get direction():String{
			return _direction;
		}
		
		/**
		 * 皮肤字符串:"路径，按钮" 
		 * @param value
		 * 
		 */		
		public function set skins(value:*):void{
			_skins=value;
			_skinsArr=StringUtil.fillSkins(_skinsArr,value);
			for (var i:int=0;i<_skinsArr.length;i++){
				_skinsMap[i]=_skinsArr[i];//BitmapSkin.createWithName(skinStr);
			}
			invalidate(render);
		}
		public function get skins():*{
			return _skins;
		}
		
		/**
		 * 路径皮肤 
		 * @param value
		 * 
		 */
		public function set barSkin(value:BitmapSkin):void{
			_skinsMap[BAR_SKIN]=value;
			invalidate(render);
		}
		public function get barSkin():BitmapSkin{
			return _skinsMap[BAR_SKIN];
		}
		
		/**
		 * 路径填充 
		 * @return 
		 * 
		 */
		public function get thumbPadding():Padding
		{
			return _thumbPadding;
		}
		
		public function set thumbPadding(value:Padding):void
		{
			_thumbPadding = value;
			
			invalidate(render);
		}

		/**
		 * 按钮皮肤 
		 * @param value
		 * 
		 */
		public function set thumbSkin(value:BitmapSkin):void{
			_skinsMap[THUMB_SKIN]=value;
			invalidate(render);
		}
		public function get thumbSkin():BitmapSkin{
			return _skinsMap[THUMB_SKIN];
		}
		
		/**
		 * 当前值,从0到1
		 * @param value
		 * 
		 */
		public function set val(value:Number):void{
			_val=value;
			if(_val>1)
				_val=1;
			if(_val<0)
				_val=0;
			invalidate(renderPosition);
		}
		public function get val():Number{
			return _val;
		}
		
		//------------------------
		// 渲染
		//------------------------
		/**
		 * 渲染组件内容 
		 * 
		 */
		protected function render():void{
			if(width<0 || height<0) return;
			
			
			if(barSkin){		//使用皮肤
				_bar.width=width;
				_bar.height=height;
				_bar.skin=barSkin;
				_bar.alpha=1;
			}else{			//使用矢量绘图
				var bartd:TextureData=TextureData.createRGB(width,height);
				var barSha:Shape=new Shape();
				barSha.graphics.beginFill(0x777777);
				barSha.graphics.drawRect(0,0,width,height);
				barSha.graphics.endFill();
				bartd.draw(barSha);
				_bar.texture=new Texture(bartd);
				_bar.alpha=0.67;
			}
			//滑块
			renderThumb();
			//渲染滑块位置
			renderPosition();
		}
		
		protected function renderThumb():void{
			if(thumbSkin){
				_thumb.skin=thumbSkin;
				_thumb.alpha=1;
			}else{
				var thutd:TextureData=TextureData.createRGB(20,20);
				var thuSha:Shape=new Shape();
				thuSha.graphics.beginFill(0x333333);
				thuSha.graphics.drawRect(0,0,20,20);
				thuSha.graphics.endFill();
				thutd.draw(thuSha);
				_thumb.texture=new Texture(thutd);
				_thumb.alpha=0.67;
			}
		}
		
		private function renderPosition():void{
			var tx:Number=_thumbPadding?_thumbPadding.paddingLeft:0;
			var ty:Number=_thumbPadding?_thumbPadding.paddingTop:0;
			var tw:Number=width-(_thumbPadding?_thumbPadding.paddingLeft+_thumbPadding.paddingRight:0);
			var th:Number=height-(_thumbPadding?_thumbPadding.paddingTop+_thumbPadding.paddingBottom:0)
			if(direction==HORIZONTAL){
				_thumb.x=(tw-_thumb.width)*val+tx;
				_thumb.y=(_bar.height-_thumb.height)/2;
			}else{
				_thumb.x=(_bar.width-_thumb.width)/2;
				_thumb.y=(th-_thumb.height)*val+ty;
			}
		}
		
		/**
		 * 释放资源 
		 * 
		 */
		override public function dispose():void{
			super.dispose();
			RenderManager.dispose(this);
			
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