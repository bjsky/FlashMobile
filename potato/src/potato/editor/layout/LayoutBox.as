package potato.editor.layout
{
	import flash.net.registerClassAlias;
	
	import core.display.DisplayObject;
	
	import potato.potato_internal;
	import potato.component.core.IContainer;
	import potato.component.core.ISprite;
	
	/**
	 * box布局.
	 * <p>子布局按照水平或者垂直排列的布局。水平方向，忽略水平对齐。垂直方向，忽略垂直对齐</p>
	 * @author liuxin
	 * 
	 */
	public class LayoutBox extends Layout
	{
		public function LayoutBox(ui:ISprite,direction:String="horizontal",gap:Number=2
								  ,horizontalAlign:String="center",vericalAlign:String="center")
		{
			super(ui);
			this.direction=direction;
			this.gap=gap;
			this.horizontalAlign=horizontalAlign;
			this.verticalAlign=vericalAlign;
		}
		
		use namespace potato_internal;
		/**
		 * 注册别名 
		 * 
		 */
		static public function registerAlias():void{
			registerClassAlias("potato.layout.LayoutBox",LayoutBox);
		}
		
		//-------------------------
		// property
		//-------------------------
		private var _direction:String="horizontal";
		private var _horizontalAlign:String="center";
		private var _verticalAlign:String="top";
		private var _gap:Number=2;
		
		
		/**
		 * 方向 
		 * @param value
		 * 
		 */
		public function set direction(value:String):void{
			if(_direction !=value){
				_direction=value;
				LayoutManager.invalidateLayout(this);
			}
		}
		public function get direction():String{
			return _direction;
		}
		
		/**
		 * 垂直对齐 
		 * @return 
		 * 
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			if(_verticalAlign != value){
				_verticalAlign = value;
				LayoutManager.invalidateLayout(this);
			}
		}
		
		/**
		 * 水平对齐 
		 * @return 
		 * 
		 */
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			if(_horizontalAlign !=value){
				_horizontalAlign = value;
				LayoutManager.invalidateLayout(this);
			}
		}
		
		
		/**
		 * 间隙 
		 * @param value
		 * 
		 */
		public function set gap(value:Number):void{
			if(_gap!=value){
				_gap=value;
				LayoutManager.invalidateLayout(this);
			}
		}
		public function get gap():Number{
			return _gap;
		}
		
		//-----------------------
		// override function
		//-----------------------
		/**
		 * 重写宽 
		 * @return 
		 * 
		 */
		override public function get width():Number{
			if(!isNaN(IContainer(ui).explicitWidth))
				return IContainer(ui).explicitWidth;
			else{
				var max:Number = 0;
				if(direction==LayoutBoxDirection.VERTICAL) 
				{
					for (var i:int = _childrenElements.length - 1; i > -1; i--) {
						if(DisplayObject(_childrenElements[i].ui).visible)
							max = Math.max(_childrenElements[i].scaledWidth, max);
					}
				}else if(direction== LayoutBoxDirection.HORIZONTIAL){
					for (i = _childrenElements.length - 1; i > -1; i--) {
						if(DisplayObject(_childrenElements[i].ui).visible){
							max += _childrenElements[i].scaledWidth + gap;
						}
					}
					max-=gap;
					if(max<0) max=0;
				}
				return max;
			}
		}
		
		/**
		 * 重写高
		 * @return 
		 * 
		 */
		override public function get height():Number{
			if(!isNaN(IContainer(ui).explicitHeight))
				return IContainer(ui).explicitHeight;
			else{
				var max:Number = 0;
				if(direction==LayoutBoxDirection.HORIZONTIAL){
					for (var i:int = _childrenElements.length - 1; i > -1; i--) {
						if(DisplayObject(_childrenElements[i].ui).visible)
							max = Math.max(_childrenElements[i].scaledHeight, max);
					}
				}else if(direction==LayoutBoxDirection.VERTICAL){
					for (i = _childrenElements.length - 1; i > -1; i--) {
						if(DisplayObject(_childrenElements[i].ui).visible)
							max += _childrenElements[i].scaledHeight + gap;
					}
					max-=gap;
					if(max<0) max=0;
				}
				return max;
			}
		}

		/**
		 * 重写刷新布局，设置子对象位置 
		 * 
		 */
		override protected function measureLayout():void{
			super.measureLayout();
			var xSum:Number=0,ySum:Number=0;
			var elem:LayoutElement;
			var i:int=0;
			for (i=0;i<_childrenElements.length;i++){
				elem =_childrenElements[i];
				if(direction==LayoutBoxDirection.HORIZONTIAL){		//水平方向
					elem.$x=xSum;
					if(i==_childrenElements.length-1)
						xSum+=elem.width;
					else
						xSum+= elem.width + gap;
					
					if(verticalAlign==LayoutBoxAlign.TOP){
						elem.$y=0;
					}else if(verticalAlign==LayoutBoxAlign.CENTER){
						elem.$y=(height-elem.height)/2;
					}else if(verticalAlign==LayoutBoxAlign.BOTTOM){
						elem.$y=height-elem.height;
					}
				}else if(direction==LayoutBoxDirection.VERTICAL){	//垂直方向
					elem.$y=ySum;
					
					if(i==_childrenElements.length-1)
						ySum+= elem.height;
					else
						ySum+= elem.height + gap;
					
					if(horizontalAlign==LayoutBoxAlign.LEFT){
						elem.$x=0;
					}else if(horizontalAlign==LayoutBoxAlign.CENTER){
						elem.$x=(width-elem.width)/2;
					}else if(horizontalAlign==LayoutBoxAlign.RIGHT){
						elem.$x=width-elem.width;
					}
				}
				
				elem.measure();
			}
			//position adjust
			for(i=0;i<_childrenElements.length;i++){
				elem =_childrenElements[i];
				if(direction==LayoutBoxDirection.HORIZONTIAL){		//水平方向
					if(horizontalAlign==LayoutBoxAlign.CENTER){
						elem.$x=elem.x+(width-xSum)/2;
					}else if(horizontalAlign==LayoutBoxAlign.RIGHT){
						elem.$x=elem.x+width-xSum;
					}
				}else if(direction==LayoutBoxDirection.VERTICAL){	//垂直方向
					if(verticalAlign==LayoutBoxAlign.CENTER){
						elem.$y=elem.y+(height-ySum)/2;
					}else if(verticalAlign==LayoutBoxAlign.BOTTOM){
						elem.$y=elem.y+height-ySum;
					}
				}
				elem.$x=int(elem.x);
				elem.$y=int(elem.y);
			}
		}
	}
}
