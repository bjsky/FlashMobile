package potato.component
{
	import core.display.DisplayObject;
	import core.display.DisplayObjectContainer;
	import core.events.Event;
	
	import potato.Game;
	import potato.potato_internal;
	import potato.event.UIEvent;
	
	
	/**
	 * 所有组件的基类，包含了可编辑样式、手势事件、动态布局、延迟渲染等内容
	 * @author liuxin
	 */
	public class UIComponent extends DisplayObjectContainer
	{
		public function UIComponent()
		{
			super();
		}
		
		use namespace potato_internal;
		
		//失效标识位
		private var _invalidateProperties:Boolean=false;
		private var _invalidateSize:Boolean=false;
		private var _invalidateDisplayList:Boolean=false;
		
		//默认为绝对布局
		potato_internal var absoluteLayout:Boolean=true;
		
		private var _editorXML:XML;
		private var _propertySource:Object;
		/** x**/
		private var _x:Number=0;
		private var _y:Number=0;
		/** 网格x**/
		private var _gridX:Number;
		private var _gridY:Number;
		/** 实际宽度 **/
		private var _width:Number;
		private var _height:Number;
		/** 显式指定的网格宽度**/
		private var _gridWidth:Number;
		private var _gridHeight:Number;
		/** 依据限制的布局**/
		private var _left:Number;
		private var _gridLeft:Number;
		private var _top:Number;
		private var _gridTop:Number;
		private var _right:Number;
		private var _gridRight:Number;
		private var _bottom:Number;
		private var _gridBottom:Number;
		private var _centerX:Number;
		private var _gridCenterX:Number;
		private var _centerY:Number;
		private var _gridCenterY:Number;
		
		/** 测量最小宽度**/
		protected var _measureMinWidth:Number;
		protected var _measureMinHeight:Number;
		/** 测量宽高**/
		protected var _measureWidth:Number=0;
		protected var _measureHeight:Number=0;
		
		/** 缩放保持宽高比**/
		public var keepScaleWidthHeightRatio:Boolean=false; 
		/** 显示层级**/
		public var nestLevel:uint=0;
		
		//-----------------------------------
		// 定位属性
		// 所有定位属性支持基于像素的定位，和基于网格的定位。
		// 基于像素的定位设置的大小在不同分辨率下不变，基于网格的定位随设备分辨率自动缩放并考虑是否固定宽高比（显示元素）
		// 框架将原始的缩放禁用了，请使用基于像素或者基于网格
		//----------------------------------
		
		/**
		 * x轴缩放，不支持
		 * @param _arg1
		 * 
		 */
		override public function set scaleX(_arg1:Number):void{
		}
		/**
		 * y轴缩放，不支持
		 * @param _arg1
		 * 
		 */
		override public function set scaleY(_arg1:Number):void{
		}
		
		/** 宽度**/
		public function set width(value:Number):void{
			_width=value;
			
			invalidateProperty();
		}
		override public function get width():Number{
			if(!isNaN(_width)){
				return _width;
			}else{
				measure();
				if(!isNaN(_measureMinWidth)){
					return _measureMinWidth;
				}else{
					return _measureWidth;
				}
			}
		}
		
		/** 网格宽度**/
		public function set gridWidth(value:Number):void{
			_gridWidth=value;
			_width=(value/Game.gridXMax)*Game.stage.stageWidth;
			
			invalidateProperty();
		}
		public function get gridWidth():Number{
			return _gridWidth;
		}
		
		/** 高度**/
		public function set height(value:Number):void{
			_height=value;
			
			invalidateProperty();
		}
		override public function get height():Number{
			if(!isNaN(_height)){
				return _height;
			}else{
				measure();
				if(!isNaN(_measureMinHeight)){
					return _measureMinHeight;
				}else{
					return _measureHeight;
				}
			}
		}
		
		/** 网格高度**/
		public function set gridHeight(value:Number):void{
			_gridHeight=value;
			_height=(value/Game.gridYMax)*Game.stage.stageHeight;
			
			invalidateProperty();
		}
		public function get gridHeight():Number{
			return _gridHeight;
		}
		
		/** x**/
		override public function set x(_arg1:Number):void{
			_x=_arg1;
			
			invalidateProperty();
		}
		override public function get x():Number{
			return _x;
		}
		
		/** 网格x**/
		public function set gridX(value:Number):void{
			_gridX=value;
			_x=(value/Game.gridXMax)*Game.stage.stageWidth;
			
			invalidateProperty();
		}
		public function get gridX():Number{
			return _gridX;
		}
		
		/** y**/
		override public function set y(_arg1:Number):void{
			_y=_arg1;
			
			invalidateProperty();
		}
		override public function get y():Number{
			return _y;
		}
		
		/** 网格y**/
		public function set gridY(value:Number):void{
			_gridY=value;
			_y=(value/Game.gridYMax)*Game.stage.stageHeight;
			
			invalidateProperty();
		}
		public function get gridY():Number{
			return _gridY;
		}
		
		/** 锚定左边距**/
		public function set left(value:Number):void{
			_left=value;
			
			invalidateProperty();
		}
		public function get left():Number{
			return _left;
		}
		/** 锚定网格左边距**/
		public function set gridLeft(value:Number):void{
			_gridLeft=value;
			_left=(value/Game.gridXMax)*Game.stage.stageWidth;
			
			invalidateProperty();
		}
		public function get gridLeft():Number{
			return _gridLeft;
		}
		
		/** 锚定上边距**/
		public function set top(value:Number):void{
			_top=value;
			
			invalidateProperty();
		}
		public function get top():Number{
			return _top;
		}
		/** 锚定网格上边距**/
		public function set gridTop(value:Number):void{
			_gridTop=value;
			_top=(value/Game.gridYMax)*Game.stage.stageHeight;
			
			invalidateProperty();
		}
		public function get gridTop():Number{
			return _gridTop;
		}
		
		/** 锚定右边距**/
		public function set right(value:Number):void{
			_right=value;
			
			invalidateProperty();
		}
		public function get right():Number{
			return _right;
		}
		/** 锚定网格右边距**/
		public function set gridRight(value:Number):void{
			_gridRight=value;
			_right=(value/Game.gridXMax)*Game.stage.stageWidth;
			
			invalidateProperty();
		}
		public function get gridRight():Number{
			return _gridRight;
		}
		
		/** 锚定下边距**/
		public function set bottom(value:Number):void{
			_bottom=value;
			
			invalidateProperty();
		}
		public function get bottom():Number{
			return _bottom;
		}
		/** 锚定网格下边距**/
		public function set gridBottom(value:Number):void{
			_gridBottom=value;
			_bottom=(value/Game.gridYMax)*Game.stage.stageHeight;
			
			invalidateProperty();
		}
		public function get gridBottom():Number{
			return _gridBottom;
		}
		
		/** 锚定x轴居中**/
		public function set centerX(value:Number):void{
			_centerX=value;
			
			invalidateProperty();
		}
		public function get centerX():Number{
			return _centerX;
		}
		/** 锚定网格x轴居中**/
		public function set gridCenterX(value:Number):void{
			_gridCenterX=value;
			_centerX=(value/Game.gridXMax)*Game.stage.stageWidth;
			
			invalidateProperty();
		}
		public function get gridCenterX():Number{
			return _gridCenterX;
		}
		
		/** 锚定y轴居中**/
		public function set centerY(value:Number):void{
			_centerY=value;
			
			invalidateProperty();
		}
		public function get centerY():Number{
			return _centerY;
		}
		/** 锚定网格y轴居中**/
		public function set gridCenterY(value:Number):void{
			_gridCenterY=value;
			_centerY=(value/Game.gridYMax)*Game.stage.stageHeight;
			
			invalidateProperty();
		}
		public function get gridCenterY():Number{
			return _gridCenterY;
		}
		//--------------------------------
		//	渲染：
		//	uiComponent中主要处理延迟失效，作为layoutManager的代理处理失效和验证接口
		//--------------------------------
		
		/** 渲染完成**/
		private function renderCompleteHanlder(e:Event):void{
			Game.layout.removeEventListener(UIEvent.RENDER_COMPLETE,renderCompleteHanlder);
			//延迟处理失效
			if(_invalidateProperties){
				_invalidateProperties=false;
				Game.layout.invalidateProperties(this);
			}
			if(_invalidateSize){
				_invalidateSize=false;
				Game.layout.invalidateSize(this);
			}
			if(_invalidateDisplayList){
				_invalidateDisplayList=false;
				Game.layout.invalidateDisplayList(this);
			}
		}
		
		/** 大小失效**/
		protected function invalidateSize():void{
			//正在渲染，延迟处理到渲染完成
			if(Game.layout.validateLocked){	
				Game.layout.addEventListener(UIEvent.RENDER_COMPLETE,renderCompleteHanlder);
				_invalidateSize=true;
			}else{
				//立即调用layoutmanager的大小失效
				Game.layout.invalidateSize(this);
			}
		}
		
		/** 属性失效**/
		protected function invalidateProperty():void{
			//正在渲染，延迟处理到渲染完成
			if(Game.layout.validateLocked){	
				Game.layout.addEventListener(UIEvent.RENDER_COMPLETE,renderCompleteHanlder);
				_invalidateProperties=true;
			}else{
				//立即调用layoutmanager的属性失效
				Game.layout.invalidateProperties(this);
			}
		}
		
		/** 显示列表失效**/
		protected function invalidateDisplayList():void{
			//正在渲染，延迟处理到渲染完成
			if(Game.layout.validateLocked){	
				Game.layout.addEventListener(UIEvent.RENDER_COMPLETE,renderCompleteHanlder);
				_invalidateDisplayList=true;
			}else{
				//立即调用layoutmanager的显示列表失效
				Game.layout.invalidateDisplayList(this);
			}
		}
		
		/** 属性验证**/
		potato_internal function validateProperty():void{
			commitProperty();
		}
		
		/** 大小验证**/
		potato_internal function validateSize():void{
			measure();
		}
		
		
		/** 显示列表验证**/
		potato_internal function validateDisplayList():void{
			updateDisplayList();
		}
		
		
		/** 子类重写属性更新的方法**/
		protected function commitProperty():void{
			if(parent && absoluteLayout){
				if(!isNaN(_centerX)){
					_x=(parent.width-this.width)/2+_centerX;
				}else{
					if(!isNaN(_left)){
						_x=_left;
						if(!isNaN(_right)){
							_width=parent.width-_left-_right;
						}
					}else{
						if(!isNaN(_right))
							_x=parent.width-this.width-_right;
					}
				}
				if(!isNaN(_centerY)){
					_y=(parent.height-this.height)/2+_centerY;
				}else{
					if(!isNaN(_top)){
						_y=_top;
						if(!isNaN(_bottom)){
							_height=parent.height-_top-_bottom;
						}
					}else{
						if(!isNaN(_bottom))
							_y=parent.height-this.height-_bottom;
					}
				}
			}
		}
		
		/** 子类重写计算默认大小的方法**/
		protected function measure():void{
			var max:Number = 0;
			var maxH:Number=0;
			for (var i:int = numChildren - 1; i > -1; i--) {
				var comp:DisplayObject = getChildAt(i);
				if (comp.visible) {
					max = Math.max(comp.x + comp.width, max);
					maxH = Math.max(comp.y + comp.height, maxH);
				}
			}
			_measureWidth=max;
			_measureHeight=maxH;
		}
		
		/** 子类重写更新显示列表的方法**/
		protected function updateDisplayList():void{
			super.x=_x;
			super.y=_y;
		}
		
		/** 重写addChild，处理显示层级**/
		override public function addChild(child:DisplayObject):DisplayObject{
			var ret:DisplayObject=super.addChild(child);
			if(child is UIComponent){		//显示层级加1
				(child as UIComponent).updateNestLevel(nestLevel+1);
			}
			return ret;
		}
		
		/** 重写addChildAt，处理显示层级**/
		override public function addChildAt(child:DisplayObject,index:int):DisplayObject{
			var ret:DisplayObject=super.addChild(child,index);
			if(child is UIComponent){		//显示层级加1
				(child as UIComponent).updateNestLevel(nestLevel+1);
			}
			return ret;
		}
		
		/** 更新子级层级**/
		potato_internal function updateNestLevel(level:Number):void{
			this.nestLevel=level;
			for(var i:int=0;i<this.numChildren;i++){
				var child:DisplayObject=this.getChildAt(i);
				if(child is UIComponent){
					(child as UIComponent).updateNestLevel(level+1);
				}
			}
		}
		
		/** 编辑器xml**/
		public function set editorXML(value:XML):void{
			_editorXML=value;
		}
		
		/** 属性赋值**/
		public function set propertySource(value:Object):void{
			_propertySource=value;
			for (var prop:String in _propertySource) {
				if (hasOwnProperty(prop)) {
					this[prop] = _propertySource[prop];
				}
			}
		}
		public function get propertySource():Object{
			return _propertySource;
		}
		
		override public function dispose():void{
			super.dispose();
			//立即从布局管理器中移除
			Game.layout.removeUIComponent(this);
		}

	}
}