package potato.display3d
{
	import potato.display3d.data.EffectData;
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
			super(data)
			
		}
		
		public function get data():EffectData{
			return _data as EffectData;
		}
		
		override protected function createElements():void{
			super.createElements();
			
			if(data.lifeTime>0){
				DelayTrigger.addDelayTrigger(data.lifeTime,removeElements);
			}
		}
		
		
	}
}