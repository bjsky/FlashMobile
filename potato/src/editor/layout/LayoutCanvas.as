package  potato.editor.layout
{
	import flash.net.registerClassAlias;
	
	import potato.potato_internal;
	import potato.component.ISprite;
	
	/**
	 * 绝对布局 
	 * @author liuxin
	 * 
	 */
	public class LayoutCanvas extends Layout
	{
		public function LayoutCanvas(ui:ISprite)
		{
			super(ui);
		}
		use namespace potato_internal;
		
		/**
		 *注册别名  
		 * 
		 */
		static public function registerAlias():void{
			registerClassAlias("potato.layout.LayoutCanvas",LayoutCanvas);
		}
		
//		/**
//		 * 创建一个canvas布局 
//		 * @param ui
//		 * @return 
//		 * 
//		 */
//		static public function create(ui:ISprite):LayoutCanvas{
//			var lc:LayoutCanvas=new LayoutCanvas();
//			lc.ui=ui;
//			return lc;
//		}
//		
		//-----------------------
		// override function
		//-----------------------		
		/**
		 * 重写计算布局的测量宽 
		 * @return 
		 * 
		 */
		override public function measureWidth():Number{
			var max:Number = 0;
			for (var i:int = _childrenElements.length - 1; i > -1; i--) {
				var elem:LayoutElement = _childrenElements[i];
				max = Math.max(elem.x + elem.scaleWidth, max);
			}
			return max;
		}
		
		/**
		 * 重写计算布局的测量宽 
		 * @return 
		 * 
		 */
		override public function measureHeight():Number{
			var max:Number = 0;
			for (var i:int = _childrenElements.length - 1; i > -1; i--) {
				var elem:LayoutElement = _childrenElements[i];
				max = Math.max(elem.y + elem.scaleHeight, max);
			}
			return max;
		}
		
		/**
		 * 重写计算布局 
		 * 
		 */
		override potato_internal function measureLayout():void{
			super.measureLayout();
			
			for each(var elem:LayoutElement in _childrenElements){
				//计算子布局
				if (!isNaN(elem.centerX)) {
					elem.x = (width - elem.scaleWidth) * 0.5 + elem.centerX;
				} else if (!isNaN(elem.left)) {
					elem.x = elem.left;
					if (!isNaN(elem.right)) {
						elem.width = width - elem.left - elem.right;
					}
				} else if (!isNaN(elem.right)) {
					elem.x = width - elem.scaleWidth - elem.right;
				}
				if (!isNaN(elem.centerY)) {
					elem.y = (height - elem.scaleHeight) * 0.5 + elem.centerY;
				} else if (!isNaN(elem.top)) {
					elem.y = elem.top;
					if (!isNaN(elem.bottom)) {
						elem.height = height - elem.top - elem.bottom;
					}
				} else if (!isNaN(elem.bottom)) {
					elem.y = height - elem.scaleHeight - elem.bottom;
				}
				//子计算布局
				elem.measureLayout();
			}
		}
	}
}