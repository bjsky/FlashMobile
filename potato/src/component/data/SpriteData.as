package potato.component.data
{
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	
	import core.display.TextureData;

	/**
	 * 精灵数据 
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
		
		
		
		private var _id:String="";
		
		private var _type:String;
		
		public var assetsPath:String="";
		
		public var assetsName:String="";
		
		/**
		 * 特殊处理,由于内部加载的需要,携带ImageAvatar上的纹理数据 
		 */
		public var imageTextureData:TextureData;
		
		private var _properties:Dictionary=new Dictionary();
		
		private var _children:Vector.<SpriteData>=new Vector.<SpriteData>();
		
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
	}
}