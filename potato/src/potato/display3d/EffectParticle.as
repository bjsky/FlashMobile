package potato.display3d
{
	import core.effects.ParticleAffector;
	import core.effects.ParticleEmitter;
	import core.effects.ParticleSystem;
	
	import potato.potato_internal;
	import potato.display3d.core.GameObject;
	import potato.display3d.core.IGameContainer;
	import potato.display3d.core.IGameObject;
	import potato.display3d.data.AffectorData;
	import potato.display3d.data.EmitterData;
	import potato.display3d.data.MaterialData;
	import potato.display3d.data.ParticleData;
	
	
	/**
	 * 粒子系统GameObject包装
	 * @author liuxin
	 * 
	 */
	public class EffectParticle extends ParticleSystem
		implements IGameObject
	{
		public function EffectParticle(data:ParticleData=null)
		{
			super();
			_data=data;
			setData();
		}
		use namespace potato_internal;
		
		private var _data:ParticleData;
		
		//////////////////////
		//  IGameObject
		///////////////////////
		private var _tag:String;
		potato_internal var _parentGameObject:IGameContainer;
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
		
		override public function dispose():void{
			super.dispose();
			GameObject.removeGameObjects(parentGameObject,this);
		}
		
		private function setData():void
		{
			// TODO Auto Generated method stub
			if(_data){
				this.type=_data.type;
				this.quota=_data.quota;
				this.defaultWidth=_data.defaultWidth;
				this.defaultHeight=_data.defaultHeight;
				this.commonDirection=_data.commonDirection;
				this.commonUp=_data.commonUp;
				this.worldSpace=_data.worldSpace;
				for each (var ped:EmitterData in _data.emitters){
					var emt:ParticleEmitter=ped.newEmitter();
					if(ped.startTime!=0)
						emt.startTime=ped.startTime;
					this.addEmitter(emt);
				}
				for each(var ad:AffectorData in _data.affectors){
					var affector:ParticleAffector=ad.newAffector();
					this.addAffector(affector);
				}
				
				var md:MaterialData=Res3D.getMaterialData(_data.material);
				material=new GameMaterial(md);
			}
		}
	}
}