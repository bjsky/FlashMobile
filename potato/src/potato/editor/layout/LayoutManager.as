package potato.editor.layout
{
	import core.display.Stage;
	import core.events.Event;
	
	import potato.potato_internal;
	import potato.component.core.ISprite;

	/**
	 * 布局管理器. 
	 * <p>提供验证布局的静态方法</p>
	 * @author liuxin
	 * 
	 */
	public class LayoutManager
	{
		public function LayoutManager()
		{
		}
		use namespace potato_internal;
		private static var _invalidated:Boolean=false;
		
		private static function invalidate():void {
			if(!_invalidated){
				_invalidated=true;
				Stage.getStage().addEventListener(Event.ENTER_FRAME,onValidate);
			}
		}
		
		private static function onValidate(e:Event):void {
			_invalidated=false;
			Stage.getStage().removeEventListener(Event.ENTER_FRAME, onValidate);
			//			trace("_______render")
			//验证布局
			validateLayout();
		}
		
		
		static private var layoutArr:Array=[];
		static potato_internal function validateLayout():void{
//			trace("______layoutManger:"+layoutArr.length)
			for each(var le:LayoutElement in layoutArr){
				if(!le.isValidate)
					le.validate();
			}
		}
		
		static potato_internal function add(layout:LayoutElement):void{
			if(layoutArr.indexOf(layout)<0)
				layoutArr.push(layout);
		}
		
		static potato_internal function remove(layout:LayoutElement):void{
			var ind:int=layoutArr.indexOf(layout);
			if(ind>-1)
				layoutArr.splice(ind,1);
		}
		
		static private function getElement(sprite:ISprite):LayoutElement{
			for each(var layout:LayoutElement in layoutArr){
				if(layout.ui==sprite)
					return layout;
			}
			return null;
		}
		
		/**
		 * 调用布局失效
		 * @param target
		 * 
		 */
		public static function invalidateLayout(element:LayoutElement):void{
//			trace("_invalidlayout")
			//布局管理器失效，将在下次渲染统一处理失效的布局
			invalidate();
			element.invalidate();
		}
	}
}