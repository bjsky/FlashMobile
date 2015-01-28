package potato.display3d
{
	import core.display3d.Object3D;
	import core.display3d.Vector3D;
	
	import potato.display3d.behaviour.RotationBehaviour;
	import potato.display3d.data.BehaviourData;
	import potato.display3d.data.EffectData;
	import potato.display3d.data.ElemData;
	import potato.display3d.data.ParticleData;
	import potato.display3d.data.ParticleElemData;
	import potato.display3d.data.behaviour.RotationBehaviourData;
	import potato.utils.DelayTrigger;

	
	/**
	 * 效果容器
	 * @author liuxin
	 * 
	 */
	public class Effect extends GameContainer 
	{
		public function Effect(data:EffectData)
		{
			_data=data;
			
			createEffect();
		}
		
		private var _data:EffectData;
		public function set data(value:EffectData):void{
			_data=value;
			createEffect();
		}
		
		
		/** 子对象**/
		private var elements:Vector.<Object3D>;
		/** 脚本**/
		private var behaviours:Vector.<Behaviour>;
		
		private function createEffect():void{
			removeElements();
			
			//解析数据
			elements=new Vector.<Object3D>();
			behaviours=new Vector.<Behaviour>();
			
			for each(var elemData:ElemData in _data.effectElemDataArr){
				
				if(elemData is ParticleElemData){
					var ped:ParticleElemData = elemData as ParticleElemData;
					
					if(ped.startTime>0)
						DelayTrigger.addDelayTrigger(ped.startTime,createParticle,ped);
					else
						createParticle(ped);
				}else if(elemData is ParticleData){
					var pd:ParticleData= elemData as ParticleData;
//					if(pd.startTime>0)
//						DelayTrigger.addDelayTrigger(pd.startTime,createParticle2,[pd]);
//					else
					var particle:EffectParticle=new EffectParticle(pd);
					addChild(particle);
					elements.push(particle);
					
				}else{		//空容器
					var element:GameContainer=new GameContainer();
					setElementTransfrom(element,elemData);
					addChild(element);
					elements.push(element);
				}
			}
			
			//挂载脚本
			for each(var behaviourdata:BehaviourData in _data.behaviourArr){
				var behaviour:Behaviour;
				if(behaviourdata is RotationBehaviourData){
					behaviour=new RotationBehaviour(behaviourdata as RotationBehaviourData);
				}
				addGameObject(behaviour);
				behaviours.push(behaviour);
			}
			
			if(_data.lifeTime>0){
				DelayTrigger.addDelayTrigger(_data.lifeTime,removeElements);
			}
		}
		
		/**
		 * 加载创建粒子 
		 * @param elem
		 * 
		 */
		private function createParticle(elem:ParticleElemData):void{
			
			var pd:ParticleData=Res3D.getParticleData(elem.particleName);
			var particle:EffectParticle=new EffectParticle(pd);
			setElementTransfrom(particle,elem);
			addChild(particle);
			elements.push(particle);
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
		
		private function removeElements():void{
			//粒子
			var particle:Object3D;
			if(elements){
				while(elements.length>0){
					particle=elements.shift();
					particle.dispose();
					this.removeChild(particle);
				}
			}
			particle=null;
			
			var behaviour:Behaviour;
			if(behaviours){
				while(behaviours.length>0){
					behaviour=behaviours.shift();
					behaviour.dispose();
				}
			}
		}
		
		override public function dispose():void{
			super.dispose();
			removeElements();
		}
		
	}
}