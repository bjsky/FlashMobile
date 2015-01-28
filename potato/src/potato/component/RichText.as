package potato.component
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import core.display.Image;
	import core.display.Shape;
	import core.display.Texture;
	import core.display.TextureData;
	import core.events.Event;
	import core.events.TextEvent;
	import core.events.TouchEvent;
	
	import potato.component.core.FocusManager;
	import potato.component.core.IFocus;
	import potato.component.core.ISprite;
	import potato.component.core.RenderManager;
	import potato.component.core.RenderType;
	import potato.display.textCompose.ComposeLine;
	import potato.display.textCompose.TextCompose;
	import potato.display.textCompose.TextMetrics;
	
	/**
	 * 富文本组件. 
	 * <p>包装TextCompose文字排版组件，实现丰富的可编辑文本功能。</p>
	 * <p>支持特性:1、任意位置的光标输入回删<br />
	 * 	2、自动滚动显示区域
	 * </p>
	 * @author liuxin
	 * 
	 */
	public class RichText extends TextCompose
		implements ISprite,IFocus
	{
		public function RichText(text:String="",width:Number=100,height:Number=100)
		{
			super(text,width,height);
			
			_selectArea=new Image(null);
			addChildAt(_selectArea,1);
			_selectArea.mouseEnabled=false;
			_arrow=new Image(null);
			addChildAt(_arrow,2);
			
			addEventListener(TouchEvent.TOUCH_BEGIN,touchBeginHandler);
			addEventListener(TouchEvent.TOUCH_MOVE,touchMoveHandler);
			addEventListener(TouchEvent.TOUCH_END,touchEndHandler);
			
			editable=true;
		}
		private var _arrow:Image;
		private var _selectArea:Image;
		
		//----------------------------
		//	ISprite
		//----------------------------
		protected var _scale:Number;
		private var _dataProvider:Object;
		private var _renderType:uint=RenderType.CALLLATER;

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
		 * 验证
		 * 
		 */
		public function validate():void{
			render();
		}
		//---------------------------
		// IFocusable
		//---------------------------
		public function onFocus():void{
			arrowIndex=drawBeginIndex;
			addEventListener(Event.ENTER_FRAME,frameHandler);
			_arrow.visible=true;
		}
		
		public function outFocus():void{
			removeEventListener(Event.ENTER_FRAME,frameHandler);
			_arrow.visible=false;
			arrowIndex=-1;
		}
		//------------------------------
		// event handler
		//------------------------------
		private var _editable:Boolean=true;
		
		/**
		 * 可编辑性 
		 * @return 
		 * 
		 */
		public function get editable():Boolean
		{
			return _editable;
		}

		public function set editable(value:Boolean):void
		{
			_editable = value;
			if(_editable){
				addEventListener(TextEvent.TEXT_INPUT,textInputHandler);
			}else{
				removeEventListener(TextEvent.TEXT_INPUT,textInputHandler);
			}
		}

		private var _beginIndex:int=0;
		private function touchEndHandler(e:TouchEvent):void
		{
			// TODO Auto Generated method stub
//			trace(copyText())
		}
		
		private function touchMoveHandler(e:TouchEvent):void
		{
			// TODO Auto Generated method stub
			var met:TextMetrics=pointToOnDrawMetrics(globalToLocal(new Point(e.stageX,e.stageY)),true);
			var index:int=onDrawMetricsToIndex(met);
			select(_beginIndex,index);
		}
		
		private function touchBeginHandler(e:TouchEvent):void
		{
			// TODO Auto Generated method stub
			FocusManager.setFocus(this);
			var met:TextMetrics=pointToOnDrawMetrics(globalToLocal(new Point(e.stageX,e.stageY)),true);
			_beginIndex=onDrawMetricsToIndex(met);
			select(_beginIndex,_beginIndex);
//			Logger.getLog("RichText").debug("before:"+_arrowIndex)
		}
		
		private function textInputHandler(e:TextEvent):void
		{
			// TODO Auto Generated method stub
			var code:Number=e.text.charCodeAt(0);
			if(isNaN(code))
				return;
			if(_arrowIndex>-1){
				var tL:String=text.substr(0,_arrowIndex);
				var tR:String=text.substr(_arrowIndex);
//				Logger.getLog("RichText").debug(tL,tR)
			}
			if(code==8){		//退格
				var len:int=0;
				if(_selectBeginIndex!=_selectEndIndex){
					len=cutText();
				}else if(tL){
					text=tL.substr(0,tL.length-1)+tR;
					len=1;
				}
				arrowIndex-=len;
			}else{
				text=tL+e.text+tR;
				arrowIndex+=e.text.length;
			}
			_selectArea.texture=null;
			_selectBeginIndex=_selectEndIndex=0;
		}
		
		private var _lastTotalLines:int=0;
		private var _lastDrawLines:int=0;
		
		/**
		 * 重写自动适应垂直滚动位置 
		 * @param value
		 * 
		 */		
		override public function set text(value:String):void{
			super.text=value;
			if(_lastTotalLines!=totalLines || _lastDrawLines!=totalDrawLines){
				_lastTotalLines=totalLines;
				_lastDrawLines=totalDrawLines;
				
				var showLine:int=0;
				var sum:Number=0;
				for (var i:int=_lines.length-1;i>=0;i--){
					var line:ComposeLine=_lines[i];
					sum+=line.lineHeight;
					if(sum>=_height)
						break;
					showLine++;
				}
				scrollV=totalLines-showLine;
			}
		}
		
		/**
		 * 光标索引位置 
		 * @return 
		 * 
		 */
		public function get arrowIndex():int
		{
			return _arrowIndex;
		}
		
		private var _lastTotalLine:int=0;
		public function set arrowIndex(value:int):void
		{
			if(value!=_arrowIndex){
				_arrowIndex = value;
				var met:TextMetrics=indexToMetrics(_arrowIndex);
				if(met){
					if(met.isImg){
						updateArrow(met.x,met.y,met.height);
					}else{
						var line:Number=indexToLineIndex(_arrowIndex);
						updateArrow(met.x,met.y,_lines[line].height);
					}
				}
			}
		}

		
		private var _arrowState:uint=0;
		private var _arrowHeight:Number=0;
		private var _arrowWidth:Number=2;
		private var _lastTime:Number=0;
		private var _arrowRate:int=500;
		private var _arrowtd0:TextureData;
		private var _arrowtd1:TextureData;
		private var _arrowIndex:int=-1;
		
		private function frameHandler(e:Event):void
		{
			if(_arrow){
				var timeSpan:Number=getTimer()-_lastTime;
				if(timeSpan>_arrowRate){
					_lastTime=getTimer();
					arrowState=_arrowState==0?1:0;
				}
			}	
		}
		
		private function get arrowState():uint
		{
			return _arrowState;
		}
		
		private function set arrowState(value:uint):void
		{
			_arrowState = value;
			if(_arrowState==0){
				_arrow.texture=new Texture(_arrowtd0);
			}else{
				_arrow.texture=new Texture(_arrowtd1);
			}
		}
		
		private function updateArrow(x:Number,y:Number,h:Number):void{
			if(h!=_arrowHeight){
				_arrowHeight=h;
				
				_arrowtd0=TextureData.createRGB(_arrowWidth,_arrowHeight);
				var sha0:Shape=new Shape();
				sha0.graphics.beginFill(0x0);
				sha0.graphics.drawRect(0,0,_arrowWidth,_arrowHeight);
				sha0.graphics.endFill();
				_arrowtd0.draw(sha0);
				
				_arrowtd1=TextureData.createRGB(_arrowWidth,_arrowHeight);
				var sha1:Shape=new Shape();
				sha1.graphics.beginFill(0xffffff);
				sha1.graphics.drawRect(0,0,_arrowWidth,_arrowHeight);
				sha1.graphics.endFill();
				_arrowtd1.draw(sha1);
			}
			_arrow.x=x;
			_arrow.y=y;
			arrowState=0;
		}
		
		
		private var _selectColor:uint=0xaaaaaa;
		private var _selectBeginIndex:int=0;
		private var _selectEndIndex:int=0;

		/**
		 * 选中开始索引 
		 * @return 
		 * 
		 */
		public function get selectBeginIndex():int
		{
			return _selectBeginIndex;
		}
		
		/**
		 * 选中结束索引 
		 * @return 
		 * 
		 */
		public function get selectEndIndex():int
		{
			return _selectEndIndex;
		}

		/**
		 * 选中颜色 
		 * @return 
		 * 
		 */
		public function get selectColor():uint
		{
			return _selectColor;
		}
		
		public function set selectColor(value:uint):void
		{
			_selectColor = value;
		}
		
		/**
		 * 复制选中文字
		 * @return 
		 * 
		 */
		public function copyText():String{
			var copystr:String="";
			if(htmlText){
				
			}else{		//text文本
				for (var i:int=_selectBeginIndex ;i<_selectEndIndex;i++){
					copystr+=text.charAt(i);
				}
			}
			return copystr;
		}
		
		/**
		 * 剪切选中文字 
		 * 
		 */
		public function cutText():int{
			var l:String=text.substr(0,_selectBeginIndex);
			var r:String=text.substr(_selectEndIndex,text.length-1)
			text=l+r;
			return _selectEndIndex-_selectBeginIndex;
		}
		/**
		 * 选中索引位置
		 * @param begin 开始索引
		 * @param end 结束索引
		 * 
		 */
		public function select(begin:int,end:int):void{
			_selectBeginIndex=begin<end?begin:end;
			_selectEndIndex=begin<end?end:begin;
			
			_selectArea.texture=null;
			
			if(_selectBeginIndex!=_selectEndIndex){
				var numSum:Number=0;
				var hSum:Number=0;
				var ySum:Number=0;
				var bLineIndex:int=0,eLineIndex:int=0;
				var bMatrics:TextMetrics,eMatrics:TextMetrics;
				
				var find:Boolean=false;
				for (var i:int=0;i< _lines.length;i++){
					var line:ComposeLine=_lines[i];
					for (var j:int=0;j<line.numMetrics;j++){
						if(numSum+j==_selectBeginIndex){
							find=true;
							bLineIndex=i;
							bMatrics=_textMetrics[numSum+j];
						}else if(numSum+j==_selectEndIndex){
							eLineIndex=i;
							eMatrics=_textMetrics[numSum+j];
						}
					}
					
					if(_drawLines.indexOf(line)>-1 && !find){
						ySum+=line.lineHeight;
					}
					
					numSum+=line.numMetrics;
					hSum+=line.lineHeight;
				}
				
				
				var selecttd:TextureData=TextureData.createRGB(_width,hSum);
				var sha:Shape;
				for (i=bLineIndex;i<=eLineIndex;i++){
					line=_lines[i];
					var sx:Number=(i==bLineIndex)?bMatrics.x:line.x;
					var sy:Number=ySum;
					var sw:Number=(i==eLineIndex)?eMatrics.x-sx:line.width-sx;
					var sh:Number=line.lineHeight;
					
					sha=new Shape();
					sha.graphics.beginFill(_selectColor);
					sha.graphics.drawRect(sx,sy,sw,sh);
					sha.graphics.endFill();
					selecttd.draw(sha);
					
					ySum+=line.lineHeight;
				}
				_selectArea.texture=new Texture(selecttd);
			}
			arrowIndex=_selectEndIndex;
		}
		
		
		
		//---------------------------------------
		// assets
		//---------------------------------------
		private function render():void{
			
		}
		
		public override function dispose():void{
			super.dispose();
			
			FocusManager.deleteFocus(this);
			removeEventListener(TextEvent.TEXT_INPUT,textInputHandler);
			removeEventListener(Event.ENTER_FRAME,frameHandler);
			
			removeEventListener(TouchEvent.TOUCH_BEGIN,touchBeginHandler);
			removeEventListener(TouchEvent.TOUCH_MOVE,touchMoveHandler);
			removeEventListener(TouchEvent.TOUCH_END,touchEndHandler);
			
		}
	}
}