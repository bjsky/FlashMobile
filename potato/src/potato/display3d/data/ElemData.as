package potato.display3d.data
{
	import core.display3d.Vector3D;
	

	/**
	 * 元素 
	 * @author win7
	 * 
	 */
	public class ElemData
	{
		public function ElemData()
		{
		}
		/**坐标偏移*/
		public var positon:Vector3D;
		/**朝向*/
		public var orientation:Vector3D;
		/**缩放*/
		public var scale:Vector3D=new Vector3D(1,1,1);
		
		/**
		 * 子元素 
		 */		
		public var effectElemDataArr:Vector.<ElemData>=new Vector.<ElemData>();
		/**
		 * 脚本 
		 */		
		public var behaviourArr:Vector.<BehaviourData>=new Vector.<BehaviourData>();
	}
}