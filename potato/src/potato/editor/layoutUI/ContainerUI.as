package potato.editor.layoutUI
{
	import core.display.DisplayObject;
	
	import potato.potato_internal;
	import potato.component.ScrollContainer;
	import potato.component.core.ISprite;
	import potato.editor.layout.Layout;
	import potato.editor.layout.LayoutCanvas;
	import potato.editor.layout.LayoutElement;
	import potato.editor.layout.LayoutEvent;
	import potato.editor.layout.LayoutManager;
	
	/**
	 * 绝对布局容器. 
	 * <p>绝对布局容器，超出容器大小的区域将不可见。自动关联子布局</p>
	 * @author liuxin
	 * 
	 */
	public class ContainerUI extends ScrollContainer
		implements ILayoutUI
	{
		public function ContainerUI()
		{
			
			createLayout();
			_layout.addEventListener(LayoutEvent.MEASURE,measureHandler);
			_layout.addEventListener(LayoutEvent.RESIZE,resizeHandler);
			
			super();
			//容器不可滚动
			this.vScrollEnable=this.hScrollEnable=false;
			this.vScrollerVisible=this.hScrollerVisible=false;
		}
		use namespace potato_internal;
		
		
		
		private function resizeHandler(e:LayoutEvent):void
		{
			e.stopPropagation();
			this.dispatchEvent(new LayoutEvent(LayoutEvent.RESIZE));
		}
		
		//布局之后重新渲染
		protected function measureHandler(e:LayoutEvent):void
		{
			while(_laterChildHandlers.length>0){
				var handler:ChildHandler =_laterChildHandlers[0];
				handler._func.apply(null,handler._args);
				_laterChildHandlers.shift();
			}
			this.validate();
			e.stopPropagation();
			this.dispatchEvent(new LayoutEvent(LayoutEvent.MEASURE));
		}
		
		protected var  _layout:Layout;
		//延迟的子项处理
		private var _laterChildHandlers:Vector.<ChildHandler>=new Vector.<ChildHandler>();
		
		public function get layout():LayoutElement{
			return _layout;
		}
		
		protected function createLayout():void{
			_layout=new LayoutCanvas(this);
			
		}
		////////////////////////
		//children Layout
		////////////////////////
		override public function addChild(child:DisplayObject):DisplayObject{
			addLayout(child);
			return child;
		}
		
		potato_internal function $addChild(child:DisplayObject):DisplayObject{
			return super.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject{
			addLayout(child,index);
			return child;
		}
		
		potato_internal function $addChildAt(child:DisplayObject,index:int):DisplayObject{
			return super.addChildAt(child,index);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject{
			removeLayout(child);
			return child;
		}
		
		potato_internal function $removeChild(child:DisplayObject):DisplayObject{
			return super.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject{
			var c:DisplayObject=super.getChildAt(index);
			removeLayout(c,index);
			return c;
		}
		
		potato_internal function $removeChildAt(index:int):DisplayObject{
			return super.removeChildAt(index);
		}
		
		private function addLayout(child:DisplayObject,index:int=-1):void{
			if(child is ILayoutUI){
				_layout.add(ILayoutUI(child).layout);
			}else if(child is ISprite){
				_layout.add(ISprite(child));
			}
			
			//延迟子项处理
			if(index>-1)
				_laterChildHandlers.push(new ChildHandler($addChildAt,[child,index]));
			else
				_laterChildHandlers.push(new ChildHandler($addChild,[child]));
			//布局失效
			LayoutManager.invalidateLayout(_layout);
		}
		
		private function removeLayout(child:DisplayObject,index:int=-1):void{
			if(child is ILayoutUI){
				_layout.remove(ILayoutUI(child).layout);
			}else if(child is ISprite){
				_layout.remove(ISprite(child));
			}
			//延迟子项处理
			if(index>-1)
				_laterChildHandlers.push(new ChildHandler($removeChildAt,[index]));
			else
				_laterChildHandlers.push(new ChildHandler($removeChild,[child]));
			//布局失效
			LayoutManager.invalidateLayout(_layout);
		}
		
		///////////////////////////
		// layout Property
		///////////////////////////
		
		/**
		 * 重写宽度为布局的宽度 
		 * @param value
		 * 
		 */
		override public function set width(value:Number):void
		{
			_layout.width=value;
		}
		/**
		 * 真实的宽度由布局设置 
		 * @param value
		 * 
		 */
		public function set $width(value:Number):void{
			super.width=value;
		}
		
		override public function set height(value:Number):void
		{
			_layout.height=value;
		}
		public function set $height(value:Number):void{
			super.height=value;
		}
		
		override public function set x(_arg1:Number):void{
			_layout.x=_arg1;
		}
		public function set $x(value:Number):void{
			super.x=value;
		}
		
		override public function set y(_arg1:Number):void{
			_layout.y=_arg1;
		}
		public function set $y(value:Number):void{
			super.y=value;
		}
		
		override public function set scaleX(_arg1:Number):void{
			_layout.scaleX=_arg1;
		}
		public function set $scaleX(value:Number):void{
			super.scaleX=value;
		}
		
		override public function set scaleY(_arg1:Number):void{
			_layout.scaleY=_arg1;
		}
		public function set $scaleY(value:Number):void{
			super.scaleY=value;
		}
		
		public function get left():Number
		{
			return _layout.left;
		}
		
		public function set left(value:Number):void
		{
			_layout.left = value;
		}
		
		public function get right():Number
		{
			return _layout.right;
		}
		
		public function set right(value:Number):void
		{
			_layout.right = value;
		}
		
		public function get top():Number
		{
			return _layout.top;
		}
		
		public function set top(value:Number):void
		{
			_layout.top = value;
		}
		
		public function get bottom():Number
		{
			return _layout.bottom;
		}
		
		public function set bottom(value:Number):void
		{
			_layout.bottom = value;
		}
		
		public function get centerX():Number
		{
			return _layout.centerX;
		}
		
		public function set centerX(value:Number):void
		{
			_layout.centerX = value;
		}
		
		
		public function get centerY():Number
		{
			return _layout.centerY;
		}
		
		public function set centerY(value:Number):void
		{
			_layout.centerY = value;
		}
		
	}
}
class ChildHandler{
	public function ChildHandler(func:Function,args:Array){
		_func=func;
		_args=args;
	}
	
	public var _func:Function;
	public var _args:Array;
}
