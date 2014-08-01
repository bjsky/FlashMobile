package potato.utils
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	public class ClassInfo
	{
		//// 需要排除掉的属性
		private static const excludeProps:Array = ["filter","parent","root","stage"];
		
		public var name:String;			//短名
		public var fullName:String;		//完整名
		public var extendList:Vector.<String> = new Vector.<String>();			//继承类链
		public var implementsList:Vector.<String>=new Vector.<String>();		// 接口类链
//		public var accessorList:Vector.<Accessor> = new Vector.<Accessor>();	
		public var propArr:Array = [];		////属性列表
		public var propDic:Object = new Object();
		
		
		public var cls:Class;
		
		public function ClassInfo()
		{
		}
		
		public static function parse(cls:*):ClassInfo {
			var xml:XML = describeType(cls);
			var objXml:XML;
			
			var isStatic:Boolean=(xml.@isStatic=="true");
			// 如果是Class对象，所有实例属性和方法均嵌套在factory标签内
			objXml= isStatic?xml.factory[0]:xml;
//			var isUIComp:Boolean = false;
			var clsInf:ClassInfo = new ClassInfo();
			clsInf.fullName = isStatic?objXml.@type:objXml.@name;
			clsInf.name = clsInf.fullName.substring(clsInf.fullName.indexOf("::")+2);
			clsInf.cls = isStatic?cls:Class(getDefinitionByName(clsInf.fullName));;
//			
//			if ("potato.ui::Button" != clsInf.fullName) {
//				return null;
//			}
			
			//继承信息
			var type:String;
			for each (var ec:XML in objXml.extendsClass) {
				type = ec.@type;
				clsInf.extendList.push(type);
			}
			//接口信息
			for each (var ii:XML in objXml.implementsInterface) {
				type = ii.@type;
				clsInf.implementsList.push(type);
			}
//			//非UI组件类
//			if (!isUIComp) return null;
//			
			//变量信息
			for each(var ac:XML in objXml.variable){
				var acc:Accessor=new Accessor();
				acc.name=ac.@name;
				acc.type=ac.@type;
				acc.declaredBy=clsInf.fullName;
				acc.access=Accessor.ACCESS_READWRITE;
				
				clsInf.propArr.push(acc.name);
				clsInf.propDic[acc.name] = acc;
			}
			//属性信息
			for each (ac in objXml.accessor) {
				acc = new Accessor();
				acc.name = ac.@name;
				if (excludeProps.indexOf(acc.name) >= 0) {
					continue;
				}
				var access:String = ac.@access;
				if (access == "readonly") {
					acc.access = Accessor.ACCESS_READONLY;
				} else if (access == "writeonly") {
					acc.access = Accessor.ACCESS_WRITEONLY;
				} else if (access == "readwrite") {
					acc.access = Accessor.ACCESS_READWRITE;
				}
				acc.type = ac.@type;
				acc.declaredBy = ac.@declaredBy;
				
				clsInf.propArr.push(acc.name);
				clsInf.propDic[acc.name] = acc;
			}
			
			clsInf.propArr.sort(Array.CASEINSENSITIVE);
			return clsInf;
		}
	}
}