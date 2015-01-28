package potato.component
{
	import core.display.DisplayObject;
	import core.display.DisplayObjectContainer;
	
	import potato.component.core.IContainer;
	import potato.component.core.IDataBinding;
	import potato.component.core.ISprite;
	import potato.component.core.RenderEvent;
	import potato.component.core.RenderManager;
	import potato.component.core.RenderType;
	
	/**
	 * 容器. 
	 * <p>可以设置宽高的容器，未显式设置宽高时自动计算</p>
	 * @author liuxin
	 * 
	 */
	public class Container extends DisplayObjectContainer
		implements ISprite,IContainer,IDataBinding
	{
		/**
		 * 创建容器 
		 * @param width 宽
		 * @param height 高
		 * 
		 */
		public function Container(width:Number=NaN,height:Number=NaN)
		{
			super();
			this.width=width;
			this.height=height;
		}
		
		//----------------------------
		//	ISprite
		//----------------------------
		protected var _width:Number;
		protected var _height:Number;
		protected var _scale:Number;
		private var _dataProvider:Object;
		private var _renderType:uint=RenderType.CALLLATER;
		
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
		public function get renderType():uint
		{
			return _renderType;
		}
		
		public function set renderType(value:uint):void
		{
			_renderType = value;
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
		 * 验证组件
		 * 
		 */
		public function validate():void{
			render();
		}
		
		
		
		override public function get width():Number{
			if(!isNaN(_width))
				return _width;
			else
				return measureWidth;
		}
		
		/**
		 * 获取测量宽度
		 * @return 
		 * 
		 */
		public function get measureWidth():Number{
			commitMeasure();
			
			var max:Number = 0;
			for (var i:int = numChildren - 1; i > -1; i--) {
				var comp:DisplayObject = getChildAt(i);
				if (comp.visible) {
					max = Math.max(comp.x + comp.width*comp.scaleX, max);
				}
			}
			return max;
		}
		
		public function get explicitWidth():Number{
			return _width;
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
		
		override public function get height():Number{
			if(!isNaN(_height))
				return _height;
			else
				return measureHeight;
		}
		
		/**
		 * 获取测量高度
		 * @return 
		 * 
		 */
		public function get measureHeight():Number{
			commitMeasure();
			
			var max:Number = 0;
			for (var i:int = numChildren - 1; i > -1; i--) {
				var comp:DisplayObject = getChildAt(i);
				if (comp.visible) {
					max = Math.max(comp.y + comp.height*comp.scaleY, max);
				}
			}
			return max;
		}
		
		public function get explicitHeight():Number{
			return _height;
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
		// 渲染
		//------------------------
		
		/**
		 * 提交内容大小
		 * 
		 */
		protected function commitMeasure():void{
			
		}
		
		/**
		 * 渲染组件内容 
		 * 
		 */
		protected function render():void{
			this.dispatchEvent(new RenderEvent(RenderEvent.RENDER_COMPLETE));
		}
		
		override public function dispose():void{
			super.dispose();
			RenderManager.dispose(this);
			
		}
	}
}