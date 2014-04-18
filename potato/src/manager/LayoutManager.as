package potato.manager
{
	import core.display.DisplayObject;
	import core.events.Event;
	import core.events.EventDispatcher;
	
	import potato.Game;
	import potato.potato_internal;
	import potato.component.UIComponent;
	import potato.event.UIEvent;
	
	/**
	 * 组件布局管理器<br />
	 * 负责调度uiComponent的失效验证机制
	 * @author liuxin
	 * @note 注意在后面的验证阶段不应该产生同样分支的提交，会造成死循环
	 */
	public class LayoutManager extends EventDispatcher
	{
		public function LayoutManager()
		{
		}
		
		use namespace potato_internal;
		/** 验证锁**/
		potato_internal var validateLocked:Boolean=false;
		
		//失效标志位
		private var _invalidatePropertiesFlag:Boolean=false;
		private var _invalidateSizeFlag:Boolean=false;
		private var _invalidateDisplayListFlag:Boolean=false;
		
		//已附加帧事件
		private var listenersAttached:Boolean=false;
		//属性失效队列
		private var _invalidatePropertiesUIComponentQueue:Array=[];
		//大小失效队列
		private var _invalidateSizeUIComponentQueue:Array=[];
		//显示列表失效队列
		private var _invalidateDisplayListUIComponentQueue:Array=[];
		
		/** 属性失效**/
		potato_internal function invalidateProperties(ui:UIComponent):void{
			//标识layoutmanager将在下一帧对大小失效处理
			_invalidatePropertiesFlag=true;
			//任意失效只添加一次enterframe事件
			if(!listenersAttached) 
				attachListeners();
			//多次属性失效只添加一次显示对象
			var index:int=_invalidatePropertiesUIComponentQueue.indexOf(ui);
			if(index==-1)
				_invalidatePropertiesUIComponentQueue.push(ui);
		}
		
		/** 大小失效**/
		potato_internal function invalidateSize(ui:UIComponent):void{
			//标识layoutmanager将在下一帧对大小失效处理
			_invalidateSizeFlag=true;
			//任意失效只添加一次enterframe事件
			if(!listenersAttached) 
				attachListeners();
			//多次大小失效只添加一次显示对象
			var index:int=_invalidateSizeUIComponentQueue.indexOf(ui);
			if(index==-1)
				_invalidateSizeUIComponentQueue.push(ui);
		}
		
		/** 显示列表失效**/
		potato_internal function invalidateDisplayList(ui:UIComponent):void{
			//标识layoutmanager将在下一帧对显示列表失效处理
			_invalidateDisplayListFlag=true;
			//任意失效只添加一次enterframe事件
			if(!listenersAttached) 
				attachListeners();
			//多次显示列表失效只添加一次显示对象
			var index:int=_invalidateDisplayListUIComponentQueue.indexOf(ui);
			if(index==-1)
				_invalidateDisplayListUIComponentQueue.push(ui);
		}
		
		/** 移除队列中的ui**/
		potato_internal function removeUIComponent(ui:UIComponent):void{
			//从属性失效队列中移除引用
			var index:int=_invalidatePropertiesUIComponentQueue.indexOf(ui);
			if(index>-1)
				_invalidatePropertiesUIComponentQueue.splice(index,1);
			//从尺寸失效队列中移除引用
			index=_invalidateSizeUIComponentQueue.indexOf(ui);
			if(index>-1)
				_invalidateSizeUIComponentQueue.splice(index,1);
			//从显示列表失效队列中移除引用
			index=_invalidateDisplayListUIComponentQueue.indexOf(ui);
			if(index>-1)
				_invalidateDisplayListUIComponentQueue.splice(index,1);
			
		}

		/** 添加下一帧验证处理**/
		private function attachListeners():void{
			Game.stage.addEventListener(Event.ENTER_FRAME,doValidate);
			listenersAttached=true;
		}
		
		/** 验证失效**/
		private function doValidate(e:Event):void{
			Game.stage.removeEventListener(Event.ENTER_FRAME,doValidate);
			
			//锁验证过程
			validateLocked=true;
			
			//如果有属性失效的显示对象。则重新验证属性
			if(_invalidatePropertiesFlag)
				validateProperties();
			
			//如果有大小失效的显示对象。则重新验证大小
			if(_invalidateSizeFlag)
				validateSize();
			
			//如果有显示列表失效的显示对象。则重新验证显示列表
			if(_invalidateDisplayListFlag)
				validateDisplayList();
			
			//解锁验证过程
			validateLocked=false;
			
			//验证完成回复帧事件标识
			listenersAttached=false;
			//派发一次渲染事件
			this.dispatchEvent(new UIEvent(UIEvent.RENDER_COMPLETE));
		}
		
		/** 验证属性**/
		private function validateProperties():void{
			//从外向内取出所有的ui依次验证属性
			var ui:UIComponent=removeSmallest(_invalidatePropertiesUIComponentQueue);
			while(ui){
				ui.validateProperty();
				ui=removeSmallest(_invalidatePropertiesUIComponentQueue);
			}
			_invalidatePropertiesFlag=false;
		}
		
		/** 验证大小**/
		private function validateSize():void{
			//从内向外取出所有的ui依次验证大小
			var ui:UIComponent=removeLargest(_invalidateSizeUIComponentQueue);
			while(ui){
				ui.validateSize();
				ui=removeLargest(_invalidateSizeUIComponentQueue);
			}
			_invalidateSizeFlag=false;
		}
		
		/** 验证显示列表**/
		private function validateDisplayList():void{
			var ui:UIComponent=removeSmallest(_invalidateDisplayListUIComponentQueue);
			while(ui){
				ui.validateDisplayList();
				ui=removeSmallest(_invalidateDisplayListUIComponentQueue);
			}
			_invalidateDisplayListFlag=false;
		}
		
		/** 从外到内获取显示对象 **/
		private function removeSmallest(queue:Array):UIComponent{
			var tmp:Array=[];
			//取在显示列表中的显示对象
			for each(var ui:DisplayObject in queue){
				if(ui is UIComponent && ui.parent)
					tmp.push(ui);
			}
			if(tmp.length>0){
				//根据层次排序由小到大
				tmp.sortOn("nestLevel", Array.NUMERIC);
				return queue.splice(queue.indexOf(tmp[0]),1)[0];
			}else
				return null;
		}
		
		/** 从内到外获取显示列表对象 **/
		private function removeLargest(queue:Array):UIComponent{
			var tmp:Array=[];
			//取在显示列表中的显示对象
			for each(var ui:DisplayObject in queue){
				if(ui is UIComponent && ui.parent)
					tmp.push(ui);
			}
			if(tmp.length>0){
				//根据层次排序由大到小	
				tmp.sortOn("nestLevel",Array.DESCENDING | Array.NUMERIC);
				return queue.splice(queue.indexOf(tmp[0]),1)[0];
			}else
				return null;
		}
		
	}
}