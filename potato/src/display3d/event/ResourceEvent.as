package potato.display3d.event
{
	import core.events.Event;
	
	/**
	 * 资源事件
	 * @author liuxin
	 * 
	 */
	public class ResourceEvent extends Event
	{
		/**
		 * 
		 * @param type 事件类型
		 * @param resource 资源
		 * @param args	其他参数
		 * @param bubbles
		 * 
		 */
		public function ResourceEvent(type:String,resource:Object=null,args:Array=null, bubbles:Boolean=false)
		{
			super(type, bubbles);
			this.resource=resource;
			this.args=args;
		}
		
		/** 资源**/
		public var resource:Object;
		
		/** 参数**/
		public var args:Array=[];
		
		/** 纹理完成**/
		static public const TEXTURE_COMPLETE:String="TEXTURE_COMPLETE";
		/** 材质完成**/
		static public const MATERIAL_COMPLETE:String="MATERIAL_COMPLETE";
		/** 地形完成**/
		static public const TERRAIN_COMPLETE:String="Terrain_complete";
	}
}