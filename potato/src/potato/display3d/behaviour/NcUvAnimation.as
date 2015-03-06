package potato.display3d.behaviour
{
	import flash.geom.Point;
	
	import core.display3d.Mesh;
	import core.display3d.UVMatrix;
	import core.display3d.Vector3D;
	
	import potato.display3d.EffectMeshElem;
	import potato.display3d.behaviour.common.NcEffectAniBehaviour;
	import potato.display3d.data.behaviour.NcUvAnimationData;

	public class NcUvAnimation extends NcEffectAniBehaviour
	{
		public var m_fScrollSpeedX:Number = 1.0;
		public var m_fScrollSpeedY:Number = 0.0;
		public var m_fTilingX:Number = 1;
		public var m_fTilingY:Number = 1;
		public var m_fOffsetX:Number = 0;
		public var m_fOffsetY:Number = 0;
		public var m_bUseSmoothDeltaTime:Boolean = false;
		public var m_bFixedTileSize:Boolean = false;
		public var m_bRepeat:Boolean = true;
		public var m_bAutoDestruct:Boolean = false;
		
		protected var m_OriginalScale:Vector3D = new Vector3D();
		protected var m_RepeatOffset:Point = new Point();
		protected var m_EndOffset:Point = new Point();
		
		private var _mesh:Mesh=null;
		
		public function NcUvAnimation(data:NcUvAnimationData)
		{
			m_fUserTag = data.m_fUserTag;
			m_fScrollSpeedX = data.m_fScrollSpeedX;
			m_fScrollSpeedY = data.m_fScrollSpeedY;
			m_fTilingX = data.m_fTilingX;
			m_fTilingY = data.m_fTilingY;
			m_fOffsetX = data.m_fOffsetX;
			m_fOffsetY = data.m_fOffsetY;
			m_bUseSmoothDeltaTime = data.m_bUseSmoothDeltaTime;
			m_bFixedTileSize = data.m_bFixedTileSize;
			m_bRepeat = data.m_bRepeat;
			m_bAutoDestruct = data.m_bAutoDestruct;
		}
		
//		override public function start():void
//		{
//			if(container is EffectMeshElem){
//				var ele:EffectMeshElem = EffectMeshElem(container);
//				var mesh:Mesh = ele.mesh;
//				meshMat = mesh.material;
////				meshMat = EffectMeshElem(container).mesh.material;
//			}
//			if(!meshMat)return;
//			
//			var uv:UVMatrix = new UVMatrix();
//			uv.offsetU = m_fOffsetX;
//			uv.offsetV = -m_fOffsetY;
//			uv.scaleU = m_fTilingX;
//			uv.scaleV = m_fTilingY;
//			uv.scrollAnim(m_fScrollSpeedX, -m_fScrollSpeedY);
//			meshMat.uvMatrix = uv;
//		}
		override public function start():void
		{
			var _elem:EffectMeshElem = container as EffectMeshElem;
			if(_elem.mesh == null)return;
			_mesh = _elem.mesh;
			
			var i:int;
			if(_mesh.subMeshes.length > 0){
				for(i=0;i<_mesh.subMeshes.length;i++){
					_mesh.subMeshes[i].material.uvMatrix = new UVMatrix();
					_mesh.subMeshes[i].material.uvMatrix.offsetU = m_fOffsetX;
					_mesh.subMeshes[i].material.uvMatrix.offsetV = -m_fOffsetY;
					_mesh.subMeshes[i].material.uvMatrix.scaleU = m_fTilingX;
					_mesh.subMeshes[i].material.uvMatrix.scaleV = m_fTilingY;
				}
			}else{
				_mesh.material.uvMatrix = new UVMatrix();
				_mesh.material.uvMatrix.offsetU = m_fOffsetX;
				_mesh.material.uvMatrix.offsetV = -m_fOffsetY;
				_mesh.material.uvMatrix.scaleU = m_fTilingX;
				_mesh.material.uvMatrix.scaleV = m_fTilingY;
			}
			
			var offset:Number = m_fOffsetX + m_fTilingX;
			m_RepeatOffset.x = offset - Math.floor(offset);
			if(m_RepeatOffset.x < 0)
				m_RepeatOffset.x += 1;
			offset = m_fOffsetY + m_fTilingY;
			m_RepeatOffset.y = offset - Math.floor(offset);
			if(m_RepeatOffset.y < 0)
				m_RepeatOffset.y += 1;
			var dt:Number = m_fTilingX - Math.floor(m_fTilingX);
			if(dt < 0)
				dt += 1;
			m_EndOffset.x = 1 - dt;
			dt = m_fTilingY - Math.floor(m_fTilingY);
			if(dt < 0)
				dt += 1;
			m_EndOffset.y = 1 - dt;
			
			InitAnimationTimer();
		}
		override public function update():void
		{
			if(!_mesh){
				start();
				return;
			}
			
//			if(m_bFixedTileSize){//暂时不支持
//				
//			}
//			if(m_bUseSmoothDeltaTime && m_Timer != null){
//				
//			}else{
				m_fOffsetX += m_Timer.GetDeltaTime() * m_fScrollSpeedX;
				m_fOffsetY += m_Timer.GetDeltaTime() * m_fScrollSpeedY;
//			}
			var bCallEndAni:Boolean = false;
			if(m_bRepeat == false && m_Timer != null){
				m_RepeatOffset.x += m_Timer.GetDeltaTime() * m_fScrollSpeedX;
				if(m_RepeatOffset.x < 0 || m_RepeatOffset.x > 1){
					m_fOffsetX = m_EndOffset.x;
					bCallEndAni = true;
				}
				m_RepeatOffset.y += m_Timer.GetDeltaTime() * m_fScrollSpeedY;
				if(m_RepeatOffset.y < 0 || m_RepeatOffset.y > 1){
					m_fOffsetY = m_EndOffset.y;
					bCallEndAni = true;
				}
			}
			
			if(_mesh.subMeshes.length>0){
				for(var i:int=0;i<_mesh.subMeshes.length;i++){
					_mesh.subMeshes[i].material.uvMatrix.offsetU = m_fOffsetX;
					_mesh.subMeshes[i].material.uvMatrix.offsetV = m_fOffsetY;
				}
			}else{
				_mesh.material.uvMatrix.offsetU = m_fOffsetX;
				_mesh.material.uvMatrix.offsetV = m_fOffsetY;
			}
			
			if(bCallEndAni){
				OnEndAnimation();
				if(m_bAutoDestruct)
					OnDestroy();
			}
		}
		
		override protected function OnDestroy():void
		{
			super.OnDestroy();
			if(m_bAutoDestruct)
				container.dispose();
			else
				dispose();
		}
	}
}