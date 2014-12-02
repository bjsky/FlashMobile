package potato.component.action
{
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	import core.display.DisplayObject;
	import core.display.DisplayObjectContainer;
	
	import potato.component.View;
	
	import tweenLite.TweenLite;
	import tweenLite.easeing.Back;

	public class EventAction
	{
		public function EventAction()
		{
		}
		public function execute(view:View,funcName:String,args:Array):void
		{
			var target:DisplayObject;
			
				if(args[0] is DisplayObject){
					target=args[0];// this or "" 的情况
				}else if(args[1]){
					target=view.getSprite(args[1].value);// 尝试根据id从view中获取组件的引用
				}
				if(target==null)
				{
					target=EventPropertyData.getWindowById(args[1].value);// 尝试根据id去打开字典中获取引用
				}
			args[0]=target;
			EventAction[funcName](view,args);
		}
		

//		[Function(eventTarget="Object",funName="移动",targetID="目标ID|String",finishX="结束X坐标|Number",finishY="结束Y坐标|Number",duration="时常|Number")]
		public static function move(_view:View,args:Array):void
		{
			if(args.length!=5) return;
			if(!args[0]) return;
			TweenLite.to(args[0],Number(args[4].value),{x:Number(args[2].value),y:Number(args[3].value)});
		}

//		[Function(eventTarget="Object",funName="显示隐藏",targetID="目标ID|String",visible="是否可见|Boolean")]
		public static function visibleFun(_view:View,args:Array):void
		{
			if(args.length!=3) return;
			if(!args[0]) return;
//			args[0][args[2].name]=Boolean(args[2].value);
			args[0].visible=Boolean(args[2].value);
		}
				

//		[Function(eventTarget="Object",funName="打开",targetID="组件ID或别名|String",viewPath="加载路径|EventViewPath",duration="效果时长|Number",
//			effectKind="效果类型|EventProperty",speed="速度|EventProperty",
//			startPosition="起始位置|EventProperty",alpha="透明度|EventProperty",scale="缩放目标|EventProperty"
//		)]
		public static function openFun(_view:View,args:Array):void
		{
			var targetObj:DisplayObject=_view;
			var pContainer:DisplayObjectContainer=targetObj.parent;
			if(!pContainer)
				return;
			if(!args[1]||!args[3]||!args[4]||!args[5]||!args[6])
				return;
			if(EventPropertyData.isOpen(args[1].value))
				return;
			// 这里先试图采用id获取组件，然后才去加载外部view
			var newWindow:DisplayObject;
			newWindow =_view.getSprite(args[1].value);
//			newWindow=args[0];// 打开不理会this指代的当前操作对象，否则会引起this指向的混乱
			if(newWindow==null)
			{
				if(!args[2])
					return;
				newWindow=new View();
				EventPropertyData.setWindow(args[1].value,newWindow);
				View(newWindow).sourcePath=args[2].value;
			}
			if(!newWindow)
				return;
			EventPropertyData.setWindow(args[1].value,newWindow);
			_view.addChild(newWindow);
			var varObj:Object=new Object();
			if(args[6])//起始位置
			{
//				var p:Point=EventPropertyData.getPosition(args[6].value,newWindow,args[8]==null?1:args[8].value);
				var p:Point=EventPropertyData.getPosition(args[6].value,newWindow);
				newWindow.x=p.x;
				newWindow.y=p.y;
				p=EventPropertyData.getCenterPosition(newWindow,args[8]==null?1:args[8].value);// 计算居中显示的坐标
				varObj["x"]=p.x;
				varObj["y"]=p.y;
			}
			// 速度
//			if(args[4].value)
			{
				var classNameStr:String="tweenLite.easeing."+args[4].value as String;
				var ClassReference:Class = getDefinitionByName(classNameStr) as Class;
				varObj["ease"]=ClassReference[args[5].value];
			}
			if(args[7])// 透明度
			{
				varObj["alpha"]=args[7].value;
			}
			if(args[8])// 缩放
			{
				varObj["scaleX"]=varObj["scaleY"]=args[8].value;
			}
			varObj["onComplete"]=function overfun():void
			{
				TweenLite.killTweensOf(newWindow);	
			};
			TweenLite.to(newWindow,Number(args[3].value),varObj);
		}

//		[Function(eventTarget="Object",funName="关闭",targetID="组件ID或别名|String",duration="效果时长|Number",
//				effectKind="效果类型|EventProperty",speed="速度|EventProperty",
//				finishPosition="结束位置|EventProperty",alpha="透明度|EventProperty",scale="缩放目标|EventProperty"
//		)]
		public static function closeFun(_view:View,args:Array):void
		{
			if(args[1]==null||args[2]==null||args[2].value==null||args[3]==null||args[4]==null||args[5]==null)
			{
				return;
			}
			if(!EventPropertyData.isOpen(args[1].value))
			{
				return;
			}
			var dispO:DisplayObject=EventPropertyData.getWindowById(args[1].value);
			var varObj:Object=new Object();
			if(args[5])//结束位置
			{
				if(dispO==null||dispO.parent==null)
					return;
				var p:Point=EventPropertyData.getPosition(args[5].value,dispO,args[7]==null?1:args[7].value);// 计算居中显示的坐标
				varObj["x"]=p.x;
				varObj["y"]=p.y;
			}
//			if(args[4])// 速度
			{
				var classNameStr:String="tweenLite.easeing."+args[3].value as String;
				var ClassReference:Class = getDefinitionByName(classNameStr) as Class;
				varObj["ease"]=ClassReference[args[4].value];
			}
			if(args[6])// 透明度
			{
				varObj["alpha"]=args[6].value;
			}
			if(args[7])// 缩放
			{
				varObj["scaleX"]=varObj["scaleY"]=args[7].value;
			}
			varObj["onComplete"]=function overfun():void
			{
				TweenLite.killTweensOf(dispO);	
				if(dispO.parent)
				{
					dispO.parent.removeChild(dispO);
					EventPropertyData.delWindowById(args[1].value);
				}
			};
			varObj["ease"]=Back.easeOut;
			TweenLite.to(dispO,Number(args[2].value),varObj);
		}
	}
}