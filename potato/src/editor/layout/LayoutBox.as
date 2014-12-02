package potato.editor.layout
{
	import flash.net.registerClassAlias;
	
	import potato.potato_internal;
	import potato.component.interf.IContainer;
	import potato.component.interf.ISprite;
	
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
		//-----------------
		// const
		//-----------------
		/**
		 * 水平方向,适用于direction
		 */
		static public const HORIZONTIAL:String="horizontal";
		/**
		 * 垂直方向,适用于direction
		 */		
		static public const VERTICAL:String="vertical";
		
		
		/**
		 * 向上对齐,适用于verticalAlign
		 */
		static public const TOP:String="top";
		
		/**
		 * 向下对齐,适用于verticalAlign 
		 */		
		static public const BOTTOM:String="bottom";
		
		/**
		 * 向左对齐,适用于horizontalAlign 
		 */		
		static public const LEFT:String="left";
		
		/**
		 * 向右对齐,适用于horizontalAlign 
		 */		
		static public const RIGHT:String="right";
		
		/**
		 * 居中对齐,适用于verticalAlign ,horizontalAlign 
		 */		
		static public const CENTER:String="center";
		
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
			_direction=value;
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
			_verticalAlign = value;
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
			_horizontalAlign = value;
		}
		
		
		/**
		 * 间隙 
		 * @param value
		 * 
		 */
		public function set gap(value:Number):void{
			_gap=value;
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
		override protected function get measureWidth():Number{
			if(!isNaN(IContainer(ui).explicitWidth))
				return IContainer(ui).explicitWidth;
			else{
				var max:Number = 0;
				if(direction==VERTICAL) 
				{
					for (var i:int = _childrenElements.length - 1; i > -1; i--) {
						max = Math.max(_childrenElements[i].scaledWidth, max);
					}
				}else if(direction== HORIZONTIAL){
					for (i = _childrenElements.length - 1; i > -1; i--) {
						if(i==0)
							max += _childrenElements[i].scaledWidth;
						else
							max += _childrenElements[i].scaledWidth + gap;
					}
				}
				return max;
			}
		}
		
		/**
		 * 重写高
		 * @return 
		 * 
		 */
		override protected function get measureHeight():Number{
			if(!isNaN(IContainer(ui).explicitHeight))
				return IContainer(ui).explicitHeight;
			else{
				var max:Number = 0;
				if(direction==HORIZONTIAL){
					for (var i:int = _childrenElements.length - 1; i > -1; i--) {
						max = Math.max(_childrenElements[i].scaledHeight, max);
					}
				}else if(direction==VERTICAL){
					for (i = _childrenElements.length - 1; i > -1; i--) {
						if(i==0)
							max += _childrenElements[i].scaledHeight;
						else
							max += _childrenElements[i].scaledHeight + gap;
					}
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
			for (var i:int=0;i<_childrenElements.length;i++){
				var elem:LayoutElement =_childrenElements[i];
				if(direction==HORIZONTIAL){		//水平方向
					elem.x=xSum;
					if(i==_childrenElements.length-1)
						xSum+=elem.width;
					else
						xSum+= elem.width + gap;
					
					if(verticalAlign==TOP){
						elem.y=0;
					}else if(verticalAlign==CENTER){
						elem.y=(height-elem.height)/2;
					}else if(verticalAlign==BOTTOM){
						elem.y=height-elem.height;
					}
				}else if(direction==VERTICAL){	//垂直方向
					elem.y=ySum;
					
					if(i==_childrenElements.length-1)
						ySum+= elem.height;
					else
						ySum+= elem.height + gap;
					
					if(horizontalAlign==LEFT){
						elem.x=0;
					}else if(horizontalAlign==CENTER){
						elem.x=(width-elem.width)/2;
					}else if(horizontalAlign==RIGHT){
						elem.x=width-elem.width;
					}
				}
				
				elem.measure();
			}
		}
	}
}