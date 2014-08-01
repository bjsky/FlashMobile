package potato.editor.layout
{
	import flash.net.registerClassAlias;
	
	import core.display.DisplayObject;
	import core.display.DisplayObjectContainer;
	
	import potato.potato_internal;
	import potato.component.ISprite;

	/**
	 * 布局元素 
	 * @author liuxin
	 * 
	 */
	public class LayoutElement 
	{
		public function LayoutElement(ui:ISprite,belong:Layout=null)
		{
			this.ui=ui;
			this.belong=belong;
		}
		
		use namespace potato_internal;
		/**
		 * 注册别名 
		 * 
		 */
		static public function registerAlias():void{
			registerClassAlias("potato.layout.LayoutElement",LayoutElement);
		}		
		
		
//		/**
//		 * 创建一个layoutElement
//		 * @param ui 
//		 * @param layout
//		 * @return 
//		 * 
//		 */
//		static public function create(ui:ISprite,belong:Layout=null):LayoutElement{
//			var le:LayoutElement=new LayoutElement();
//			le.ui=ui;
//			le.belong=belong;
//			return le;
//		}
		//---------------------------------
		// 	properties
		//---------------------------------
		private var _ui:ISprite;
		private var _belong:Layout;
		
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		
		private var _left:Number;
		private var _right:Number;
		private var _top:Number;
		private var _bottom:Number;
		private var _centerX:Number;
		private var _centerY:Number;
		
		
		/**
		 * 包含的ui 
		 * @param value
		 * 
		 */
		public function set ui(value:ISprite):void{
			_ui=value;
			if(_ui)
			{
				_x=_ui.x;
				_y=_ui.y;
				if(!isNaN(ui.width))
					_width=ui.width;
				if(!isNaN(ui.height))
					_height=ui.height;
			}
		}
		public function get ui():ISprite{
			return _ui;
		}
		
		/**
		 * 从属的layout 
		 * @param value
		 * 
		 */
		public function set belong(value:Layout):void{
			_belong=value;
		}
		public function get belong():Layout{
			return _belong;
		}

		/**
		 * x 
		 * @param value
		 * 
		 */
		public function set x(value:Number):void{
			_x=value;
			if(ui.x!=_x)
				ui.x=_x;
		}
		public function get x():Number{
			return _x;
		}
		
		/**
		 * y 
		 * @param value
		 * 
		 */
		public function set y(value:Number):void{
			_y=value;
			if(ui.y!=_y)
				ui.y=_y;
		}
		public function get y():Number{
			return _y;
		}
		
		/**
		 * 布局宽 
		 * @param value
		 * 
		 */
		public function set width(value:Number):void{
			_width=value;
			if(_width!=ui.width){
				ui.width=_width;
			}
		}
		public function get width():Number{
			if(isNaN(_width)){
				if(!_measuredWidth){		//失效重新计算宽
					_widthMeasured=measureWidth();
					_measuredWidth=true;
				}
				return	_widthMeasured;		//返回计算宽
			}else
				return _width;
		}
		
		/**
		 *  布局高 
		 * @param value
		 * 
		 */
		public function set height(value:Number):void{
			_height=value;
			if(_height!=ui.height){
				ui.height=_height;
			}
		}
		public function get height():Number{
			if(isNaN(_height)){
				if(!_measuredHeight){	//失效重新计算高
					_heightMeasured=measureHeight();
					_measuredHeight=true;
				}
				return	_heightMeasured;	//返回计算高
			}else
				return _height;
		}
		
		public function get scaleWidth():Number{
			return width*ui.scaleX;
		}
		
		public function get scaleHeight():Number{
			return height*ui.scaleY;
		}
		
		/**
		 *  锚定左边距 
		 * @param value
		 * 
		 */
		public function set left(value:Number):void{
			_left=value;
		}
		public function get left():Number{
			return _left;
		}
		
		/**
		 * 锚定右边距  
		 * @param value
		 * 
		 */
		public function set right(value:Number):void{
			_right=value;
		}
		public function get right():Number{
			return _right;
		}
		
		/**
		 * 锚定上边距 
		 * @param value
		 * 
		 */
		public function set top(value:Number):void{
			_top=value;
		}
		public function get top():Number{
			return _top;
		}
		
		/**
		 * 锚定下边距  
		 * @param value
		 * 
		 */
		public function set bottom(value:Number):void{
			_bottom=value;
		}
		public function get bottom():Number{
			return _bottom;
		}
		
		/**
		 * 锚定居中x偏移  
		 * @param value
		 * 
		 */
		public function set centerX(value:Number):void{
			_centerX=value;
		}
		public function get centerX():Number{
			return _centerX;
		}
		
		/**
		 * 锚定居中y偏移  
		 * @param value
		 * 
		 */
		public function set centerY(value:Number):void{
			_centerY=value;
		}
		public function get centerY():Number{
			return _centerY;
		}
		
		//-------------------
		//	function
		//-------------------
		/**
		 * 刷新布局 
		 * 
		 */
		public function refreshLayout():void{
			if(belong)	//如果有布局，由布局刷新，最终由根布局刷新
				belong.refreshLayout();
			else	//否则计算布局
				measureLayout();
		}
		
		private var _measuredWidth:Boolean=false;
		private var _widthMeasured:Number;
		private var _measuredHeight:Boolean=false;
		private var _heightMeasured:Number;
		potato_internal function measureLayout():void{
			//计算的宽高失效
			_measuredWidth=false;
			_measuredHeight=false;
		}
		
		/**
		 * 计算测量宽 
		 * @return 
		 * 
		 */
		public function measureWidth():Number{
			var max:Number = 0;
			if(ui is DisplayObjectContainer){
				var cont:DisplayObjectContainer=DisplayObjectContainer(ui);
				for (var i:int = cont.numChildren - 1; i > -1; i--) {
					var comp:DisplayObject = cont.getChildAt(i);
					if (comp.visible) {
						if(!isNaN(comp.width))
							max = Math.max(comp.x + comp.width*comp.scaleX, max);
					}
				}
			}
			return max;
		}
		/**
		 * 计算测量高 
		 * @return 
		 * 
		 */
		
		public function measureHeight():Number{
			var max:Number = 0;
			if(ui is DisplayObjectContainer){
				var cont:DisplayObjectContainer=DisplayObjectContainer(ui);
				for (var i:int = cont.numChildren - 1; i > -1; i--) {
					var comp:DisplayObject = cont.getChildAt(i);
					if (comp.visible ) {
						if(	!isNaN(comp.height))
							max = Math.max(comp.y + comp.height*comp.scaleX, max);
					}
				}
			}
			return max;
		}
		
		public function dispose():void{
			this.ui=null;
			this.belong=null;
		}
	}
}