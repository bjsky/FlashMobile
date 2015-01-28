package potato.gesture.drag
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import core.display.DisplayObject;
	import core.display.Stage;
	import core.events.Event;
	
	import potato.gesture.GestureEvent;
	import potato.gesture.DragGesture;
	import potato.gesture.DragGesture;

	/**
	 * 拖动管理器.
	 * <p>封装快速拖拽组件的功能。开始拖拽使用doDrag，停止拖拽使用stopDrag</p>
	 * @author liuxin
	 * 
	 */
	public class DragManager
	{
		public function DragManager()
		{
		}
		
		/**
		 * 拖拽组件 
		 * @param dragInitiator 拖拽初始化器，可以是组件或对象
		 * @param drag 拖动事件
		 * @param dragImage 拖拽代理图像，拖动组件本身，将代理设置为组件
		 * @param source 元数据
		 * @param offset 拖拽相对手势的偏移
		 * 
		 */
		static public function doDrag(dragInitiator:DisplayObject,drag:DragGesture,dragImage:DisplayObject=null,source:Object=null,offset:Point=null,dragRect:Rectangle=null):void{
			if(drag.isDragging)
				stopDrag(drag);
			
			drag.isDragging=true;
			drag.dragRectangle=dragRect;
			drag.addEventListener(GestureEvent.DRAG_MOVE,onDrag);
			drag.dragInitiator=dragInitiator;
			drag.dragImage=dragImage;
			drag.dragSource=source;
			if(dragImage){
				//先Stop再start，鼠标被禁用
//				
				var stageX:Number=dragInitiator ? dragInitiator.x :0;
				var stageY:Number=dragInitiator ? dragInitiator.y : 0;
				if(drag.touch){
					stageX=drag.touch.location.x-(offset?offset.x:0);
					stageY=drag.touch.location.y-(offset?offset.y:0);
				}
				if(dragImage==dragInitiator){
					if(dragImage.parent){
						var local:Point=dragImage.parent.globalToLocal(new Point(stageX,stageY));
						dragImage.x=local.x;
						dragImage.y=local.y;
					}
				}else{
					Stage.getStage().addChild(dragImage);
					dragImage.mouseEnabled=false;
					dragImage.x=stageX;
					dragImage.y=stageY;
				}
			}
		}
		
		/**
		 * 拖动中 
		 * @param e
		 * 
		 */
		static private function onDrag(e:Event):void{
			var drag:DragGesture=e.currentTarget as DragGesture;
			if(drag.dragImage){
				if(drag.dragRectangle){
					if(drag.dragImage.x+drag.offsetX>drag.dragRectangle.x && drag.dragImage.x+drag.offsetX<drag.dragRectangle.x+drag.dragRectangle.width){
						drag.dragImage.x+=drag.offsetX;
					}if(drag.dragImage.y+drag.offsetY>drag.dragRectangle.y && drag.dragImage.y+drag.offsetY<drag.dragRectangle.y+drag.dragRectangle.height){
						drag.dragImage.y+=drag.offsetY;
					}
				}else{
					drag.dragImage.x+=drag.offsetX;
					drag.dragImage.y+=drag.offsetY;
				}
				
			}
		}
		
		/**
		 * 停止拖动 
		 * @param drag 拖动事件
		 * 
		 */
		static public function stopDrag(drag:DragGesture):void{
			drag.isDragging=false;
			drag.removeEventListener(GestureEvent.DRAG_MOVE,onDrag);
			if(drag.dragImage){
				if(drag.dragImage==drag.dragInitiator){
//					drag.dragImage.mouseEnabled=true;
					drag.dragImage=null;
				}else{
					Stage.getStage().removeChild(drag.dragImage);
					drag.dragImage.dispose();
					drag.dragImage=null;
				}
			}
			drag.dragInitiator=null;
			drag.dragSource=null;
		}
	}
}