package potato.component.core
{
	import flash.utils.Dictionary;
	

	/**
	 * 焦点管理器.
	 * @author liuxin
	 * 
	 */
	public class FocusManager
	{
		public function FocusManager()
		{
		}
		
		private static var _focusMap:Dictionary=new Dictionary();
		
		/**
		 * 设置焦点对象 
		 * @param target
		 * 
		 */
		public static function setFocus(target:ISprite):void{
			if(!_focusMap[target])
				_focusMap[target]=true;
			
			for (var focus:* in _focusMap){
				if(focus==target)
					focus.onFocus();
				else
					focus.outFocus();
			}
		}
		
		/**
		 * 移除焦点对象引用 
		 * @param target
		 * 
		 */
		public static function deleteFocus(target:ISprite):void{
			if(_focusMap[target])
				delete _focusMap[target];
		}
	}
}