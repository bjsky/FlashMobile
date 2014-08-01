package  potato.display3d.data
{
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;

	public class ObjData
	{
		public var name:String ;
		public var Entities:Dictionary;
		public var entitiesNum:uint;
		public var Locators:Dictionary
		public var Effects:Dictionary
		
		public function ObjData()
		{
			Entities = new Dictionary();
			Locators = new Dictionary();
			Effects = new Dictionary();
		}
		
		public static function registerAlias():void
		{
			registerClassAlias("potato.mirage3d.data.ObjData",ObjData);
		}
	}
}