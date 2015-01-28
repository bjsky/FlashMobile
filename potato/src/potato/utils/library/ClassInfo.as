package potato.utils.library
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

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
		public var extendEventDic:Dictionary=new Dictionary();
		public var staticFunDic:Dictionary=new Dictionary();
		public var cls:Class;
		public var variableDic:Dictionary=new Dictionary();
		public var constantArr:Array=[];
		
		public function ClassInfo()
		{
		}
		
		public static function parse(cls:*):ClassInfo {
			var xml:XML= describeType(cls);
			var objXml:XML;
			var isStatic:Boolean=(xml.@isStatic=="true");
			// 如果是Class对象，所有实例属性和方法均嵌套在factory标签内
			objXml= isStatic?xml.factory[0]:xml;
//			var isUIComp:Boolean = false;
			var clsInf:ClassInfo= new ClassInfo();	
			clsInf.fullName = isStatic?objXml.@type:objXml.@name;
			clsInf.name = clsInf.fullName.substring(clsInf.fullName.indexOf("::")+2);
			clsInf.cls = isStatic?cls:Class(getDefinitionByName(clsInf.fullName));;
//			if ("potato.ui::Button" != clsInf.fullName) {
//				return null;
//			}
			//继承信息
			var type:String;
			for each (var ec:XML in objXml.extendsClass) {
				type = ec.@type;
				clsInf.extendList.push(type);
			}
			for each (var variable:XML in objXml.variable){
				clsInf.variableDic[String(variable.@name)]=String(variable.@type)
			}
			//接口信息
			for each (var ii:XML in objXml.implementsInterface) {
				type = ii.@type;
				clsInf.implementsList.push(type);
			}
			for each(var constant:XML in xml.constant){
				clsInf.constantArr.push(String(constant.@name));
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
		/**
		 *根据类获取该类的静态方法，用方法名存储为字典，按照顺序存储其参数类型 
		 * @param cls
		 * @return 
		 * 
		 */		
//		public static function getStaticFunDic(cls:*):Dictionary
//		{
//			var xml:XML= describeType(cls);
//			var dic:Dictionary=new Dictionary();
//				for each(var funName:XML in xml.method){
//					dic=getStaticFun(dic,funName)
//				}
//			return dic;
//		}
		
		public static function getEventTip(cls:*):Array
		{
			var xml:XML= describeType(cls);
			var arr:Array=[];
//			for(var )
			var isStatic:Boolean=(xml.@isStatic=="true");
			var objXml:XML= isStatic?xml.factory[0]:xml;
			for each (var ec:XML in objXml.metadata) {
				if(ec.@name=="Event"){
					arr.push(String(ec.arg[0].@value))
				}
			}
			return arr;
		}
		
		/**
		 *根据类获取该类及该类基类所包含的事件，并且以事件名称为字典，事件类型为数组列表存储。 
		 * @param cls
		 * @return 
		 * 
		 */		
		public static function getEventNameDic(cls:*):Dictionary
		{
			var xml:XML= describeType(cls);
			var dic:Dictionary=new Dictionary();
			var isStatic:Boolean=(xml.@isStatic=="true");
			var objXml:XML= isStatic?xml.factory[0]:xml;
			dic=getEventName(dic,getQualifiedClassName(cls));
			for each (var ec:XML in objXml.extendsClass) {
				dic=getEventName(dic,String(ec.@type));
			}
			return dic;
		}
		
		private static function getStaticFun(dic:Dictionary,xml:XML):Dictionary
		{
			var dicValue:Dictionary=new Dictionary();
			var arr:Array=[];
//			取出该函数的所有参数，并且按照顺序存为字典
			for each(var meatData:XML in xml.metadata){
				if(meatData.@name=="Function"){
					for(var i:uint=0;i<meatData.arg.length();i++){
						arr.push({value:String(meatData.arg[i].@key),type:String(meatData.arg[i].@value)})
					}
				}
			}

//			重新按照顺序排序参数
			dic[String(xml.@name)]=arr;

			return dic;
		}
		private static function getEventName(dic:Dictionary,className:String):Dictionary
		{
			// TODO Auto Generated method stub
			var xml:XML = describeType(getDefinitionByName(className))
			var isStatic:Boolean=(xml.@isStatic=="true");
			var objXml:XML= isStatic?xml.factory[0]:xml;
			for each(var str:XML in objXml.metadata){
				if(str.@name=="Event"){
					var eventName:String=String(str.arg[1].@value);
					if(!dic[eventName]){
						dic[eventName]=[];
					}else{
						dic[eventName].push(String(str.arg[0].@value));
					}
				}
			}
			return dic;
		}
	}
}