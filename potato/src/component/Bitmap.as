package potato.component
{
	import flash.geom.Rectangle;
	
	import core.display.Grid9Texture;
	import core.display.Image;
	import core.display.Texture;
	
	import potato.component.data.BitmapSkin;
	import potato.component.interf.IDataBinding;
	import potato.component.interf.ISprite;
	import potato.manager.RenderManager;
	import potato.utils.Filters;
	import potato.utils.StringUtil;

	/**
	 * 图像.
	 * <p>如果设置宽高，图像依据宽高和九宫格拉伸，否则为资源纹理的宽高。要使用滤镜，必须设置useGrid属性为false</p>
	 * @author liuxin
	 * 
	 */
	public class Bitmap extends Image 
		implements ISprite,IDataBinding
	{
		/**
		 * 创建图像
		 * @param skin	皮肤
		 * @param width 宽
		 * @param height 高
		 * 
		 */
		public function Bitmap(skin:BitmapSkin=null,width:Number=NaN,height:Number=NaN)
		{
			super(null);
			
			this.skin=skin;
			this.width=width;
			this.height=height;
		}
		
		//----------------------------
		//	ISprite
		//----------------------------
		private var _width:Number;
		private var _height:Number;
		private var _measureWidth:Number=0;
		private var _measureHeight:Number=0;
		private var _scale:Number;
		private var _disable:Boolean=false;
		private var _grid9Arr:Array=[0,0,0,0];
		private var _skin:BitmapSkin;
		private var _validateMode:uint=RenderManager.CALLLATER;
		private var _texture:Texture;
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
				return skin?skin.width:(texture?texture.width:0);
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
				return skin?skin.height:(texture?texture.height:0);
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
		
		/**
		 * 自动计算的x缩放 
		 */
		private var _inScaleX:Number=1;
		private var _inScaleY:Number=1;
		/**
		 * 显式设置的x缩放 
		 */
		private var _scaleX:Number=1;
		private var _scaleY:Number=1;
		
		override public function set scaleX(_arg1:Number):void{
			_scaleX=_arg1;
			super.scaleX=_scaleX*_inScaleX;
		}
		override public function get scaleX():Number{
			return _scaleX;
		}
		
		
		
		override public function set scaleY(_arg1:Number):void{
			_scaleY=_arg1;
			super.scaleY=_scaleY*_inScaleY;
		}
		override public function get scaleY():Number{
			return _scaleY;
		}
		
		/**
		 * 是否禁用
		 * @param value
		 * 
		 */
		public function set disable(value:Boolean):void{
			_disable=value;
			this.filter=_disable?Filters.FILTER_IMG_GRAY:null;
		}
		public function get disable():Boolean{
			return _disable;
		}
		
		
		/**
		 * 皮肤 
		 * @return 
		 * 
		 */
		public function get skin():BitmapSkin
		{
			return _skin;
		}
		
		public function set skin(value:BitmapSkin):void
		{
			_skin = value;
			invalidate(render);
		}
		
		override public function set texture(value:Texture):void{
			_texture=value;
			invalidate(render);
		}
		override public function get texture():Texture{
			return _texture;
		}
		
		private function set $texture(value:Texture):void{
			super.texture=value;
		}
		private function get $texture():Texture{
			return super.texture;
		}
		//------------------------
		//	override
		//------------------------
		private function render():void{
			
//			trace("__________render")
			var tex:Texture;
			if(_skin && _skin.getTexture())
				tex=_skin.getTexture();
			else
				tex=_texture;
			
			_inScaleX=1;
			_inScaleY=1;
			if(tex &&(width!=tex.width || height!=tex.height)){
				if(_skin && _skin.grid9){		//grid9Textrue
					_grid9Arr=StringUtil.fillArray(_grid9Arr,_skin.grid9,Number);
					var rectx:Number,recty:Number,rectw:Number,recth:Number;
					rectx=_grid9Arr[0]>0?_grid9Arr[0]:0;
					recty=_grid9Arr[1]>0?_grid9Arr[1]:0;
					var tempw:Number,temph:Number;
					tempw=tex.width-_grid9Arr[0]-_grid9Arr[2];
					temph=tex.height-_grid9Arr[1]-_grid9Arr[3];
					rectw=tempw<0?0:tempw;
					recth=temph<0?0:temph;
					$texture=new Grid9Texture(tex,new Rectangle(rectx,recty,rectw,recth),width,height);;
				}else{ //scale
					$texture=tex;
					_inScaleX=width/tex.width;	
					_inScaleY=height/tex.height;
				}
			}else{
				$texture=tex;
			}
			super.scaleX=_scaleX*_inScaleX;
			super.scaleY=_scaleY*_inScaleY;
		}
		
		/**
		 * 释放资源
		 * 
		 */		
		override public function dispose():void{
			super.dispose();
			RenderManager.dispose(this);
			if($texture){
				$texture=null;
			}
		}
	}
}