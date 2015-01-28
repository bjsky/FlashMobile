package potato.gesture.drag
{
	
	/**
	 * 拖动进入.
	 * @author liuxin
	 * 
	 */
	[Event(name="dragEnter",type="potato.gesture.drag.DragEvent")]
	/**
	 * 拖动移出.
	 * @author liuxin
	 * 
	 */
	[Event(name="dragExit",type="potato.gesture.drag.DragEvent")]
	/**
	 * 拖动在组件上移动.
	 * @author liuxin
	 * 
	 */
	[Event(name="dragOver",type="potato.gesture.drag.DragEvent")]
	/**
	 * 拖动放下.
	 * @author liuxin
	 * 
	 */
	[Event(name="dragDrop",type="potato.gesture.drag.DragEvent")]
	
	/**
	 * 可放置拖拽对象接口.
	 * <p>通过实现该接口，组件可以接受拖拽放置。当拖拽进入、移出、移动、放置时，组件分别派发DragEvent中的对应事件</p>
	 * @author liuxin
	 * 
	 */
	public interface IDropTrigger
	{
		/**
		 * 放置是否忽略子对象，设置为忽略，其子对象不参与拖动放置验证
		 * @param value
		 * 
		 */
		function set dropIgnoreChildren(value:Boolean):void;
		function get dropIgnoreChildren():Boolean;
		
		/**
		 * 是否可放置 
		 * @param value
		 * 
		 */
		function set dropEnable(value:Boolean):void;
		function get dropEnable():Boolean;
	}
}