package potato.manager
{
	import flash.geom.Point;
	
	import core.display.DisplayObject;
	import core.display.Stage;
	import core.events.Event;
	
	import potato.event.GestureEvent;
	import potato.gesture.DragGesture;

	/**
	 * 拖动管理器 
	 * @author liuxin
	 * 
	 */
	public class DragManager
	{
		public function DragManager()
		{
		}
		
		static public function doDrag(dragInitiator:DisplayObject,drag:DragGesture,dragImage:DisplayObject=null,source:Object=null,offset:Point=null):void{
			if(drag.isDragging)
				stopDrag(drag);
			
			drag.isDragging=true;
			drag.addEventListener(GestureEvent.DRAG_MOVE,onDrag);
			drag.dragInitiator=dragInitiator;
			drag.dragImage=dragImage;
			drag.dragSource=source;
			if(dragImage){
				//先Stop再start，鼠标被禁用
				dragImage.mouseEnabled=false;
				var stageX:Number=drag.touch.location.x-(offset?offset.x:0);
				var stageY:Number=drag.touch.location.y-(offset?offset.y:0);
				if(dragImage==dragInitiator){
					if(dragImage.parent){
						var local:Point=dragImage.parent.globalToLocal(new Point(stageX,stageY));
						dragImage.x=local.x;
						dragImage.y=local.y;
					}
				}else{
					Stage.getStage().addChild(dragImage);
					dragImage.x=stageX;
					dragImage.y=stageY;
				}
			}
		}
		static private function onDrag(e:Event):void{
			var drag:DragGesture=e.currentTarget as DragGesture;
			if(drag.dragImage){
				drag.dragImage.x+=drag.offsetX;
				drag.dragImage.y+=drag.offsetY;
			}
		}
		
		static public function stopDrag(drag:DragGesture):void{
			drag.isDragging=false;
			drag.removeEventListener(GestureEvent.DRAG_MOVE,onDrag);
			if(drag.dragImage){
				if(drag.dragImage==drag.dragInitiator){
					drag.dragImage.mouseEnabled=true;
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