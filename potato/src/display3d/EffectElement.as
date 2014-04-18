package potato.display3d
{
	import core.display3d.Material;
	import core.display3d.ObjectContainer3D;
	import core.display3d.Vector3D;
	import core.effects.ParticleEmitter;
	import core.effects.ParticleSystem;
	
	import potato.display3d.event.ResourceEvent;
	import potato.display3d.resource.MeterialResource;
	import potato.mirage3d.data.EffectElemData;
	import potato.mirage3d.data.ParticleEmitterData;
	import potato.utils.DelayTrigger;
	
	
	/**
	 * 效果元素，单个粒子特效的容器
	 * @author liuxin
	 * 
	 */
	public class EffectElement extends ObjectContainer3D
	{
		public function EffectElement(data:EffectElemData)
		{
			super();
			_data=data;
			
			createSpecial();
		}
		
		private var _particle:ParticleSystem;
		
		private var _data:EffectElemData;
		public function set data(value:EffectElemData):void{
			_data=value;
			createSpecial();
		}
		
		private function createSpecial():void{
			if(_data.startTime>0)
				DelayTrigger.addDelayTrigger(_data.startTime,createParticle);
			else
				createParticle();
			
			if(_data.lifeTime>0){
				DelayTrigger.addDelayTrigger(_data.lifeTime,removeParticle);
			}
		}
		
		private function createParticle():void{
			removeParticle();
			
			_particle=new ParticleSystem();
			var metRes:MeterialResource=new MeterialResource(_data.material);		//声明一个材质资源
			metRes.addEventListener(ResourceEvent.MATERIAL_COMPLETE,onMaterialLoaded);
			//场景的加载器去加载
			Game3D.scene.loadController.load(metRes);
			_particle.type=_data.type;
			_particle.quota=_data.quota;
			_particle.defaultWidth=_data.defaultWidth;
			_particle.defaultHeight=_data.defaultHeight;
			_particle.commonDirection=_data.commonDirection;
			_particle.commonUp=_data.commonUp;
			for each (var ped:ParticleEmitterData in _data.emitters){
				var emt:ParticleEmitter=ped.newEmitter();
				if(ped.startTime!=0)
					emt.startTime=ped.startTime;
				_particle.addEmitter(emt);
			}
			for (var i:int=0; i < _data.affectors.length; i++)
				_particle.addAffector(_data.affectors[i]);
			
			//add..
			var v:Vector3D=_data.positon;
			_particle.moveTo(v.x, v.y, v.z);
			v=_data.orientation;
			_particle.rotateTo(v.x, v.y, v.z);
			addChild(_particle);
		}
		
		private function removeParticle():void{
			if(_particle){
				if(_particle.parent)
					_particle.parent.removeChild(_particle);
				_particle.dispose();
				_particle=null;
			}
		}
		
		private function onMaterialLoaded(e:ResourceEvent):void
		{
			var res:MeterialResource=e.currentTarget as MeterialResource;
			res.removeEventListener(ResourceEvent.MATERIAL_COMPLETE,onMaterialLoaded);
			
			if(_particle)
				_particle.material=e.resource as Material;
		}
		
		override public function dispose():void{
			super.dispose();
			
			removeParticle();
		}
	}
}