package potato.editor.layout
{
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	
	import potato.potato_internal;
	import potato.component.ISprite;
	
	/**
	 * box布局 
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
		 * 注册别名 
		 * 
		 */
		static public function registerAlias():void{
			registerClassAlias("potato.layout.LayoutBox",LayoutBox);
		}
		
//		/**
//		 * 创建一个box布局  
//		 * @param ui
//		 * @param direction
//		 * @param align
//		 * @param gap
//		 * @return 
//		 * 
//		 */
//		static public function create(ui:ISprite,direction:String="horizontal",align:String="top",gap:Number=2):LayoutBox{
//			var lb:LayoutBox=new LayoutBox();
//			lb.ui=ui;
//			lb.direction=direction;
//			lb.align=align;
//			lb.gap=gap;
//			return lb;
//		}
//		
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
		 * 重写计算布局的测量宽 
		 * @return 
		 * 
		 */
		override public function measureWidth():Number{
			var max:Number = 0;
			if(direction==VERTICAL) 
			{
				for (var i:int = _childrenElements.length - 1; i > -1; i--) {
					max = Math.max(_childrenElements[i].scaleWidth, max);
				}
			}else if(direction== HORIZONTIAL){
				for (i = _childrenElements.length - 1; i > -1; i--) {
					if(i==0)
						max += _childrenElements[i].scaleWidth;
					else
						max += _childrenElements[i].scaleWidth + gap;
				}
			}
			return max;
		}
		
		/**
		 * 重写计算布局的测量宽 
		 * @return 
		 * 
		 */
		override public function measureHeight():Number{
			var max:Number = 0;
			if(direction==HORIZONTIAL){
				for (var i:int = _childrenElements.length - 1; i > -1; i--) {
					max = Math.max(_childrenElements[i].scaleHeight, max);
				}
			}else if(direction==VERTICAL){
				for (i = _childrenElements.length - 1; i > -1; i--) {
					if(i==0)
						max += _childrenElements[i].scaleHeight;
					else
						max += _childrenElements[i].scaleHeight + gap;
				}
			}
			return max;
		}

		/**
		 * 重写刷新布局，设置子对象位置 
		 * 
		 */
		private var _elemPositonMap:Dictionary=new Dictionary();
		override potato_internal function measureLayout():void{
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
					
					if(verticalAlign==LayoutBoxAlign.TOP){
						elem.y=0;
					}else if(verticalAlign==LayoutBoxAlign.CENTER){
						elem.y=(height-elem.height)/2;
					}else if(verticalAlign==LayoutBoxAlign.BOTTOM){
						elem.y=height-elem.height;
					}
				}else if(direction==VERTICAL){	//垂直方向
					elem.y=ySum;
					
					if(i==_childrenElements.length-1)
						ySum+= elem.height;
					else
						ySum+= elem.height + gap;
					
					if(horizontalAlign==LayoutBoxAlign.LEFT){
						elem.x=0;
					}else if(horizontalAlign==LayoutBoxAlign.CENTER){
						elem.x=(width-elem.width)/2;
					}else if(horizontalAlign==LayoutBoxAlign.RIGHT){
						elem.x=width-elem.width;
					}
				}
				
				elem.measureLayout();
			}
			
			//调整位置
			for each(elem in _childrenElements){
				if(direction==HORIZONTIAL){
					if(horizontalAlign==LayoutBoxAlign.LEFT){
						elem.x+=0;
					}else if(horizontalAlign==LayoutBoxAlign.CENTER){
						elem.x+=(width-xSum)/2;
					}else if(horizontalAlign==LayoutBoxAlign.RIGHT){
						elem.x+=(width-xSum);
					}
				}else if(direction==VERTICAL){
					if(verticalAlign==LayoutBoxAlign.TOP){
						elem.y+=0;
					}else if(verticalAlign==LayoutBoxAlign.CENTER){
						elem.y+=(height-ySum)/2;
					}else if(verticalAlign==LayoutBoxAlign.BOTTOM){
						elem.y+=(height-ySum);
					}
				}
			}
		}
	}
}