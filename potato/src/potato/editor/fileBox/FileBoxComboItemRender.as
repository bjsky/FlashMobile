

package potato.editor.fileBox
{
	
	import potato.component.classes.TextListItemRenderer;
	import potato.component.data.BitmapSkin;
	import potato.component.data.TextFormat;

	/**
	 * 下拉列表渲染器
	 * @author EricXie
	 * 
	 */	
	public class FileBoxComboItemRender extends TextListItemRenderer
	{
		public static const FONT_BTN_NORMAL:TextFormat=new TextFormat("黑体",22,0xffffff,1,1,null);
		/**
		 *构造函数,规定渲染器字体,宽高 
		 * 
		 */		
		public function FileBoxComboItemRender()
		{
			super();
			this.textFormat=FONT_BTN_NORMAL;
			this.height=33;
//			this.$width=180;
//			render();
		}
		/**
		 *添加数据,分解展示的数据 
		 * @param value
		 * 
		 */		
		override public function set data(value:Object):void
		{
			super.data=value;
			if(data is String)
				text=String(data);
			else if(data.name is String)
				text=String(data.name);
			else if(data.data.name is String)
				text=String(data.data.name);
		}
		
		/**
		 *用于获取展示的数据 
		 * @return 
		 * 
		 */		
		override public function get label():String{
			return text;
		}
		/**
		 *是否被选中 
		 * @param value
		 * 
		 */		

		override public function set selected(value:Boolean):void{
			if(super.selected==value)return;
			super.selected=value;
			if(selected)
				this.skin=new BitmapSkin("textbg.png","5,5,5,5");
			else
				this.skin=null;
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}