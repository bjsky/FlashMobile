package potato.display3d.data
{
	import flash.net.registerClassAlias;

	public class TerrainLiquidData
	{
		public static function registerAlias():void
		{
			registerClassAlias("potato.mirage3d.data.TerrainLiquidData",TerrainLiquidData);
		}
		
		/**材质名**/
		public var name:String;
		/**纹理数量**/
		public var num:int;
		/**一毫秒几帧**/
		public var framePerMsec:Number;
	}
}