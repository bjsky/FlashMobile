package potato.utils
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class ObjectUtil
	{
		public function ObjectUtil()
		{
		}
		
		/**
		 * 对象深度拷贝 
		 * @param object
		 * @return 
		 * 
		 */
		static public function cloneObject(object:Object):Object{
			var qClassName:String = getQualifiedClassName(object);  
			qClassName=qClassName.replace("::",".");
			var objectType:Class = getDefinitionByName(qClassName) as Class;  
			registerClassAlias(qClassName, objectType);//这里
			var copier : ByteArray = new ByteArray();  
			copier.writeObject(object);  
			copier.position = 0;  
			return copier.readObject();  
		}
		
		static public function countDict(dict:Dictionary):Number{
			var i:Number=0;
			for (var key:* in dict){
				i++;
			}
			return i;
		}
	}
}