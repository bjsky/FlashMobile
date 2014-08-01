package potato.component.controller
{
	import core.events.Event;
	import core.events.EventDispatcher;
	import potato.gesture.PanGesture;

	/**
	 * 范围平移控制器 
	 * @author liuxin
	 * 
	 */
	public class AreaPanController extends EventDispatcher
	{
		public function AreaPanController(minWidth:Number=0,minHeight:Number=0,maxWidth:Number=0,maxHeight:Number=0)
		{
			this._minWidth=minWidth;
			this._minHeight=minHeight;
			this._maxWidth=maxWidth;
			this._maxHeight=maxHeight;
		}
		
		static public const UPDATE:String="update";
		
		protected var _minWidth:Number;
		protected var _minHeight:Number;
		protected var _maxWidth:Number;
		protected var _maxHeight:Number;

		private var _x:Number=0;
		private var _y:Number=0;
		
		/**
		 * 重设区域 
		 * @param minWidth
		 * @param maxWidth
		 * @param minHeight
		 * @param maxHeight
		 * 
		 */
		public function setArea(minWidth:Number,minHeight:Number,maxWidth:Number,maxHeight:Number):void{
			this._minWidth=minWidth;
			this._minHeight=minHeight;
			this._maxWidth=maxWidth;
			this._maxHeight=maxHeight;
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

		public function panBegin(pan:PanGesture):void{
			
		}
		
		public function panStart(pan:PanGesture):void{
			
		}
		
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
		public function panEnd(pan:PanGesture):void{
			
		}
	}
}