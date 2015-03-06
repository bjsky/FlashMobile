package potato.display3d
{
	import core.display3d.Object3D;
	import core.display3d.ObjectContainer3D;
	import core.display3d.Vector3D;
	
	import potato.potato_internal;
	import potato.display3d.behaviour.NcBillboard;
	import potato.display3d.behaviour.NcCurveAnimation;
	import potato.display3d.behaviour.NcRotation;
	import potato.display3d.behaviour.NcUvAnimation;
	import potato.display3d.core.BehaviourManager;
	import potato.display3d.core.SceneManager;
	import potato.display3d.data.BehaviourData;
	import potato.display3d.data.ElemData;
	import potato.display3d.data.MeshElemData;
	import potato.display3d.data.ParticleElemData;
	import potato.display3d.data.behaviour.NcBillboardData;
	import potato.display3d.data.behaviour.NcCurveAnimationData;
	import potato.display3d.data.behaviour.NcRotationData;
	import potato.display3d.data.behaviour.NcUvAnimationData;
	
	/**
	 * 空容器 
	 * @author liuxin
	 * 
	 */
	public class EffectContainer extends ObjectContainer3D
	{
		public function EffectContainer(data:ElemData)
		{
			super();
			_data=data;
			if(_data)
				createElements();
		}
		use namespace potato_internal;
		
		protected var  _data:ElemData;
		/** 子对象**/
		private var elements:Vector.<Object3D>;
		
		protected function createElements():void{
			removeElements();
			
			//解析数据
			elements=new Vector.<Object3D>();
			
			for each(var elemData:ElemData in _data.effectElemDataArr){
				var element:EffectContainer;
				if(elemData is ParticleElemData){
					element =new EffectParticleElem(elemData as ParticleElemData);
				}else if(elemData is MeshElemData){
					element = new EffectMeshElem(elemData as MeshElemData);
				}else{
					//子容器
					element=new EffectContainer(elemData);
				}
				setElementTransfrom(element,elemData);
				addChild(element);
				elements.push(element);
				
			}
			var behaviours:Vector.<Behaviour>=new Vector.<Behaviour>();
			//挂载脚本
			for each(var behaviourdata:BehaviourData in _data.behaviourArr){
				var behaviour:Behaviour;
				if(behaviourdata is NcRotationData){
					behaviour=new NcRotation(behaviourdata as NcRotationData);
				}else if(behaviourdata is NcCurveAnimationData){//曲线动画脚本
					behaviour = new NcCurveAnimation(behaviourdata as NcCurveAnimationData);
				}else if(behaviourdata is NcBillboardData){
					behaviour = new NcBillboard(SceneManager.camera,behaviourdata as NcBillboardData);
				}else if(behaviourdata is NcUvAnimationData)
					behaviour = new NcUvAnimation(behaviourdata as NcUvAnimationData);
				
				if(behaviour){
					behaviour.setTarget(this);
					behaviours.push(behaviour);
				}
			}
			BehaviourManager.cacheBehaviours(this,behaviours);
		}
		
		private function setElementTransfrom(dispaly:Object3D,elem:ElemData):void{
			//add..
			var v:Vector3D=elem.positon;
			dispaly.moveTo(v.x, v.y, v.z);
			v=elem.orientation;
			dispaly.rotateTo(v.x, v.y, v.z);
			//缩放
			if(elem.scale){
				dispaly.scaleX=elem.scale.x;
				dispaly.scaleY=elem.scale.y;
				dispaly.scaleZ=elem.scale.z;
			}
		}
		
		protected function removeElements():void{
			var element:Object3D;
			if(elements){
				while(elements.length>0){
					element=elements.shift();
					element.dispose();
					this.removeChild(element);
				}
			}
			element=null;
			
			BehaviourManager.disposeBehaviours(this);
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeElements();
			BehaviourManager.disposeBehaviours(this);
		}
	}
}