package potato.display3d.data
{
	/**
	 * 网格元素数据 
	 * @author liuxin
	 * 
	 */
	public class MeshElemData extends ElemData
	{
		public function MeshElemData()
		{
			super();
		}
		/**开始播放时间*/
		public var startTime:int = 0;
		/**
		 * mesh 
		 */		
		public var meshName:String;
		/**
		 * mesh材质 
		 */
		public var meshMatName:String;
	}
}