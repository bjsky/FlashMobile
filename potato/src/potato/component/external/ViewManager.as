package potato.component.external
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import core.display.DisplayObject;
	import core.display.DisplayObjectContainer;
	import core.display.Image;
	import core.events.Event;
	import core.text.TextField;
	
	import potato.component.View;
	import potato.gesture.Gesture;
	import potato.res.Res;

	

	/**
	 * 视图管理器.
	 * <p>通过视图管理器获取、加载视图。加载的视图包含自定义运行时类时，需要注册运行时类</p> 
	 * @author liuxin
	 * 
	 */
	public class ViewManager
	{
		public function ViewManager()
		{
		}
		
		/**
		 * 运行时类映射 
		 */		
		static private var runtimeClassesMap:Dictionary=new Dictionary();
		
		/**
		 * 注册运行时类 
		 * @param name
		 * @param cls
		 * 
		 */
		static public function registerRuntimeClasses(name:String,cls:Class):void{
			runtimeClassesMap[name]=cls;
		}
		
		/**
		 *  
		 * @return 
		 * 
		 */
		private static function getDefinition(name:String):Class{
			if(runtimeClassesMap[name])
				return runtimeClassesMap[name];
			else
				return getDefinitionByName(name) as Class;
		}
		
		public static function getSprite(data:SpriteData):DisplayObject{
			if(data.type=="potato.component.View"){
				var retV:View=new View();
				retV.loadSourceSprite(data);
				return retV;
			}else{
				return cascadeSprite(data);
			}
		}
		
		
		/**
		 * 级联处理精灵数据 
		 * @param pSprite
		 * @param sprite
		 * @param data
		 * @param assetsDic
		 * @param root
		 * @return 
		 * 
		 */
		static public function cascadeSprite(data:SpriteData,pSprite:DisplayObjectContainer=null,root:View=null):DisplayObject{
			var sprite:DisplayObject;
			if(!sprite && data){		//不存在创建sprite
				var cls:Class;
				try{
					cls=(data.runtime && data.runtime!="")? 
						getDefinition(data.runtime) as Class
						:getDefinition(data.type) as Class;
				}catch(err:Error){
					cls=getDefinition(data.type) as Class;
				}
				//image特殊处理
				if(cls){
					if(data.type=="core.display.Image"){
						sprite= new cls(null) ;
					}else{
						sprite= new cls() ;
					}
				}
			}
			if(sprite){
				//级联创建子
				for each(var child:SpriteData in data.children){	
					cascadeSprite(child,sprite as DisplayObjectContainer,root);
				}
				
				//属性赋值
				for (var prop:String in data.properties){
					var value:* = data.properties[prop];	
					
//					try{
						sprite[prop]=value;
						
//					}catch(e:Error){
//						//TODO: Bitmap[texture]
//						//		will be missing;
//					}
				}
				if(data.type=="core.text.TextField"){
					TextField(sprite).setSize(data.properties["width"],data.properties["height"]);
				}
				if(data.type=="core.display.Image")
				{
					var id:String=data.properties["texture"];		//为Image取纹理
					Image(sprite).texture=Res.getTexture(id);
				}
				//加入显示列表
				if(pSprite && sprite is DisplayObject  &&  pSprite is DisplayObjectContainer)
					DisplayObjectContainer(pSprite).addChild(DisplayObject(sprite));
				
				//视图精灵映射
				if(root && data.id){
					root.spriteMap[data.id]=sprite;
				}
				//动作
				for each(var actionData:ActionData in data.actionList){
					if(actionData.eventName==""&&actionData.gestureName==""||actionData.typeName=="")
					{
						continue;
					}
					var eventCls:Class=getDefinitionByName(actionData.eventName) as Class;
					var action:EventAction=new EventAction();
					var arr:Array=[];
					for(var i:uint=0;i<actionData.argumentsArr.length;i++){
						if(i==0){
							if(!actionData.argumentsArr[1].value || actionData.argumentsArr[1].value=="this" || actionData.argumentsArr[1].value==""||actionData.argumentsArr[1].value=="null"){
								arr[0]=sprite;
							}else{
								arr[0]=String(actionData.argumentsArr[1]);
							}
						}else{
							arr[i]=actionData.argumentsArr[i];
						}
					}
					
					//					if(actionData.gestureName){	//手势
					if(actionData.gestureName&&actionData.gestureName!="原生"){	//手势
						var gestureCls:Class=getDefinitionByName(actionData.gestureName) as Class;
						var gesture:Gesture=new gestureCls(sprite);
						gesture.addEventListener(eventCls[actionData.typeName],eventListener(action,root,actionData.functionName,arr));
					}else{
						sprite.addEventListener(eventCls[actionData.typeName],eventListener(action,root,actionData.functionName,arr));
					}
				}
				
				return sprite;
			}
			return null;
		}
		
		private static function eventListener(_action:EventAction,_root:View,_functionName:String,_arr:Array):Function
		{
			var fun:Function=function(e:Event):void
				{
					_action.execute(_root,_functionName,_arr)
				};
			return fun;
		}		

	}
}