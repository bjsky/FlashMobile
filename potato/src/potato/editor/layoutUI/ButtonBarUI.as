package potato.editor.layoutUI
{
	import flash.utils.Dictionary;
	
	import core.display.DisplayObject;
	
	import potato.component.Button;
	import potato.component.ToggleGroup;
	import potato.component.event.ToggleGroupEvent;

	/**
	 * 布局按钮组. 
	 * @author liuxin
	 * 
	 */
	public class ButtonBarUI extends BoxUI
	{
		public function ButtonBarUI(gap:Number=2, horizontalAlign:String="center", verticalAlign:String="center")
		{
			super(gap, horizontalAlign, verticalAlign);
			_group=new ToggleGroup();
			_group.addEventListener(ToggleGroupEvent.SELECT_CHANGE,selectChangeHandler);
		}
		
		private function selectChangeHandler(e:ToggleGroupEvent):void
		{
			dispatchEvent(e);
		}
		
		private var _buttonDic:Dictionary=new Dictionary();
		private var _group:ToggleGroup;
		
		override public function addChild(child:DisplayObject):DisplayObject{
			var c:DisplayObject=super.addChild(child);
			if(c is Button)
				addButton(Button(c));
			return c;
		}
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject{
			var c:DisplayObject=super.addChildAt(child,index);
			if(c is Button)
				addButton(Button(c));
			return c;
		}
		override public function removeChild(child:DisplayObject):DisplayObject{
			var c:DisplayObject=super.removeChild(child);
			if(c is Button)
				removeButton(Button(c));
			return c;
		}
		override public function removeChildAt(index:int):DisplayObject{
			var c:DisplayObject=super.removeChildAt(index);
			if(c is Button)
				removeButton(Button(c));
			return c;
		}
		
		private function addButton(button:Button):void{
			if(button.data==null) return;
			button.toggleGroup=_group;
			_buttonDic[button.data]=button;
		}
		
		private function removeButton(button:Button):void{
			if(button.data==null) return;
			button.toggleGroup=null;
			if(_buttonDic[button.data])
				delete _buttonDic[button.data];
		}
		
		public function select(data:*):void{
			if(_buttonDic[data]){
				_group.select(_buttonDic[data]);
			}else{
				_group.select(null);
			}
		}
		
	}
}