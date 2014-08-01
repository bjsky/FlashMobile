package potato.component
{
	import flash.geom.Rectangle;
	
	import core.display.DisplayObject;
	import core.display.DisplayObjectContainer;
	import core.display.Shape;
	import core.display.Texture;
	import core.display.TextureData;
	import core.events.Event;
	import core.events.TouchEvent;
	
	import potato.component.controller.AreaEaseingPanController;
	import potato.component.controller.AreaPanController;
	import potato.event.GestureEvent;
	import potato.gesture.PanGesture;
	import potato.utils.DebugUtil;
	
	import tweenLite.TweenLite;
	
	public class ScrollContainer extends SkinnableContainer
	{
		public function ScrollContainer(width:Number=NaN,height:Number=NaN)
		{
			_contentPan=new PanGesture(this,false);
			_contentPan.addEventListener(GestureEvent.TOUCH_BEGIN,onContentPanBegin);
			_contentPan.addEventListener(GestureEvent.PAN_BEGIN,onContentPanStart);
			_contentPan.addEventListener(GestureEvent.PAN_MOVE,onContentPanMove);
			_contentPan.addEventListener(GestureEvent.PAN_END,onContentPanEnd);
//			panController=new AreaPanController();
			panController=new AreaEaseingPanController();
			this.addEventListener(TouchEvent.TOUCH_BEGIN,onContentBegin);
			this.addEventListener(TouchEvent.TOUCH_END,onContentEnd);
			
			super(width,height);
		}
		
		
		static private const DEFAULT_MIN_WIDTH:Number=200;
		static private const DEFAULT_MIN_HEIGHT:Number=200;
		
		//----------------------------
		//	ISprite
		//----------------------------
		private var _measureWidth:Number;
		private var _measureHeight:Number;

		
		/**
		 * 宽度
		 * @param value
		 * 
		 */
		override public function get width():Number{
			if(!isNaN(_width))
				return _width;
			else
				return _measureWidth;
		}
		/**
		 * 高度 
		 * @param value
		 * 
		 */
		override public function get height():Number{
			if(!isNaN(_height))
				return _height;
			else
				return _measureHeight;
		}
		//-------------------------
		// assets
		//------------------------
		private var _enablePan:Boolean=true;
		private var _contentPan:PanGesture;
		private var _vScroller:Scroller;
		private var _hScroller:Scroller;
		private var _contentBg:Bitmap;
		private var _panController:AreaPanController;
		
		
		public function get contentPan():PanGesture{
			return _contentPan;
		}
		
		override protected function createChildren():void{
			super.createChildren();
			
			_contentBg=new Bitmap();
			background.addChild(_contentBg);
			_hScroller=new Scroller("",Scroller.HORIZONTAL);
			_hScroller.height=10;
			_hScroller.alpha=0;
			front.addChild(_hScroller);
			_vScroller=new Scroller("",Scroller.VERTICAL);
			_vScroller.width=10;
			_vScroller.alpha=0;
			front.addChild(_vScroller);
		}
		
		/**
		 * 平移控制器 
		 * @return 
		 * 
		 */
		public function get panController():AreaPanController
		{
			return _panController;
		}
		
		public function set panController(value:AreaPanController):void
		{
			_panController = value;
			_panController.addEventListener(AreaPanController.UPDATE,onPanUpdate);
		}
		//-----------------------------
		// properties
		//-----------------------------
		private var _contentWidth:Number;
		private var _contentHeight:Number;
		private var _measureContentWidth:Number;
		private var _measureContentHeight:Number;
		
		private var _scrollX:Number=0;
		private var _scrollY:Number=0;
		private var _horizontalScrollEnable:Boolean=true;
		private var _verticalScrollEnable:Boolean=true;
		private var _horizontalScrollerVisible:Boolean=true;
		private var _verticalScrollerVisible:Boolean=true;
		/**
		 * 内容宽度 
		 * @return 
		 * 
		 */
		public function set contentWidth(value:Number):void{
			$contentWidth=value;
			render();
		}
		public function get contentWidth():Number{
			if(!isNaN(_contentWidth))
				return _contentWidth;
			else
				return _measureContentWidth;
		}
		public function set $contentWidth(value:Number):void{
			_contentWidth=value;
		}
		
		/**
		 * 内容高度 
		 * @return 
		 * 
		 */
		public function set contentHeight(value:Number):void{
			$contentHeight=value;
			render();
		}
		public function get contentHeight():Number{
			if(!isNaN(_contentHeight))
				return _contentHeight;
			else
				return _measureContentHeight;
		}
		public function set $contentHeight(value:Number):void{
			_contentHeight=value;
		}
		
		/**
		 * 垂直滚动可用 
		 * @return 
		 * 
		 */		
		public function get verticalScrollEnable():Boolean
		{
			return _verticalScrollEnable;
		}
		
		public function set verticalScrollEnable(value:Boolean):void
		{
			$verticalScrollEnable = value;
			renderScroller();
		}
		
		public function set $verticalScrollEnable(value:Boolean):void{
			_verticalScrollEnable = value;
		}
		
		/**
		 * 水平滚动可用 
		 * @return 
		 * 
		 */
		public function get horizontalScrollEnable():Boolean
		{
			return _horizontalScrollEnable;
		}
		
		public function set horizontalScrollEnable(value:Boolean):void
		{
			$horizontalScrollEnable = value;
			renderScroller();
		}
		
		public function set $horizontalScrollEnable(value:Boolean):void{
			_horizontalScrollEnable = value;
		}
		
		/**
		 * 显示垂直滚动条 
		 * @return 
		 * 
		 */		
		public function get verticalScrollerVisible():Boolean
		{
			return _verticalScrollerVisible;
		}
		
		public function set verticalScrollerVisible(value:Boolean):void
		{
			_verticalScrollerVisible = value;
		}
		
		/**
		 * 显示水平 滚动条 
		 * @return 
		 * 
		 */
		public function get horizontalScrollerVisible():Boolean
		{
			return _horizontalScrollerVisible;
		}
		
		public function set horizontalScrollerVisible(value:Boolean):void
		{
			_horizontalScrollerVisible = value;
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
			$scrollY=value;
			if(_panController)
				_panController.y=-_scrollY;
			
		}
		public function set $scrollY(value:Number):void{
			_scrollY = value;
			if(isNaN(_scrollY))
				return;
			
			//			if(_scrollY<0)
			//				_scrollY=0;
			//			if(_scrollY>contentHeight-height)
			//				_scrollY=contentHeight-height;
			
			content.y=-_scrollY;
			if(contentHeight==height)
				_vScroller.val=0;
			else
				_vScroller.val=_scrollY/(contentHeight-height);
			
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
			$scrollX=value;
			if(_panController)
				_panController.x=-_scrollX;
			
		}
		public function set $scrollX(value:Number):void{
			_scrollX = value;
			
			if(isNaN(_scrollX))
				return;
			//			if(_scrollX<0)
			//				_scrollX=0;
			//			if(_scrollX>contentWidth-width)
			//				_scrollX=contentWidth-width;
			//			
			content.x=-_scrollX;
			if(contentWidth==width)
				_hScroller.val=0;
			else
				_hScroller.val=_scrollX/(contentWidth-width);
			
			renderClip();
		}
		
		//---------------------------
		// event handler
		//---------------------------
		private function onContentPanBegin(e:Event):void{
			_panController.panBegin(_contentPan);
//			trace("begin");
		}
		private function onContentPanStart(e:Event):void{
			_panController.panStart(_contentPan);
//			trace("start");
		}
		private function onContentPanMove(e:Event):void{
			_panController.panMove(_contentPan);
//			trace("move");
		}
		private function onContentPanEnd(e:Event):void{
			_panController.panEnd(_contentPan);
//			trace("end");
		}
		
		private function onPanUpdate(e:Event):void{
			if(_horizontalScrollEnable)
				$scrollX=-_panController.x;
			if(_verticalScrollEnable)
				$scrollY=-_panController.y;
		}
		
		private function onContentBegin(e:TouchEvent):void{
//			TweenLite.killTweensOf(_vScroller);
//			TweenLite.killTweensOf(_hScroller);
			if(_verticalScrollerVisible)
				TweenLite.to(_vScroller,0.6,{alpha:1});
			if(_horizontalScrollerVisible)
				TweenLite.to(_hScroller,0.6,{alpha:1});
		}
		private function onContentEnd(e:TouchEvent):void{
//			TweenLite.killTweensOf(_vScroller);
//			TweenLite.killTweensOf(_hScroller);
			if(_verticalScrollerVisible)
				TweenLite.to(_vScroller,0.6,{alpha:0});
			if(_horizontalScrollerVisible)
				TweenLite.to(_hScroller,0.6,{alpha:0});
		}
		
		//------------------------
		// 渲染
		//------------------------
		private function getContentWidth(cont:DisplayObjectContainer):Number{
			var max:Number = 0;
			for (var i:int = cont.numChildren - 1; i > -1; i--) {
				var comp:DisplayObject = cont.getChildAt(i);
				if (comp.visible) {
					var cw:Number=(comp is DisplayObjectContainer)?getContentWidth(DisplayObjectContainer(comp)):comp.width;
					if(!isNaN(cw))
						max = Math.max(comp.x +cw*comp.scaleX, max);
				}
			}
			return max;
		}
		
		private function getContentHeight(cont:DisplayObjectContainer):Number{
			var max:Number = 0;
			for (var i:int = cont.numChildren - 1; i > -1; i--) {
				var comp:DisplayObject = cont.getChildAt(i);
				if (comp.visible) {
					var cw:Number=(comp is DisplayObjectContainer)?getContentHeight(DisplayObjectContainer(comp)):comp.height;
					if(!isNaN(cw))
						max = Math.max(comp.y +cw*comp.scaleY, max);
				}
			}
			return max;
		}
		
		override public function render():void{
			DebugUtil.traceProcessCurrent("render",this);
			
			if(!content) return;
			
			//内容宽度
			_measureContentWidth=isNaN(_contentWidth)?((content is ISprite)?ISprite(content).width:getContentWidth(content)):_contentWidth;
			_measureContentHeight=isNaN(_contentHeight)?((content is ISprite)?ISprite(content).height:getContentHeight(content)):_contentHeight;
			
			_measureWidth=isNaN(_width)?contentWidth:_width;
			if(_measureWidth > contentWidth){	//测量宽度较大
				if(isNaN(_contentWidth))
					_measureContentWidth=_measureWidth;
				else
					_contentWidth=_measureWidth;
			}
				
			_measureHeight=isNaN(_height)?contentHeight:_height;
			if(_measureHeight > contentHeight){
				if(isNaN(_contentHeight))
					_measureContentHeight=_measureHeight;
				else
					_contentHeight=_measureHeight;
			}
			
			if(!isNaN(width) && !isNaN(height)){		//存在宽高
				_panController.setArea(width,height,contentWidth,contentHeight);
				var td:TextureData=TextureData.createRGB(width,height);
				var sp:Shape=new Shape();
				sp.graphics.beginFill(0xffffff);
				sp.graphics.drawRect(0,0,width,height);
				sp.graphics.endFill();
				td.draw(sp);
				_contentBg.texture=new Texture(td);
				_contentBg.alpha=0;
			}
			//滚动条
			renderScroller();
		}
		
		private function renderScroller():void{
			_vScroller.x=width-_vScroller.width;
			_vScroller.$height=(_horizontalScrollEnable?height-_hScroller.height:height);
			_vScroller.$thumbRatio=(contentHeight==0?1:height/contentHeight);
			_vScroller.render();
			_hScroller.y=height-_hScroller.height;
			_hScroller.$width=(_verticalScrollEnable?width-_vScroller.width:width);
			_hScroller.$thumbRatio=(contentWidth==0?1:width/contentWidth);
			_hScroller.render();
			//重设滚动位置
			scrollX=scrollX;
			scrollY=scrollY;
		}
		
		/**
		 * 渲染裁剪区域 
		 * 
		 */
		protected function renderClip():void{
			content.clipRect=new Rectangle(scrollX,scrollY,width,height);
		}
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
				_panController.removeEventListener(AreaPanController.UPDATE,onPanUpdate);
				_panController=null;
			}
			if(_contentPan){
				_contentPan.removeEventListener(GestureEvent.TOUCH_BEGIN,onContentPanBegin);
				_contentPan.removeEventListener(GestureEvent.PAN_BEGIN,onContentPanStart);
				_contentPan.removeEventListener(GestureEvent.PAN_MOVE,onContentPanMove);
				_contentPan.removeEventListener(GestureEvent.PAN_END,onContentPanEnd);
				_contentPan.dispose();
				_contentPan=null;
			}
			
			removeEventListener(TouchEvent.TOUCH_BEGIN,onContentBegin);
			removeEventListener(TouchEvent.TOUCH_END,onContentEnd);
			
		}
	}
}