package potato.component.controller
{
	import core.events.Event;
	import core.events.EventDispatcher;
	import potato.gesture.PanGesture;

	/**
	 * 平移控制器. 
	 * <p>平移位置算法的基本控制器</p>
	 * @author liuxin
	 * 
	 */
	public class PanController extends EventDispatcher
	{
		public function PanController()
		{
		}
		
		/**
		 * 更新位置事件 
		 */
		static public const UPDATE:String="update";
		
		protected var _minWidth:Number;
		protected var _minHeight:Number;
		protected var _maxWidth:Number;
		protected var _maxHeight:Number;

		private var _x:Number=0;
		private var _y:Number=0;
		
		/**
		 * 设置移动区域 
		 * @param minWidth
		 * @param maxWidth
		 * @param minHeight
		 * @param maxHeight
		 * 
		 */
		public function setArea(minWidth:Number,minHeight:Number,maxWidth:Number,maxHeight:Number):void{
			this._minWidth=minWidth;
			this._minHeight=minHeight;
			this._maxWidth=maxWidth>minWidth?maxWidth:minWidth;
			this._maxHeight=maxHeight>minHeight?maxHeight:minHeight;
		}
		
		/**
		 * x位置 
		 * @return 
		 * 
		 */
		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

		/**
		 * y位置 
		 * @return 
		 * 
		 */
		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		/**
		 * 平移按下
		 * @param pan
		 * 
		 */
		public function panBegin(pan:PanGesture):void{
			
		}
		
		/**
		 * 平移开始 
		 * @param pan
		 * 
		 */
		public function panStart(pan:PanGesture):void{
			
		}
		
		/**
		 * 平移过程中 
		 * @param pan
		 * 
		 */
		public function panMove(pan:PanGesture):void{
			
//			trace("minw:"+_minWidth+",minH:"+_minHeight+",maxW:"+_maxWidth+",maxH:"+_maxHeight+",x:"+x+",y:"+y);
			//直接使用pan的位移
			x+=pan.offsetX;
			if(x<-(_maxWidth-_minWidth))
				x=-(_maxWidth-_minWidth);
			if(x>0)
				x=0;
			
			y+=pan.offsetY;
			if(y<-(_maxHeight-_minHeight))
				y=-(_maxHeight-_minHeight);
			if(y>0)
				y=0;
			
			
			this.dispatchEvent(new Event(UPDATE));
		}
		
		/**
		 * 平移结束 
		 * @param pan
		 * 
		 */
		public function panEnd(pan:PanGesture):void{
			
		}
	}
}