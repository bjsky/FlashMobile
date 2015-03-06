package potato.display3d
{
	import core.display3d.Material;
	import core.display3d.Mesh;
	
	import potato.display3d.core.MaterialManager;
	import potato.display3d.core.MeshManager;
	import potato.display3d.data.ElemData;
	import potato.display3d.data.MeshElemData;
	import potato.display3d.async.AsyncHandler;
	import potato.utils.DelayTrigger;
	
	public class EffectMeshElem extends EffectContainer
	{
		public function EffectMeshElem(data:ElemData)
		{
			super(data);
		}
		private var _mesh:Mesh;
		
		public function get data():MeshElemData{
			return _data as MeshElemData;
		}
		override protected function createElements():void{
			super.createElements();
			
			if(data.startTime>0)
				DelayTrigger.addDelayTrigger(data.startTime,createMesh);
			else
				createMesh();
		}
		
		/**
		 * 材质
		 * @return 
		 * 
		 */
		public function get mesh():Mesh{
			return _mesh;
		}
		
		/**
		 * 加载创建粒子 
		 * @param elem
		 * 
		 */
		private function createMesh():void{
			removeMesh();
			
			MeshManager.loadMesh(data.meshName,new AsyncHandler(loadMeshComplete));
		}
		
		private function loadMeshComplete(mesh:Mesh):void
		{
			if(mesh){
				_mesh=mesh;
				//材质
				var meshMat:Material=MaterialManager.getMaterial(data.meshMatName);
				if(_mesh.subMeshes.length > 0){
					for (var i:int=0;i<_mesh.subMeshes.length;i++) {
						_mesh.subMeshes[i].material = meshMat;
					}
				}else
					_mesh.material=meshMat;
				
				addChild(mesh);
			}
		}
		
		private function removeMesh():void
		{
			if(_mesh){
				removeChild(_mesh);
				_mesh.dispose();
				_mesh=null;
			}
		}	
		
		override public function dispose():void{
			super.dispose();
			removeMesh();
		}
	}
}