package potato.component
{
	import flash.geom.Rectangle;
	
	import core.display.Image;
	import core.display.Shape;
	import core.display.Texture;
	import core.display.TextureData;
	import core.events.Event;
	import core.events.TouchEvent;
	
	import potato.component.controller.EaseingPanController;
	import potato.component.controller.PanController;
	import potato.event.GestureEvent;
	import potato.gesture.PanGesture;
	import potato.manager.RenderManager;
	
	import tweenLite.TweenLite;
	
	/**
	 * 可滚动的容器. 
	 * <p>使用contentWidth和contentHeight为滚动容器设置内容区域大小，超出内容区域的部分将被裁剪。
	 * 如果不设置内容区域大小，滚动容器将使用完整显示所有内容的大小。</p>
	 * 
	 * <p>可以滚动禁用水平或者垂直方向的滚动，也可以禁止滚动条的显示，设置滚动位置等，并且设置移动控制器，默认为AreaEaseingPanController控制器</p>
	 * @author liuxin
	 * 
	 * @see AreaEaseingPanController
	 */
	public class ScrollableContainer extends BorderContainer
	{
		/**
		 * 创建滚动容器
		 * @param width 宽
		 * @param height 高
		 * 
		 */
		public function ScrollableContainer(width:Number=NaN,height:Number=NaN)
		{
			super(width,height);
			_scrollPan=new PanGesture(this,false);
			_scrollPan.addEventListener(GestureEvent.GESTURE_TOUCH_BEGIN,onContentPanBegin);
			_scrollPan.addEventListener(GestureEvent.PAN_BEGIN,onContentPanStart);
			_scrollPan.addEventListener(GestureEvent.PAN_MOVE,onContentPanMove);
			_scrollPan.addEventListener(GestureEvent.PAN_END,onContentPanEnd);
//			
			panController=new EaseingPanController();
			this.addEventListener(TouchEvent.TOUCH_BEGIN,onContentBegin);
			this.addEventListener(TouchEvent.TOUCH_END,onContentEnd);
		}
		
		
		static private const DEFAULT_MIN_WIDTH:Number=200;
		static private const DEFAULT_MIN_HEIGHT:Number=200;
		
		//-------------------------
		// assets
		//------------------------
		private var _scrollPan:PanGesture;
		private var _vScroller:Scroller;
		private var _hScroller:Scroller;
		private var _contentBg:Image;
		private var _panController:PanController;
		
		override protected function createChildren():void{
			super.createChildren();
			
			_contentBg=new Image(null);
			background.addChild(_contentBg);
			_hScroller=new Scroller("",Slider.HORIZONTAL);
			_hScroller.height=10;
			_hScroller.alpha=0;
			_hScroller.validateMode=RenderManager.IMMEDIATELY;
			front.addChild(_hScroller);
			_vScroller=new Scroller("",Slider.VERTICAL);
			_vScroller.width=10;
			_vScroller.alpha=0;
			_vScroller.validateMode=RenderManager.IMMEDIATELY;
			front.addChild(_vScroller);
		}
		
		/**
		 * 平移控制器,默认为AreaPanController。可以设置不同的平移控制器实现不同的滚动特效
		 * @return 
		 * 
		 */
		public function get panController():PanController
		{
			return _panController;
		}
		
		public function set panController(value:PanController):void
		{
			_panController = value;
			_panController.addEventListener(PanController.UPDATE,onPanUpdate);
		}
		//-----------------------------
		// properties
		//-----------------------------
		private var _contentWidth:Number;
		private var _contentHeight:Number;
		
		private var _scrollX:Number=0;
		private var _scrollY:Number=0;
		private var _hScrollEnable:Boolean=true;
		private var _vScrollEnable:Boolean=true;
		private var _hScrollerVisible:Boolean=true;
		private var _vScrollerVisible:Boolean=true;
		private var _vScrollerSkins:*;
		private var _hScrollerSkins:*;
		
		
		override public function get width():Number{
			if(!isNaN(_width))
				return _width;
			else
				return contentWidth;
		}
		
		override public function get height():Number{
			if(!isNaN(_height))
				return _height;
			else
				return contentHeight;
		}
		
		/**
		 * 内容宽度 
		 * @return 
		 * 
		 */
		public function set contentWidth(value:Number):void{
			if(_contentWidth!=value){
				_contentWidth=value;
				invalidate(render);
			}
		}
		public function get contentWidth():Number{
			if(!isNaN(_contentWidth))
				return _contentWidth;
			else
				return measureWidth;
		}
		
		/**
		 * 内容高度 
		 * @return 
		 * 
		 */
		public function set contentHeight(value:Number):void{
			if(_contentHeight!=value){
				_contentHeight=value;
				invalidate(render);
			}
		}
		public function get contentHeight():Number{
			if(!isNaN(_contentHeight))
				return _contentHeight;
			else
				return measureHeight;
		}
		
		/**
		 * 垂直滚动可用 
		 * @return 
		 * 
		 */		
		public function get vScrollEnable():Boolean
		{
			return _vScrollEnable;
		}
		
		public function set vScrollEnable(value:Boolean):void
		{
			if(_vScrollEnable!=value){
				_vScrollEnable = value;
				invalidate(renderScroller);
			}
		}
		
		/**
		 * 水平滚动可用 
		 * @return 
		 * 
		 */
		public function get hScrollEnable():Boolean
		{
			return _hScrollEnable;
		}
		
		public function set hScrollEnable(value:Boolean):void
		{
			if(_hScrollEnable!=value){
				_hScrollEnable = value;
				invalidate(renderScroller);
			}
		}

		/**
		 * 显示垂直滚动条 
		 * @return 
		 * 
		 */		
		public function get vScrollerVisible():Boolean
		{
			return _vScrollerVisible;
		}
		
		public function set vScrollerVisible(value:Boolean):void
		{
			_vScrollerVisible = value;
		}
		
		/**
		 * 显示水平 滚动条 
		 * @return 
		 * 
		 */
		public function get hScrollerVisible():Boolean
		{
			return _hScrollerVisible;
		}
		
		public function set hScrollerVisible(value:Boolean):void
		{
			_hScrollerVisible = value;
		}
		
		/**
		 * 水平滚动条皮肤 
		 * @return 
		 * 
		 */
		public function get hScrollerSkins():*
		{
			return _hScrollerSkins;
		}
		
		public function set hScrollerSkins(value:*):void
		{
			_hScrollerSkins = value;
			invalidate(renderScroller);
		}
		
		/**
		 * 垂直滚动条皮肤 
		 * @return 
		 * 
		 */
		public function get vScrollerSkins():*
		{
			return _vScrollerSkins;
		}
		
		public function set vScrollerSkins(value:*):void
		{
			_vScrollerSkins = value;
			invalidate(renderScroller);
		}

		
		/**
		 * y轴滚动位置 
		 * @return 
		 * 
		 */
		public function get scrollY():Number
		{
			return _scrollY;
		}
		
		public function set scrollY(value:Number):void
		{
			if(_scrollY!=value){
				_scrollY = value;
				if(isNaN(_scrollY))
					return;
				
				content.y=-_scrollY;
				if(contentHeight==height)
					_vScroller.val=0;
				else
					_vScroller.val=_scrollY/(contentHeight-height);
				
				if(_panController)
					_panController.y=-_scrollY;
			}
			renderClip();
		}
		
		/**
		 * x轴滚动位置 
		 * @return 
		 * 
		 */
		public function get scrollX():Number
		{
			return _scrollX;
		}
		
		public function set scrollX(value:Number):void
		{
			if(_scrollX!=value){
				_scrollX = value;
				
				if(isNaN(_scrollX))
					return;
				content.x=-_scrollX;
				if(contentWidth==width)
					_hScroller.val=0;
				else
					_hScroller.val=_scrollX/(contentWidth-width);
				
				if(_panController)
					_panController.x=-_scrollX;
			}
			renderClip();
		}
		
		//---------------------------
		// event handler
		//---------------------------
		private function onContentPanBegin(e:Event):void{
			_panController.panBegin(_scrollPan);
		}
		private function onContentPanStart(e:Event):void{
			_panController.panStart(_scrollPan);
		}
		private function onContentPanMove(e:Event):void{
			_panController.panMove(_scrollPan);
		}
		private function onContentPanEnd(e:Event):void{
			_panController.panEnd(_scrollPan);
		}
		
		private function onPanUpdate(e:Event):void{
			if(_hScrollEnable)
				scrollX=-_panController.x;
			if(_vScrollEnable)
				scrollY=-_panController.y;
		}
		
		private function onContentBegin(e:TouchEvent):void{
			if(_vScrollerVisible)
				TweenLite.to(_vScroller,0.6,{alpha:1});
			if(_hScrollerVisible)
				TweenLite.to(_hScroller,0.6,{alpha:1});
		}
		private function onContentEnd(e:TouchEvent):void{
			if(_vScrollerVisible)
				TweenLite.to(_vScroller,0.6,{alpha:0});
			if(_hScrollerVisible)
				TweenLite.to(_hScroller,0.6,{alpha:0});
		}
		
		//------------------------
		// 渲染
		//------------------------
		/**
		 * 渲染组件内容 
		 * 
		 */
		override protected function render():void{
			if(!content) return;
			
			var w:Number=width;
			var h:Number=height;
			var cw:Number=contentWidth;
			var ch:Number=contentHeight;
			if(w!=0 && h!=0){
//				trace("w:"+w+",h:"+h+",cw:"+cw+",ch:"+ch);
				_panController.setArea(w,h,cw,ch);
				var td:TextureData=TextureData.createRGB(w,h);
				var sp:Shape=new Shape();
				sp.graphics.beginFill(0xffffff);
				sp.graphics.drawRect(0,0,w,h);
				sp.graphics.endFill();
				td.draw(sp);
				_contentBg.texture=new Texture(td);
				_contentBg.alpha=0;
				//滚动条
				renderScroller();
			}
			
			
			super.render();
		}
		
		private function renderScroller():void{
			if(_vScrollerSkins){
				_vScroller.skins=_vScrollerSkins;
				_vScroller.width=NaN;
			}
			if(_hScrollerSkins){
				_hScroller.skins=_hScrollerSkins;
				_hScroller.height=NaN;
			}
			
			_vScroller.x=width-_vScroller.width;
			_vScroller.height=(_hScrollEnable?height-_hScroller.height:height);
			_vScroller.thumbRatio=(contentHeight==0?1:height/contentHeight);
			_hScroller.y=height-_hScroller.height;
			_hScroller.width=(_vScrollEnable?width-_vScroller.width:width);
			_hScroller.thumbRatio=(contentWidth==0?1:width/contentWidth);
			//重设滚动位置
			scrollX=scrollX;
			scrollY=scrollY;
		}
		
		/**
		 * 渲染裁剪区域 
		 * 
		 */
		private function renderClip():void{
//			trace("scrollX:"+scrollX+",scrollY:"+scrollY+",w:"+width+"h:"+height)
			content.clipRect=new Rectangle(scrollX,scrollY,width,height);
		}
		
		/**
		 *释放资源 
		 * 
		 */		
		override public function dispose():void{
			super.dispose();
			
			if(_contentBg){
				background.removeChild(_contentBg);
				_contentBg.dispose();
				_contentBg=null;
			}
			if(_vScroller){
				front.removeChild(_vScroller);
				_vScroller.dispose();
				_vScroller=null;
			}
			if(_hScroller){
				front.removeChild(_hScroller);
				_hScroller.dispose();
				_hScroller=null;
			}
			if(_panController){
				_panController.removeEventListener(PanController.UPDATE,onPanUpdate);
				_panController=null;
			}
			if(_scrollPan){
				_scrollPan.removeEventListener(GestureEvent.GESTURE_TOUCH_BEGIN,onContentPanBegin);
				_scrollPan.removeEventListener(GestureEvent.PAN_BEGIN,onContentPanStart);
				_scrollPan.removeEventListener(GestureEvent.PAN_MOVE,onContentPanMove);
				_scrollPan.removeEventListener(GestureEvent.PAN_END,onContentPanEnd);
				_scrollPan.dispose();
				_scrollPan=null;
			}
			
			removeEventListener(TouchEvent.TOUCH_BEGIN,onContentBegin);
			removeEventListener(TouchEvent.TOUCH_END,onContentEnd);
			
		}
	}
}