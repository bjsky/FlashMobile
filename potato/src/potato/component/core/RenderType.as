package potato.component.core
{
	/**
	 * 渲染类型. 
	 * @author liuxin
	 * 
	 */
	public class RenderType
	{
		public function RenderType()
		{
		}
		
		/**
		 * 延迟渲染
		 */		
		public static const CALLLATER:uint=0;
		/**
		 * 立即渲染
		 */
		public static const IMMEDIATELY:uint=1;
		/**
		 * 手动渲染
		 */
		public static const NONE:uint=2;
		
		
	}
}