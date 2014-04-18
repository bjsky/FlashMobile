package potato.component
{
	import core.display.DisplayObject;
	
	import potato.Game;
	import potato.potato_internal;

	/**
	 * box布局的容器
	 * @author liuxin
	 * 
	 */
	public class Box extends UIComponent
	{
		public function Box(direction:String="horizontal",gap:Number=2)
		{
			super();
			this.direction=direction;
			if(direction==HORIZONTIAL)
				horizontalGap=gap;
			else
				verticalGap=gap;
		}
		
		use namespace potato_internal;
		
		/** 水平对齐**/
		static public const HORIZONTIAL:String="horizontal";
		/** 垂直对齐**/
		static public const VERTICAL:String="vertical";
		
		/** 向上对齐**/
		static public const TOP:String="top";
		/** 垂直居中对齐**/
		static public const MIDDLE:String="middle";
		/** 向下对齐**/
		static public const BOTTOM:String="bottom";
		/** 向左对齐**/
		static public const LEFT:String="left";
		/** 向右对齐**/
		static public const RIGHT:String="right";
		/** 水平居中对齐**/
		static public const CENTER:String="center";
		
		
		private var _direction:String="horizontal";
		
		private var _horizontalAlign:String="left";
		private var _verticalAlign:String="top";
		private var _horizontalGap:Number=2;
		private var _verticalGap:Number=2;
		private var _gridHorizontalGap:Number=0;
		private var _gridVerticalGap:Number=0;
		
		
		/** 方向**/
		public function set direction(value:String):void{
			_direction=value;
			
			invalidateProperty();
		}
		
		public function get direction():String{
			return _direction;
		}
		
		/** 水平对齐方式**/
		public function set horizontalAlign(value:String):void{
			_horizontalAlign=value;
			
			invalidateProperty();
		}
		public function get horizontalAlign():String{
			return _horizontalAlign;
		}
		
		/** 垂直对齐方式**/
		public function set verticalAlign(value:String):void{
			_verticalAlign=value;
			
			invalidateProperty();
		}
		public function get verticalAlign():String{
			return _verticalAlign;
		}
		
		/** 水平间隙**/
		public function set horizontalGap(value:Number):void{
			_horizontalGap=value;
			
			invalidateProperty();
		}
		public function get horizontalGap():Number{
			return _horizontalGap;
		}
		
		/** 垂直间隙**/
		public function set verticalGap(value:Number):void{
			_verticalGap=value;
			
			invalidateProperty();
		}
		public function get verticalGap():Number{
			return _verticalGap;
		}
		
		/** 水平网格间隙**/
		public function set gridHorizontalGap(value:Number):void{
			_gridHorizontalGap=value;
			_horizontalGap=(value/Game.gridXMax)*Game.stage.stageWidth;
			
			invalidateProperty();
		}
		public function get gridHorizontalGap():Number{
			return _gridHorizontalGap;
		}
		
		/** 垂直网格间隙**/
		public function set gridVerticalGap(value:Number):void{
			_gridVerticalGap=value;
			_verticalGap=(value/Game.gridYMax)*Game.stage.stageHeight;
			
			invalidateProperty();
		}
		public function get gridVerticalGap():Number{
			return _gridVerticalGap;
		}
		
		/** 重写box的属性提交过程。先于子组件的属性提交声明子组件布局类型**/
		override protected function commitProperty():void{
			super.commitProperty();
			var xSum:Number=0;
			var ySum:Number=0;
			for (var i:int=0;i<this.numChildren;i++){
				var child:DisplayObject=this.getChildAt(i);
				if(child is UIComponent){
					//box布局时，不使用绝对布局。为简单起见，被布局的组件只能在绝对布局和box布局之间二选一，不能动态切换。
					//如需支持，需要增加uiComponent中关于布局属性的字段，用于保存临时布局数据
					(child as UIComponent).absoluteLayout=false;
					
					if(_direction==HORIZONTIAL){		//水平方向
						child.x=xSum;
						xSum+=(child.width+_horizontalGap);
						
						switch(verticalAlign){
							case TOP:
								child.y=0;
								break;
							case MIDDLE:
								child.y=(this.height-child.height)/2;
								break;
							case BOTTOM:
								child.y=this.height-child.height;
								break;
						}
					}else if(_direction==VERTICAL){	//垂直方向
						child.y=ySum;
						ySum+=(child.height+_verticalGap);
						
						switch(horizontalAlign){
							case LEFT:
								child.x=0;
								break;
							case CENTER:
								child.x=(this.width-child.width)/2;
								break;
							case RIGHT:
								child.x=this.width-child.width;
								break;
						}
					}
				}
			}
			
		}
		
		/** 重写计算大小，横向忽略x，纵向忽略y**/
		override protected function measure():void{
			var max:Number = 0;
			var maxH:Number=0;
			for (var i:int = numChildren - 1; i > -1; i--) {
				var comp:DisplayObject = getChildAt(i);
				if (comp.visible) {
					if(_direction==HORIZONTIAL){
						max = Math.max(comp.x + comp.width, max);
						maxH = Math.max(comp.height, maxH);
					}else if(_direction==VERTICAL){	//垂直方向
						max = Math.max(comp.width, max);
						maxH = Math.max(comp.y + comp.height, maxH);
					}
				}
			}
			_measureWidth=max;
			_measureHeight=maxH;
		}
	}
}