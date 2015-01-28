package potato.editor.layoutUI
{
	import flash.utils.Dictionary;
	
	import core.display.DisplayObject;
	
	import potato.editor.layout.LayoutManager;

	/**
	 * 视图状态ui 
	 * @author liuxin
	 * 
	 */
	public class ViewStackUI extends ContainerUI
	{
		public function ViewStackUI()
		{
			super();
		}
		private var _state:*;
		private var _displayMap:Dictionary=new Dictionary();
		
		/**
		 * 状态 
		 * @return 
		 * 
		 */
		public function get state():*
		{
			return _state;
		}

		public function set state(value:*):void
		{
			if(_state!=value){
				_state = value;
				for (var s:*  in _displayMap){
					var ui:DisplayObject =_displayMap[s];
					if(s == _state){
						ui.visible=true;
					}else{
						ui.visible=false;
					}
				}
				LayoutManager.invalidateLayout(layout);
				dispatchEvent(new ViewStackUIEvent(ViewStackUIEvent.STATE_CHANGE,_state));
			}
		}
		
		public function addElment(state:*,display:DisplayObject):void{
			if(_displayMap[state]) return;
			
			_displayMap[state]=display;
			this.addChild(display);
			state=state;
		}
		
		public function removeElment(state:*):void{
			if(!_displayMap[state]) return;
			this.removeChild(_displayMap[state]);
			delete _displayMap[state];
		}
		
		public function getElment(state:*):DisplayObject{
			return  _displayMap[state];
		}
	}
}