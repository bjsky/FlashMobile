package potato.editor.layout
{
	import flash.net.registerClassAlias;
	
	import core.events.EventDispatcher;
	
	import potato.potato_internal;
	import potato.component.core.ISprite;
	import potato.component.core.RenderManager;
	import potato.editor.layoutUI.ILayoutUI;

	/**
	 * 布局元素.
	 * <p>布局元素是组件的布局包装器，封装诸如x,y,width,height,left,right,top,bottom,centerX,centerY等布局属性，当布局属性发生改变时会派发相应的LayoutEvent</p>
	 * <p>布局作为独立的控制元件，不和组件绑定。创建组件的布局请将组件作为布局的参数，利用add方法为布局添加子布局或组件创建级联布局</p>
	 * @author liuxin
	 * @see LayoutEvent
	 */
	public class LayoutElement extends EventDispatcher 
	{
		public function LayoutElement(ui:ISprite,belong:Layout=null)
		{
			this.ui=ui;
			this.belong=belong;
			LayoutManager.add(this);
		}
		
		use namespace potato_internal;

		
		/**
		 * 注册别名 
		 * 
		 */
		static public function registerAlias():void{
			registerClassAlias("potato.layout.LayoutElement",LayoutElement);
		}		
		
		//---------------------------------
		// 	properties
		//---------------------------------
		private var _ui:ISprite;
		private var _belong:Layout;
		
		
		private var _left:Number;
		private var _right:Number;
		private var _top:Number;
		private var _bottom:Number;
		private var _centerX:Number;
		private var _centerY:Number;
		
		/**
		 * 包含的ui 
		 * @param value
		 * @private
		 */
		public function set ui(value:ISprite):void{
			_ui=value;
		}
		
		public function get ui():ISprite{
			return _ui;
		}
		
	
		/**
		 * 从属的layout 
		 * @param value
		 * @private 
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
			if(x!=value){
				$x=value;
				LayoutManager.invalidateLayout(this);
			}
		}
		
		/**
		 * 布局验证阶段的x位置
		 * @param value
		 * 
		 */
		potato_internal function set $x(value:Number):void{
			if(ui is ILayoutUI)
				ILayoutUI(ui).$x=value;
			else
				ui.x=value;
		}
		public function get x():Number{
			return ui.x;
		}
		
		/**
		 * y 
		 * @param value
		 * 
		 */
		public function set y(value:Number):void{
			if(y!=value){
				$y=value;
				LayoutManager.invalidateLayout(this);
			}
		}
		/**
		 * 布局验证阶段的y位置 
		 * @param value
		 * 
		 */
		public function set $y(value:Number):void{
			if(ui is ILayoutUI)
				ILayoutUI(ui).$y=value;
			else
				ui.y=value;
		}
		public function get y():Number{
			return ui.y;
		}
		
		
		/**
		 * y缩放  
		 * @param value
		 * 
		 */
		public function set scaleY(value:Number):void
		{
			if(scaleY!=value){
				$scaleY=value;
				LayoutManager.invalidateLayout(this);
			}
		}
		/**
		 * 布局验证阶段的x缩放 
		 * @param value
		 * 
		 */
		public function set $scaleY(value:Number):void{
			if(ui is ILayoutUI)
				ILayoutUI(ui).$scaleY=value;
			else
				ui.scaleY=value;
		}
		public function get scaleY():Number
		{
			return ui.scaleY;
		}
		public function get scaledHeight():Number{
			return height*scaleY;
		}
		
		/**
		 * x缩放   
		 * @param value
		 * 
		 */
		public function set scaleX(value:Number):void
		{
			if(scaleX!=value){
				$scaleX=value;
				LayoutManager.invalidateLayout(this);
			}
		}
		/**
		 * 布局验证阶段的y缩放
		 * @param value
		 * 
		 */
		public function set $scaleX(value:Number):void{
			if(ui is ILayoutUI)
				ILayoutUI(ui).$scaleX=value;
			else
				ui.scaleX=value;
		}
		
		public function get scaleX():Number
		{
			return ui.scaleX;
		}
		
		public function get scaledWidth():Number{
			return width*scaleX;
		}
		
		/**
		 *  锚定左边距 
		 * @param value
		 * 
		 */
		public function set left(value:Number):void{
			if(_left!=value){
				_left=value;
				LayoutManager.invalidateLayout(this);
			}
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
			if(_right!=value){
				_right=value;
				LayoutManager.invalidateLayout(this);
			}
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
			if(_top!=value){
				_top=value;
				LayoutManager.invalidateLayout(this);
			}
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
			if(_bottom!=value){
				_bottom=value;
				LayoutManager.invalidateLayout(this);
			}
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
			if(_centerX!=value){
				_centerX=value;
				LayoutManager.invalidateLayout(this);
			}
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
			if(_centerY!=value){
				_centerY=value;
				LayoutManager.invalidateLayout(this);
			}
		}
		public function get centerY():Number{
			return _centerY;
		}
		
		/**
		 * 布局宽 
		 * @param value
		 * 
		 */
		public function set width(value:Number):void{
			if(width!=value){
				$width=value;
				LayoutManager.invalidateLayout(this);
			}
		}
		/**
		 * 布局验证阶段的宽 
		 * @param value
		 * 
		 */
		public function set $width(value:Number):void{
			if(ui is ILayoutUI)
				ILayoutUI(ui).$width=value;
			else
				ui.width=value;
			this.dispatchEvent(new LayoutEvent(LayoutEvent.RESIZE));
		}
		
		public function get width():Number{
			return ui.width;
		}
		
		/**
		 *  布局高 
		 * @param value
		 * 
		 */
		public function set height(value:Number):void{
			if(height!=value){
				$height=value;
				LayoutManager.invalidateLayout(this);
			}
		}
		/**
		 * 布局验证阶段的高 
		 * @param value
		 * 
		 */
		public function set $height(value:Number):void{
			if(ui is ILayoutUI)
				ILayoutUI(ui).$height=value;
			else
				ui.height=value;
			this.dispatchEvent(new LayoutEvent(LayoutEvent.RESIZE));
		}
		public function get height():Number{
			return ui.height;
		}
		
		//-------------------
		//	function
		//-------------------
		/**
		 * 布局 
		 * 
		 */
		potato_internal function update():void{
			if(belong)	//如果有布局，由布局刷新，最终由根布局刷新
				belong.update();
			else{	//否则计算布局
//				trace("_______layout:"+StringUtil.getMemoryName(this));
				RenderManager.callLater(this,measure);
			}
		}
		
		private var _isValidate:Boolean=false;
		public function get isValidate():Boolean{
			return _isValidate;
		}
		potato_internal function invalidate():void{
			if(_isValidate){
				_isValidate=false;
			}
		}
		potato_internal function validate():void{
			if(!_isValidate){
				_isValidate=true;
				
				update();
			}
		}
		
		/**
		 * @private 
		 * 
		 */
		public function measure():void{
			measureLayout();
			this.dispatchEvent(new LayoutEvent(LayoutEvent.MEASURE));
		}
		protected function measureLayout():void{
			
		}
		
		override public function dispose():void{
			super.dispose();
			RenderManager.dispose(this);
			
			LayoutManager.remove(this);
			this.ui=null;
			this.belong=null;
		}
	}
}