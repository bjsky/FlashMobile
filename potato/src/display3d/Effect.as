package potato.display3d
{
	import core.display3d.ObjectContainer3D;
	
	import potato.display3d.data.EffectData;
	import potato.display3d.data.EffectElemData;
	import potato.utils.DelayTrigger;

	
	/**
	 * 效果，粒子系统容器
	 * @author liuxin
	 * 
	 */
	public class Effect extends ObjectContainer3D
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
		
		
		/** 粒子系统**/
		private var particles:Vector.<EffectElement>;
		
		private function createEffect():void{
			removeEffect();
			
			//解析数据
			particles=new Vector.<EffectElement>();
			var particle:EffectElement;
			for each(var elem:EffectElemData in _data.effectElemDataArr){
				particle=new EffectElement(elem);
				addChild(particle);
				particles.push(particle);
			}
			
			if(_data.lifeTime>0){
				DelayTrigger.addDelayTrigger(_data.lifeTime,removeEffect);
			}
		}
		
		private function removeEffect():void{
			var particle:EffectElement;
			if(particles){
				while(particles.length>0){
					particle=particles.shift();
					particle.dispose();
					this.removeChild(particle);
				}
			}
			particles=null;
		}
		
		override public function dispose():void{
			super.dispose();
			removeEffect();
		}
		
	}
}