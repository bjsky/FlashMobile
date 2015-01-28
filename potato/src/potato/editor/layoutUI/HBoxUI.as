package potato.editor.layoutUI
{
	import potato.editor.layout.LayoutBoxDirection;

	/**
	 * 水平布局容器.
	 * <p>包含一个水平布局的容器</p>
	 * @author liuxin
	 * 
	 */
	public class HBoxUI extends BoxUI
	{
		public function HBoxUI(gap:Number=2,horizontalAlign:String="center",verticalAlign:String="center")
		{
			super(gap,horizontalAlign,verticalAlign);
			this.direction=LayoutBoxDirection.HORIZONTIAL;
		}
	}
}