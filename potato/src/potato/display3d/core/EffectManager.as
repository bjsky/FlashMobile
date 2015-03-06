package potato.display3d.core
{
	import flash.utils.Dictionary;
	
	import potato.display3d.Effect;
	import potato.display3d.data.EffectData;

	/**
	 * 效果管理器 
	 * @author liuxin
	 * 
	 */
	public class EffectManager
	{
		public function EffectManager()
		{
		}
		private static var dataDict:Dictionary=new Dictionary();
//		private static var effectDict:WeakDictionary=new WeakDictionary();
		
		/**
		 * 设置效果数据 
		 * @param path
		 * 
		 */
		public static function setEffectData(data:Dictionary):void{
			dataDict=data;
		}
		
		/**
		 * 获取效果 
		 * @param name
		 * @return 
		 * 
		 */
		public static function getEffect(name:String):Effect{
//			var m:Effect=effectDict[name];
//			if (m)
//				return m;
			var md:EffectData=dataDict[name];
			if (md) {
				var m:Effect=new Effect(md);
//				effectDict[name]=m;
				return m;
			}
			
			return null;
		}
	}
}