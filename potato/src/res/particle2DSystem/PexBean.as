package potato.res.particle2DSystem
{
	/**
	 * 对应2D粒子系统编辑器pex配置文件中的一个元素<br/>
	 * pName为元素名称<br/>
	 * values为对象数组，其中对象通过key：value存储xml中的数据
	 */
	public class PexBean
	{
		/**单一属性*/
		public static const TYPE_SIMPLE:int=2;
		/**空属性*/
		public static const TYPE_EMPTY:int=1;
		/**复合属性*/
		public static const TYPE_MULTIPLE:int=3;  
		private var _pName:String;// 节点的名称
		private var _valueArr:Array;// 属性 的key-value对数组
		public function PexBean()
		{
			_valueArr=[];
		}
		/***
		 * 根据一个xml节点数据，填充数据
		 */ 
		public function setData(property:XML):void
		{
			_pName=property.name();
			var temp:XMLList = property.attributes(); 
			
			for(var i:int=0;i<temp.length();i++)
			{
				var key:String = temp[i].name();  
				var tobj:Object = {}; 
				tobj[key] = temp[i].toString();  
				_valueArr.push(tobj);
			}
		}
		/**
		 * 获取属性类型，返回值限定为： TYPE_SIMPLE，TYPE_EMPTY，TYPE_MULTIPLE
		 ***/
		public function getType():int
		{
			if(_valueArr.length==0)
			{
				return TYPE_EMPTY;
			}else if(_valueArr.length==1)
			{
				return TYPE_SIMPLE
			}else if(_valueArr.length>1)
			{
				return TYPE_MULTIPLE;
			}else 
			{
				return TYPE_EMPTY;
			}
		}
		
		/**元素名*/
		public function get pName():String
		{
			return _pName;
		}
		/**属性数组*/
		public function get values():Array
		{
			return _valueArr;
		}
	}
}