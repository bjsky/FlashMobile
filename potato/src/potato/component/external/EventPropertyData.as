package potato.component.external
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import core.display.DisplayObject;
	import core.display.Stage;
	public class EventPropertyData
	{
		private static const PARAMETERS:Object={
			"openFun":[
				{value:"eventTarget",type:"Object"},
				{vlaue:"funName",type:"打开"},
				{value:"targetID=",type:"组件ID或别名|String"},
				{value:"viewPath=",type:"加载路径|EventViewPath"},
				{value:"duration=",type:"效果时长|Number"},
				{value:"effectKind",type:"效果类型|EventProperty"},
				{value:"speed",type:"速度|EventProperty"},
				{value:"startPosition",type:"起始位置|EventProperty"},
				{value:"alpha",type:"透明度|EventProperty"},
				{value:"scale",type:"缩放目标|EventProperty"}
			],
			"closeFun":[
				{value:"eventTarget",type:"Object"},
				{vlaue:"funName",type:"关闭"},
				{value:"targetID=",type:"组件ID或别名|String"},
				{value:"duration=",type:"效果时长|Number"},
				{value:"effectKind",type:"效果类型|EventProperty"},
				{value:"speed",type:"速度|EventProperty"},
				{value:"startPosition",type:"结束位置|EventProperty"},
				{value:"alpha",type:"透明度|EventProperty"},
				{value:"scale",type:"缩放目标|EventProperty"}
			],
			"visibleFun":[
				{value:"eventTarget",type:"Object"},
				{value:"funName",type:"显示隐藏"},
				{value:"targetID",type:"目标ID|String"},
				{value:"visible",type:"是否可见|Boolean"}
			],
			"move":[
				{value:"eventTarget",type:"Object"},
				{value:"funName",type:"移动"},
				{value:"targetID",type:"目标ID|String"},
				{value:"finishX",type:"结束X坐标|Number"},
				{value:"finishY",type:"结束Y坐标|Number"},
				{value:"duration",type:"时常|Number"}
			]
		};
		public static function getEventFunDic():Object
		{
			return PARAMETERS;
		}
		public static const PARAMETERS_DEFAULT_VALUE:Object={
			"openFun":[null,null,"",null,2,"Back","easeIn",0,null,null],
			"closeFun":[null,null,"",2,"Back","easeIn",1,null,null],
			"visibleFun":[null,null,"",false],
			"move":[null,null,"",0,0,2]
		};
		public static function getFunParamDefValue(funName:String,paramIndex:int):Object
		{
			if(PARAMETERS_DEFAULT_VALUE[funName]==null)
			{
				return null;
			}else
			{
				var defArr:Array=PARAMETERS_DEFAULT_VALUE[funName] as Array;
				if(paramIndex>defArr.length||paramIndex<0)
				{
					trace("参数序号超了。");
					return null;
				}else
				{
					return defArr[paramIndex];
				}
			}
		
		}
		public static const PARAMETERS_LIST:Object={
			"是否可见":[{name:"可见",data:true},{name:"不可见",data:false}],
			"起始位置":[{name:"左",data:0},{name:"右",data:1},{name:"上",data:2},{name:"下",data:3},{name:"中间",data:4}],
			"结束位置":[{name:"左",data:0},{name:"右",data:1},{name:"上",data:2},{name:"下",data:3},{name:"中间",data:4}],
			"透明度":[{name:"变透明",data:0},{name:"变半透明",data:0.5},{name:"变不透明",data:1}],
			"速度":[{name:"加速",data:"easeIn"},{name:"减速",data:"easeOut"},{name:"先加后减",data:"easeInOut"}],
			"缩放目标":[{name:"0.5倍",data:0.5},{name:"1倍",data:1},{name:"1.5倍",data:1.5},{name:"2倍",data:2}],
			"效果类型":[{name:"Back",data:"Back"},
					  {name:"Bounce",data:"Bounce"},
					  {name:"Circ",data:"Circ"},
					  {name:"Cubic",data:"Cubic"},
					  {name:"Elastic",data:"Elastic"},
					  {name:"Expo",data:"Expo"},
					  {name:"Linear",data:"Linear"},
					  {name:"Quad",data:"Quad"},
					  {name:"Quart",data:"Quart"},
					  {name:"Quint",data:"Quint"},
					  {name:"Sine",data:"Sine"},
					  {name:"Strong",data:"Strong"}
					]
		};
		
		/**
		 * 根据PARAMETERS_LIST中的key和属性值 获得属性值含义的文字。
		 * 
		 */
		public static function getParameterValueByData(key:String,data:*):String
		{
			var valueName:String;
			var arr:Array=PARAMETERS_LIST[key] as Array;
			if(arr==null)
			{
				return valueName;
			}
			for(var i:int=0;i<arr.length;i++)
			{
				if(arr[i].data==data)
				{
					valueName=arr[i].name as String;
					return valueName;
				}
			}
			return valueName;
		}
		/**
		 *  打开关闭行为，设置坐标
		 * @param directValue 方向（0,1,2,4）(左右上下)
		 * @param disParent 父容器
		 * @param disDisplay 自身
		 */
		public static function getPosition(directValue:int,disDisplay:DisplayObject,scale:Number=1):Point
		{
			var p:Point=new Point();
			var xV:Number;
			var yV:Number;
			var stageWidth:Number=Stage.getStage().stageWidth;
			var stageHeight:Number=Stage.getStage().stageHeight;
			switch(directValue)
			{
				case 0:
					xV=-disDisplay.width*scale;
					yV=(stageHeight-disDisplay.height)>>1;
					trace("左");
					break;
				case 1:
					xV=stageWidth+disDisplay.width*scale;
					yV=(stageHeight-disDisplay.height*scale)>>1;
					trace("右");
					break;
				case 2:
					xV=(stageWidth-disDisplay.width*scale)>>1;
					yV=-disDisplay.height*scale;
					trace("上");
					break;
				case 3:
					xV=(stageWidth-disDisplay.width*scale)>>1;
					yV=stageHeight+disDisplay.height*scale;
					trace("下");
					break;
				case 4:
					xV=(stageWidth-disDisplay.width*scale)>>1;
					yV=(stageHeight-disDisplay.height)>>1;
					trace("中");
					break;
			}
			p.x=xV;
			p.y=yV;
			return p;
		}
		public static function getCenterPosition(disDisplay:DisplayObject,scale:Number=1):Point
		{
			var p:Point=new Point();
			var stageWidth:Number=Stage.getStage().stageWidth;
			var stageHeight:Number=Stage.getStage().stageHeight;
			p.x=(stageWidth-disDisplay.width*scale)>>1;
			p.y=(stageHeight-disDisplay.height*scale)>>1;
			return p;
		}
		private static var OPEN_DICTIONARY:Dictionary=new Dictionary();
		/**
		 * 指定id的窗口是否被打开？
		 */
		public static function isOpen(windowId:String):Boolean
		{
			return OPEN_DICTIONARY[windowId]==null?false:true;
		}
		public static function getWindowById(windowId:String):DisplayObject
		{
			return OPEN_DICTIONARY[windowId];
		}
		public static function setWindow(windowId:String,displayObject:DisplayObject):void
		{
			OPEN_DICTIONARY[windowId]=displayObject;
		}
		public static function delWindowById( windowId:String):void
		{
			delete OPEN_DICTIONARY[windowId];
		}
		public static function reset():void
		{
			OPEN_DICTIONARY=new Dictionary();
		}
	}
}