package potato.component.controller
{
	
	import flash.geom.Point;
	
	import core.display.DisplayObject;
	import core.events.Event;
	
	import potato.gesture.PanGesture;
	
	import tweenLite.TweenLite;
	import tweenLite.easeing.Back;
	/**
	 * 缓动平移控制器.
	 * <p>ScrollableContainer的默认平移控制器</p>
	 * @author EricXie
	 * 
	 */	
	public class EaseingPanController extends PanController
	{
		
		private var _baseY:Number=0;
		private var acceleration:Number=10;
		private var damp:Number=0.1;
		private var directionX:int=1;
		private var directionY:int=1;
		private var dragDamp:Number=0.5;
		private var trackArrX:Vector.<int>=new Vector.<int>();
		private var trackArrY:Vector.<int>=new Vector.<int>();
		private var tween:TweenLite;
		private var _baseX:Number=0;
		private var contaniner:DisplayObject;
		/**
		 *构造函数 
		 * @param minWidth	最小宽
		 * @param minHeight	最小高
		 * @param maxWidth  最大宽
		 * @param maxHeight 最大高
		 * 
		 */		
		public function EaseingPanController()
		{
			super();
		}
		/**
		 *当按下容器时，清空数据，停止所有缓动 。 
		 * @param pan
		 * 
		 */		
		override public function panBegin(pan:PanGesture):void
		{
				contaniner=pan.target
				trackArrY.length=0;
				_baseY=y;
				_baseX=x;
				initData();
				if(tween){
					tween.kill();
					tween=null;
				}
		}
		/**
		 *当移动时，容器跟随移动，如果超出边界，允许超出一定范围，并引起阻尼运动 
		 * @param pan
		 * 
		 */		
		override public function panMove(pan:PanGesture):void
		{
			var point:Point=contaniner.globalToLocal(pan.location);
			if(point.x<0 || point.x>_maxWidth || point.y>_maxHeight || point.y<0){
				panEnd(pan);
			}
				if((x+pan.offsetX>0) || (x+pan.offsetX<-(_maxWidth-_minWidth))){
					x+=pan.offsetX*dragDamp
				}else{
					x+=pan.offsetX;
				}
				if((y+pan.offsetY>0) || (y+pan.offsetY<-(_maxHeight-_minHeight))){
					y+=pan.offsetY*dragDamp
				}else{
					y+=pan.offsetY;
				}
				this.dispatchEvent(new Event(UPDATE));
			
		}
		/**
		 * 当拖动完成后根据发出抛送的强度，计算抛动方向，并计算跑动轨迹存储数组，用TweenLite缓动发送最后移动位置 
		 * @param pan
		 * 
		 */		
		override public function panEnd(pan:PanGesture):void
		{
			_baseY=y;
			_baseX=x;
			getDirection(pan);
			trackArrY=getTrackArr(_baseY,_maxHeight,_minHeight,directionY,pan.offsetY);
			initData();
			getDirection(pan);
			trackArrX=getTrackArr(_baseX,_maxWidth,_minWidth,directionX,pan.offsetX);
			var lenY:Number;
			var lenX:Number;
			if(trackArrY.length>0){
				lenY=trackArrY[trackArrY.length-1];
			}else{
				lenY=y;
			}
			
			if(trackArrX.length>0){
				lenX=trackArrX[trackArrX.length-1];
			}else{
				lenX=x;
			}
			tween=TweenLite.to(this,0.5,{x:lenX,y:lenY,ease:Back.easeOut,onUpdate:onUpdataHandler,onComplete:onCompleteHandler});
		}
		/**
		 * 获取个方向抛送的轨迹数组
		 * @param _base
		 * @param max
		 * @param min
		 * @param direction
		 * @param offset
		 * @return 
		 * 
		 */		
		private function getTrackArr(_base:Number,max:Number,min:Number,direction:int,offset:Number):Vector.<int>
		{
			var distance:Number=acceleration;
			var tackArr:Vector.<int>=new Vector.<int>();
			if(damp==0){
				damp=0.1;
			}
			if(_base>0){
				while(int(_base)>1){
					distance-=damp;
					_base+=(-1)*Math.abs(distance*direction);
					tackArr.push(int(_base));
				}
				tackArr.push(0)
			}else if(int(_base)<-(max-min)){
				while(int(_base)<-(max-min)){
					distance-=damp;
					_base+=Math.abs(distance*direction);
					tackArr.push(int(_base));
				}
				tackArr.push(-(max-min))
			}else{
				acceleration=Math.abs((offset)/2);
				damp=Math.abs(offset/100);
				if(damp==0){
					damp=0.1;
				}
				distance=acceleration;
				while(distance>0.2){
					distance-=damp;
					_base+=distance*direction;
					if(int(_base)<-(max-min) || int(_base)>0){
						break;
					}
					tackArr.push(int(_base));
				}
			}
			return tackArr;
		}
		/**
		 * 获取抛送方向
		 * @param pan
		 * 
		 */		
		private function getDirection(pan:PanGesture):void
		{
			if(pan.offsetX==0 || pan.offsetX==-1){
				directionX=1;
			}else{
				directionX=(pan.offsetX)/(Math.abs(pan.offsetX));
			}
			
			if(pan.offsetY==0 || pan.offsetY==-1){
				directionY=1;
			}else{
				directionY=(pan.offsetY)/(Math.abs(pan.offsetY));
			}
		}
		/**
		 *更新数据 
		 * 
		 */		
		private function onUpdataHandler():void
		{
			this.dispatchEvent(new Event(UPDATE));
		}
		/**
		 *完成抛送移动以后 
		 * 
		 */		
		private function onCompleteHandler():void
		{
			trackArrY.length=0;
			trackArrX.length=0;
			_baseY=y;
			_baseX=x;
			tween.kill();
			tween=null;
			initData();
		}
		/**
		 *初始化数据 
		 * 
		 */		
		private function initData():void
		{
			acceleration=10;
			damp=0.1;
			directionX=1;
			directionY=1;
			dragDamp=0.2;
		}
	}
}