package potato.manager
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import core.display.DisplayObject;
	import core.events.Event;
	import core.events.TouchEvent;
	
	import potato.potato_internal;
	import potato.event.SystemTouchEvent;
	import potato.gesture.Gesture;
	import potato.gesture.Touch;
	import potato.logger.Logger;

	/**
	 * 手势管理器.
	 * <p>管理系统中所有手势的触发，冒泡等行为。</p> 
	 * @author liuxin
	 * 
	 */
	public class GestureManager
	{
		public function GestureManager()
		{
		}
		use namespace potato_internal;
		/**
		 * 显示对象的手势映射，每个显示对象可以包含多个手势
		 */
		static private var _displayobjectGestureMap:Dictionary=new Dictionary();
		/**
		 * 触控点集合 
		 */
		static private var _touchesMap:Dictionary=new Dictionary();
		/**
		 * 开始 
		 */
		static private var BEGIN:uint=1;
		/**
		 * 移动 
		 */
		static private var MOVE:uint=2;
		/**
		 * 结束 
		 */
		static private var END:uint=4;
		
		
		/**
		 * logger 
		 */
		static private var _log:Logger=Logger.getLog("GestureManager")
			
			
		/**
		 * 添加一个手势 
		 * @param gesture
		 * 
		 */
		static potato_internal function addGesture(gesture:Gesture):void{
			if(!gesture.target) return;
			var gesutres:Array;
			if(_displayobjectGestureMap[gesture.target]){
				gesutres=_displayobjectGestureMap[gesture.target];
				if(gesutres.indexOf(gesture)<0)		//判断重复
					gesutres.push(gesture);
			}else{
				gesutres=[gesture];
				gesture.target.addEventListener(TouchEvent.TOUCH_BEGIN,touchHandler);
				gesture.target.addEventListener(TouchEvent.MULTI_TOUCH_BEGIN,touchHandler);
				gesture.target.addEventListener(TouchEvent.TOUCH_MOVE,touchHandler);
				gesture.target.addEventListener(TouchEvent.MULTI_TOUCH_MOVE,touchHandler);
				gesture.target.addEventListener(TouchEvent.TOUCH_END,touchHandler);
				gesture.target.addEventListener(TouchEvent.MULTI_TOUCH_END,touchHandler);
				
			}
			_displayobjectGestureMap[gesture.target]=gesutres;
		}
		
		/**
		 * 移除一个手势 
		 * @param gesture
		 * 
		 */
		static potato_internal function removeGesture(gesture:Gesture):void{
			if(!gesture.target) return;
			var gestures:Array=_displayobjectGestureMap[gesture.target];
			var ind:int=gestures.indexOf(gesture);
			if(ind>-1){
				gestures.splice(ind,1);
				if(gestures.length==0){
					gesture.target.removeEventListener(TouchEvent.TOUCH_BEGIN,touchHandler);
					gesture.target.removeEventListener(TouchEvent.MULTI_TOUCH_BEGIN,touchHandler);
					gesture.target.removeEventListener(TouchEvent.TOUCH_MOVE,touchHandler);
					gesture.target.removeEventListener(TouchEvent.MULTI_TOUCH_MOVE,touchHandler);
					gesture.target.removeEventListener(TouchEvent.TOUCH_END,touchHandler);
					gesture.target.removeEventListener(TouchEvent.MULTI_TOUCH_END,touchHandler);
					delete _displayobjectGestureMap[gesture.target];
				}
			}
		}
		
		
		/**
		 * 触摸事件处理 
		 * @param e
		 * 
		 */
		static private function touchHandler(e:TouchEvent):void{
//			_log.debug("[Begin]currentTarget:"+getQualifiedClassName(e.currentTarget)+",target:"+getQualifiedClassName(e.target)
//				+",touchId:"+e.touchPointID+",lx:"+e.localX+",ly:"+e.localY);
			if (e is SystemTouchEvent)
				return;
			stopEvent(e);
			
			var touchID:int=e.touchPointID;
			var touch:Touch;
			var type:uint;
			if (e.type == TouchEvent.TOUCH_BEGIN || e.type == TouchEvent.MULTI_TOUCH_BEGIN) {
				type=BEGIN;
				//创建touch
				touch=new Touch(touchID);
				touch.target=e.target as DisplayObject;
				touch.touchTarget=e.currentTarget as DisplayObject;
				touch.setLocation(e.stageX,e.stageY,getTimer(),e.target);
				_touchesMap[touchID]=touch;
				
			} else if (e.type == TouchEvent.TOUCH_MOVE || e.type == TouchEvent.MULTI_TOUCH_MOVE) {
				type=MOVE;
				
				touch = _touchesMap[e.touchPointID] as Touch;
				if(!touch) return;
				touch.updateLocation(e.stageX,e.stageY, getTimer(),e.target);
					
			} else if (e.type == TouchEvent.TOUCH_END || e.type == TouchEvent.MULTI_TOUCH_END) {
				type=END;
				
				touch = _touchesMap[e.touchPointID] as Touch;
				if(!touch) return;
				touch.updateLocation(e.stageX,e.stageY, getTimer(),e.target);
			}
			
			//冒泡显示列表链
			bubblesChains(touch,touch.target,type);
		}
		
		/**
		 * 阻止原生触摸事件，包装系统触摸事件冒泡
		 * @param e
		 * 
		 */
		static private function stopEvent(e:TouchEvent):void {
			var event:Event = new SystemTouchEvent(e.type, e.bubbles, e.localX, e.localY, e.touchPointID);
			e.stopPropagation();
			if(e.currentTarget is DisplayObject && DisplayObject(e.currentTarget).parent)
				DisplayObject(e.currentTarget).parent.dispatchEvent(event);
		}
		
		/**
		 * 冒泡对象链 
		 * @param touch
		 * @param current
		 * @param type
		 * @param bubbles
		 * 
		 */
		static private function bubblesChains(touch:Touch,current:DisplayObject,type:uint,bubbles:Boolean=true):void{
			//跟踪对象为触摸的对象时使用初始值，否则使用跟踪的冒泡值
			bubbles=(current==touch.target)?true:bubbles;
			
			var cur:DisplayObject=current;
			//向上找绑定手势的显示对象
			while(!keyInDic(_displayobjectGestureMap,cur)){	
				cur=cur.parent;
				if(!cur)
					break;
			}
			if(cur){	//找到显示对象
				var gestures:Array=_displayobjectGestureMap[cur];	
				
				//显示对象内部的冒泡使用初始值
				var innerBubbles:Boolean=bubbles;
				for each(var gesture:Gesture in gestures){
					if(!gesture.enable)
						continue;
					if(bubbles){
						//判断类型
						if(type==BEGIN)
							gesture.touchBeginHanlder(touch);
						else if(type==MOVE)
							gesture.touchMoveHanlder(touch);
						else if(type== END)
							gesture.touchEndHanlder(touch);
					}
					//记录冒泡值
					innerBubbles = innerBubbles && gesture.bubbles;
				}
				bubbles=innerBubbles;
				
				if(cur.parent){
					bubblesChains(touch,cur.parent,type,bubbles);
				}
			}
		}
		
		static private function keyInDic(dic:Dictionary,value:*):Boolean{
			for (var key:* in dic){
				if(key==value){
					return true;
				}
			}
			return false;
		}
	}
	
}