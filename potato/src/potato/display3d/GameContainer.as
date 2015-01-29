package potato.display3d
{
	import core.display3d.Object3D;
	import core.display3d.ObjectContainer3D;
	import core.display3d.Vector3D;
	
	import potato.potato_internal;
	import potato.display3d.behaviour.RotationBehaviour;
	import potato.display3d.core.GameObject;
	import potato.display3d.core.IGameContainer;
	import potato.display3d.core.IGameObject;
	import potato.display3d.data.BehaviourData;
	import potato.display3d.data.ElemData;
	import potato.display3d.data.ParticleData;
	import potato.display3d.data.ParticleElemData;
	import potato.display3d.data.behaviour.RotationBehaviourData;
	import potato.utils.DelayTrigger;
	
	/**
	 * 空容器 
	 * @author liuxin
	 * 
	 */
	public class GameContainer extends ObjectContainer3D
		implements IGameContainer
	{
		public function GameContainer(data:ElemData)
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
		/** 脚本**/
		private var behaviours:Vector.<Behaviour>;
		
		protected function createElements():void{
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
					var element:GameContainer=new GameContainer(elemData);
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
			
			var behaviour:Behaviour;
			if(behaviours){
				while(behaviours.length>0){
					behaviour=behaviours.shift();
					behaviour.dispose();
				}
			}
		}
		
		
		
		/////////////////////////////////
		// children override 
		//////////////////////////////////
		override public function addChild(child:Object3D):Object3D{
			var c:Object3D=super.addChild(child);
			if(c is IGameObject)
				addGameObject(IGameObject(c));
			return c;
		}
		
		override public function removeChild(child:Object3D):Object3D{
			var c:Object3D=super.removeChild(child);
			if(c is IGameObject)
				removeGameObject(IGameObject(c));
			return c;
		}
		
		///////////////////
		// IMuComponent
		//////////////////
		private var _tag:String;
		potato_internal var _parentGameObject:IGameContainer;
		potato_internal var _childrenGameObjects:Vector.<IGameObject>=new Vector.<IGameObject>();
		/**
		 * 标签 
		 * @param name
		 * 
		 */		
		public function set tag(name:String):void{
			_tag=name;
		}
		
		public function get tag():String{
			return _tag;
		}
		
		/**
		 * 父游戏对象 
		 * @return 
		 * 
		 */
		public function get parentGameObject():IGameContainer
		{
			return _parentGameObject;
		}
		
		/**
		 * 添加子游戏对象
		 * @param object
		 * 
		 */
		public function addGameObject(object:IGameObject):void
		{
			GameObject.addGameObjects(this,object);
		}
		
		/**
		 * 移除子游戏对象
		 * @param object
		 * 
		 */
		public function removeGameObject(object:IGameObject):void
		{
			GameObject.removeGameObjects(this,object);
		}
		
		/**
		 * 获取该类型的第一个子游戏对象
		 * @param object
		 * 
		 */
		public function getGameObject(type:Class):IGameObject
		{
			return GameObject.getGameObject(this,type);
		}
		
		/**
		 * 获取该类型的所有子游戏对象
		 * @param object
		 * 
		 */
		public function getGameObjects(type:Class):Vector.<IGameObject>
		{
			return GameObject.getGameObjects(this,type);
		}
		
		/**
		 * 子游戏对象 
		 * @return 
		 * 
		 */
		public function get childrenGameObjects():Vector.<IGameObject>{
			return _childrenGameObjects;
		}
		
		override public function dispose():void{
			super.dispose();
			
			GameObject.removeGameObjects(parentGameObject,this);
			removeElements();
		}
	}
}