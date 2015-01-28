package  potato.editor.layout
{
	import flash.net.registerClassAlias;
	
	import core.display.DisplayObject;
	
	import potato.potato_internal;
	import potato.component.core.IContainer;
	import potato.component.core.ISprite;
	
	/**
	 * 绝对布局.
	 * <p>使用布局元素的绝对布局属性的布局，包括left，right，top，bottom，centerX，centerY</p> 
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
		
		//-----------------------
		// override function
		//-----------------------		
		/**
		 * 重写宽 
		 * @return 
		 * 
		 */
		override public function get width():Number{
			if(!isNaN(IContainer(ui).explicitWidth))
				return IContainer(ui).explicitWidth;
			else{
				var max:Number = 0;
				for (var i:int = _childrenElements.length - 1; i > -1; i--) {
					var elem:LayoutElement = _childrenElements[i];
					if(DisplayObject(elem.ui).visible)
						max = Math.max(elem.x + elem.scaledWidth, max);
				}
				return max;
			}
		}
		
		/**
		 * 重写高 
		 * @return 
		 * 
		 */
		override public function	get height():Number{
			if(!isNaN(IContainer(ui).explicitHeight))
				return IContainer(ui).explicitHeight;
			else{
				var max:Number = 0;
				for (var i:int = _childrenElements.length - 1; i > -1; i--) {
					var elem:LayoutElement = _childrenElements[i];
					if(DisplayObject(elem.ui).visible)
						max = Math.max(elem.y + elem.scaledHeight, max);
				}
				return max;
			}
		}
		
		/**
		 * 重写计算布局 
		 * 
		 */
		override protected function measureLayout():void{
			super.measureLayout();
			for each(var elem:LayoutElement in _childrenElements){
				//计算子布局
				if (!isNaN(elem.centerX)) {
					elem.$x = (width - elem.scaledWidth) * 0.5 + elem.centerX;
				} else if (!isNaN(elem.left)) {
					elem.$x = elem.left;
					if (!isNaN(elem.right)) {
						elem.$width = width - elem.left - elem.right;
					}
				} else if (!isNaN(elem.right)) {
					elem.$x = width - elem.scaledWidth - elem.right;
				}
				if (!isNaN(elem.centerY)) {
					elem.$y = (height - elem.scaledHeight) * 0.5 + elem.centerY;
				} else if (!isNaN(elem.top)) {
					elem.$y = elem.top;
					if (!isNaN(elem.bottom)) {
						elem.$height = height - elem.top - elem.bottom;
					}
				} else if (!isNaN(elem.bottom)) {
					elem.$y = height - elem.scaledHeight - elem.bottom;
				}
				elem.$x=int(elem.x);
				elem.$y=int(elem.y);
				//子计算布局
				elem.measure();
			}
		}
	}
}