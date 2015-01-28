package potato.component.external
{
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	
	import potato.component.external.ActionData;

	/**
	 * 精灵数据.
	 * <p>编辑器生成文件的数据格式</p>
	 * @author liuxin
	 * 
	 */
	public class SpriteData
	{
		public function SpriteData()
		{
		}

		
		/**
		 * 注册别名 
		 * 
		 */
		static public function registerAlias():void{
			registerClassAlias("potato.component.data.SpriteData",SpriteData);
		}
		
		
		
		private var _id:String = "";
		
		private var _type:String;
		
		private var _desc:String = "";

		private var _runtime:String;
		
		private var _properties:Dictionary=new Dictionary();
		
		private var _children:Vector.<SpriteData>=new Vector.<SpriteData>();
		
		private var _actionList:Vector.<ActionData>=new Vector.<ActionData>();
		
		
		public function get desc():String
		{
			return _desc;
		}

		public function set desc(value:String):void
		{
			_desc = value;
		}


		/**
		 * 精灵id 
		 * @return 
		 * 
		 */
		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			_id = value;
		}
		
		/**
		 * 精灵类型 
		 * @return 
		 * 
		 */
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}
		
		/**
		 * 运行时类名 ，默认为视图，可以为继承视图的任意类型
		 */
		public function get runtime():String
		{
			return _runtime;
		}
		
		/**
		 * @private
		 */
		public function set runtime(value:String):void
		{
			_runtime = value;
		}
		
		/**
		 * 属性字典
		 * @return 
		 * 
		 */
		public function get properties():Dictionary
		{
			return _properties;
		}
		
		public function set properties(value:Dictionary):void
		{
			_properties = value;
		}
		
		/**
		 * 子精灵数据 
		 * @return 
		 * 
		 */
		public function get children():Vector.<SpriteData>
		{
			return _children;
		}

		public function set children(value:Vector.<SpriteData>):void
		{
			_children = value;
		}
		
		/**
		 * 动作列表 
		 * @return 
		 * 
		 */
		public function get actionList():Vector.<ActionData>
		{
			return _actionList;
		}
		
		public function set actionList(value:Vector.<ActionData>):void
		{
			_actionList = value;
		}
		
	}
}