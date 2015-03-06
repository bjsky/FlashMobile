package potato.display3d
{
	import core.effects.ParticleSystem;
	
	import potato.display3d.core.ParticleManager;
	import potato.display3d.data.ParticleElemData;
	import potato.utils.DelayTrigger;
	
	/**
	 * 粒子容器
	 * @author liuxin
	 * 
	 */
	public class EffectParticleElem extends EffectContainer
	{
		public function EffectParticleElem(data:ParticleElemData)
		{
			super(data);
		}
		private var _particle:ParticleSystem;
		
		public function get data():ParticleElemData{
			return _data as ParticleElemData;
		}
		
		/**
		 * 粒子 
		 * @return 
		 * 
		 */
		public function get particle():ParticleSystem{
			return _particle;
		}
		
		override protected function createElements():void{
			super.createElements();
			
			if(data.startTime>0)
				DelayTrigger.addDelayTrigger(data.startTime,createParticle);
			else
				createParticle();
		}
		
		/**
		 * 加载创建粒子 
		 * @param elem
		 * 
		 */
		private function createParticle():void{
			removeParticle();
			_particle=ParticleManager.getParticle(data.particleName);
			addChild(_particle);
		}
		
		private function removeParticle():void
		{
			if(_particle){
				removeChild(_particle);
				_particle.dispose();
				_particle=null;
			}
		}		
		
		override public function dispose():void{
			super.dispose();
			removeParticle();
		}
	}
}