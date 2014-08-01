package  potato.editor
{
	import core.display.DisplayObject;
	import core.display.Shape;
	import core.display.Texture;
	import core.display.TextureData;
	
	import potato.potato_internal;
	import potato.component.Bitmap;
	import potato.component.ISprite;
	import potato.component.SkinnableContainer;
	import potato.component.data.BitmapSkin;
	import potato.editor.layout.Layout;
	import potato.editor.layout.LayoutElement;
	
	/**
	 * 包含布局的容器
	 * @author liuxin
	 * 
	 */
	internal class LayoutContainer extends SkinnableContainer
		implements ILayoutContainer
	{
		public function LayoutContainer(skin:BitmapSkin=null,width:Number=NaN,height:Number=NaN)
		{
			$skin=skin;
			super(width,height);
		}
		use namespace potato_internal;
		//----------------------
		// property
		//----------------------
		protected var _bgBmp:Bitmap;
		
		private var _skin:BitmapSkin;
		private var _bgColor:uint=0;
		private var _bgAlpha:Number=1;
		private var _bgColorChanged:Boolean=false;
		
		/**
		 * 背景 
		 * @return 
		 * 
		 */
		public function get skin():BitmapSkin
		{
			return _skin;
		}
		
		/**
		 * 皮肤 
		 * @param value
		 * 
		 */
		public function set skin(value:BitmapSkin):void
		{
			$skin=value;
			render();
		}
		potato_internal function set $skin(value:BitmapSkin):void{
			_skin = value;
		}
		
		/**
		 * 背景色 
		 * @return 
		 * 
		 */
		public function get bgColor():uint
		{
			return _bgColor;
		}
		
		public function set bgColor(value:uint):void
		{
			$bgColor = value;
			render();
		}
		
		potato_internal function set $bgColor(value:uint):void{
			_bgColor = value;
			_bgColorChanged=true;
		}
		
		/**
		 * 背景透明度
		 * @return 
		 * 
		 */		
		public function get bgAlpha():Number
		{
			return _bgAlpha;
		}
		
		public function set bgAlpha(value:Number):void
		{
			_bgAlpha = value;
			render();
		}
		override protected function createChildren():void{
			super.createChildren();
			
			_bgBmp=new Bitmap();
			background.addChild(_bgBmp);
		}
		
		
		override public function render():void{
			if(_skin)		//皮肤
			{
				_bgBmp.$skin=_skin;
				if(!isNaN(_width))
					_bgBmp.$width=_width;
				if(!isNaN(_height))
					_bgBmp.$height=_height;
				
				_bgBmp.render();
			}else if(_bgColorChanged && !isNaN(_width) && !isNaN(_height)){		//背景色
				var bgtd:TextureData=TextureData.createRGB(_width,_height);
				var barSha:Shape=new Shape();
				barSha.graphics.beginFill(_bgColor);
				barSha.graphics.drawRect(0,0,_width,_height);
				barSha.graphics.endFill();
				bgtd.draw(barSha);
				_bgBmp.$width=_width;
				_bgBmp.$height=_height;
				_bgBmp.texture=new Texture(bgtd);
			}else
			{
				_bgBmp.texture=null;
			}
			if(_bgBmp.texture)
				_bgBmp.alpha=bgAlpha;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject{
			if(child is ISprite)
				attachChildLayout(ISprite(child));
			if(child is ILayoutContainer)
				ILayoutContainer(child).layoutParent=this;
			
			return super.addChild(child);
		}
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject{
			if(child is ISprite)
				attachChildLayout(ISprite(child));
			if(child is ILayoutContainer)
				ILayoutContainer(child).layoutParent=this;
			
			return super.addChildAt(child,index);
		}
		override public function removeChild(child:DisplayObject):DisplayObject{
			if(child is ISprite)
				attachChildLayout(ISprite(child));
			if(child is ILayoutContainer)
				ILayoutContainer(child).layoutParent=null;
			
			return super.removeChild(child);
		}
		override public function removeChildAt(index:int):DisplayObject{
			var child:DisplayObject=super.getChildAt(index);
			if(child is ISprite)
				attachChildLayout(ISprite(child));
			if(child is ILayoutContainer)
				ILayoutContainer(child).layoutParent=null;
			
			return super.removeChildAt(index);
		}
		
		/**
		 * 附加子项的布局 
		 * @param view
		 * 
		 */
		public function attachChildLayout(sprite:ISprite):void{
			if(layout && layout is Layout){
				if(sprite is ILayoutContainer){
					var cont:ILayoutContainer=ILayoutContainer(sprite);
					if(cont.includeinLayout){
						cont.isRootLayout=false;
						Layout(layout).add(cont.layout?cont.layout:ISprite(cont));
					}
					else{
						cont.isRootLayout=true;
						Layout(layout).remove(cont.layout?cont.layout:ISprite(cont));
					}
				}else{
					Layout(layout).add(sprite);
				}
			}else{
				if(sprite is ILayoutContainer)
					ILayoutContainer(sprite).isRootLayout=true;
			}
				
		}
		
		//----------------------
		// 	layouts
		//----------------------
		protected var _layout:LayoutElement;
		private var _layoutParent:ILayoutContainer;
		public function get layout():LayoutElement
		{
			return _layout;
		}
		
		public function set layout(value:LayoutElement):void
		{
			_layout = value;
			for (var i:int=0;i<this.numChildren;i++){
				var child:DisplayObject=this.getChildAt(i);
				if(child is ISprite)
					attachChildLayout(ISprite(child));
			}
			if(layoutParent)
				layoutParent.attachChildLayout(this);
		}
		
		public function get layoutParent():ILayoutContainer
		{
			return _layoutParent;
		}
		
		public function set layoutParent(value:ILayoutContainer):void
		{
			_layoutParent = value;
		}
		
		
		protected var _includeinLayout:Boolean=true;
		public function set includeinLayout(value:Boolean):void{
			_includeinLayout=value;
			if(layoutParent)
				layoutParent.attachChildLayout(this);
		}
		public function get includeinLayout():Boolean{
			return _includeinLayout;
		}
		
		protected var _isRootLayout:Boolean=false;
		public function set isRootLayout(value:Boolean):void{
			_isRootLayout=value;
		}
		public function get isRootLayout():Boolean{
			return _isRootLayout;
		}
		
		override public function dispose():void{
			super.dispose();
			
			this.layoutParent=null;
			if(layout){
				this.layout.dispose();
				this.layout=null;
			}
		}
	}
}