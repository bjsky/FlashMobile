package potato.utils
{
	import core.filters.ColorMatrixFilter;
	import core.filters.ShadowFilter;

	public class Filters
	{
		public function Filters()
		{
		}
		/**
		 * 文字阴影 
		 */
		public static const FILTER_TEXT_SHADOW:ShadowFilter = new ShadowFilter(0xff000000,2,2,false);
		/**
		 * 灰度滤镜 
		 */		
//		public static const FILTER_IMG_GRAY:ColorMatrixFilter=new ColorMatrixFilter(Vector.<Number>([[0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0]]));
		public static const FILTER_IMG_GRAY:ColorMatrixFilter=new ColorMatrixFilter(Vector.<Number>([0.4,0.4,0.4,0,0, 0.4,0.4,0.4,0,0, 0.4,0.4,0.4,0,0, 0,0,0,1,0]));

	}
}