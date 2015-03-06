package potato.display3d.core
{
	import flash.utils.Dictionary;
	
	import core.effects.ParticleAffector;
	import core.effects.ParticleEmitter;
	import core.effects.ParticleSystem;
	
	import potato.display3d.data.AffectorData;
	import potato.display3d.data.EmitterData;
	import potato.display3d.data.ParticleData;

	/**
	 * 粒子管理器 
	 * @author liuxin
	 * 
	 */
	public class ParticleManager
	{
		public function ParticleManager()
		{
		}
		/**
		 * 粒子数据字典 
		 */
		private static var dataDict:Dictionary=new Dictionary();
		
		/**
		 * 设置粒子数据 
		 * @param path
		 * 
		 */
		public static function setParticleData(data:Dictionary):void{
			dataDict=data;
		}
		
		/**
		 * 获取粒子 
		 * @param name
		 * @return 
		 * 
		 */
		public static function getParticle(name:String):ParticleSystem{
			var pd:ParticleData=dataDict[name];
			if (pd)
				return createParticle(pd);
			return null;
		}
		
		private static function createParticle(pd:ParticleData):ParticleSystem
		{
			var particle:ParticleSystem=new ParticleSystem();
			particle.type=pd.type;
			particle.quota=pd.quota;
			particle.defaultWidth=pd.defaultWidth;
			particle.defaultHeight=pd.defaultHeight;
			particle.commonDirection=pd.commonDirection;
			particle.commonUp=pd.commonUp;
			particle.worldSpace=pd.worldSpace;
			for each (var ped:EmitterData in pd.emitters){
				var emt:ParticleEmitter=ped.newEmitter();
				if(ped.startTime!=0)
					emt.startTime=ped.startTime;
				particle.addEmitter(emt);
			}
			for each(var ad:AffectorData in pd.affectors){
				var affector:ParticleAffector=ad.newAffector();
				particle.addAffector(affector);
			}
			particle.material=MaterialManager.getMaterial(pd.material);
			
			return particle;
		}
	}
}