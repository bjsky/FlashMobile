package potato.editor.layoutUI
{
	import potato.editor.layout.LayoutBoxDirection;

	/**
	 * 垂直布局容器.
	 * <p>包含一个垂直布局的容器</p>
	 * @author liuxin
	 * 
	 */
	public class VBoxUI extends BoxUI
	{
		public function VBoxUI(gap:Number=2, horizontalAlign:String="center", verticalAlign:String="center")
		{
			super(gap, horizontalAlign, verticalAlign);
			this.direction=LayoutBoxDirection.VERTICAL;
		}
	}
}