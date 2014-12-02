package potato.manager
{
	import potato.potato_internal;
	import potato.component.interf.ISprite;
	import potato.editor.layout.LayoutElement;

	public class LayoutManager
	{
		public function LayoutManager()
		{
		}
		use namespace potato_internal;
		
		static private var layoutArr:Array=[];
		static public function update():void{
//			trace("______layoutManger:"+layoutArr.length)
			for each(var le:LayoutElement in layoutArr){
				if(!le.isValidate)
					le.validate();
			}
		}
		
		static public function add(layout:LayoutElement):void{
			if(layoutArr.indexOf(layout)<0)
				layoutArr.push(layout);
		}
		
		static public function remove(layout:LayoutElement):void{
			var ind:int=layoutArr.indexOf(layout);
			if(ind>-1)
				layoutArr.splice(ind,1);
		}
		
		static public function getElement(sprite:ISprite):LayoutElement{
			for each(var layout:LayoutElement in layoutArr){
				if(layout.ui==sprite)
					return layout;
			}
			return null;
		}
	}
}