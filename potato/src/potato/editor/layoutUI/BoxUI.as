package potato.editor.layoutUI
{
	import potato.editor.layout.LayoutBox;
	
	/**
	 * box布局容器.
	 * <p>box布局的容器</p> 
	 * @author liuxin
	 * 
	 */
	public class BoxUI extends ContainerUI
	{
		public function BoxUI(gap:Number=2,horizontalAlign:String="center",verticalAlign:String="center")
		{
			super();
			
			this.gap=gap;
			this.horizontalAlign=horizontalAlign;
			this.verticalAlign=verticalAlign;
			
		}
		override protected function createLayout():void{
			_layout=new LayoutBox(this);
		}
		
		private function get boxLayout():LayoutBox{
			return _layout as LayoutBox;
		}
		
		public function get horizontalAlign():String
		{
			return boxLayout.horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			boxLayout.horizontalAlign = value;
		}
		
		public function get verticalAlign():String
		{
			return boxLayout.verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			boxLayout.verticalAlign = value;
		}
		
		public function set gap(value:Number):void{
			boxLayout.gap=value;
		}
		public function get gap():Number{
			return boxLayout.gap;
		}
		
		public function set direction(value:String):void{
			boxLayout.direction=value;
		}
		public function get direction():String{
			return boxLayout.direction;
		}
		
		
	}
}