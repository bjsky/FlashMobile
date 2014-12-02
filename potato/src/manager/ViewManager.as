package potato.manager
{
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import core.display.DisplayObject;
	import core.display.DisplayObjectContainer;
	import core.display.Image;
	import core.display.Texture;
	import core.events.Event;
	import core.filesystem.File;
	import core.filters.BorderFilter;
	import core.filters.ColorMatrixFilter;
	import core.filters.ConvolutionFilter;
	import core.filters.Filter;
	import core.filters.ShadowFilter;
	import core.text.TextField;
	
	import potato.component.Bitmap;
	import potato.component.BorderContainer;
	import potato.component.Button;
	import potato.component.Container;
	import potato.component.List;
	import potato.component.ScrollableContainer;
	import potato.component.Scroller;
	import potato.component.Slider;
	import potato.component.Text;
	import potato.component.TextInput;
	import potato.component.View;
	import potato.component.action.EventAction;
	import potato.component.data.ActionData;
	import potato.component.data.BitmapSkin;
	import potato.component.data.Padding;
	import potato.component.data.SpriteData;
	import potato.component.data.TextFormat;
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
		 * 注册序列化类 
		 * 
		 */
		static public function registerAlias():void{
			BitmapSkin.registerAlias();
			Padding.registerAlias();
			SpriteData.registerAlias();
			ActionData.registerAlias();
			TextFormat.registerAlias();
			
			registerClassAlias("core.filters.Filter",Filter);
			registerClassAlias("core.filters.ColorMatrixFilter",ColorMatrixFilter);
			registerClassAlias("core.filters.ShadowFilter",ShadowFilter);
			registerClassAlias("core.filters.ConvolutionFilter",ConvolutionFilter);
			registerClassAlias("core.filters.BorderFilter",BorderFilter);
			//sprite
			Bitmap;BorderContainer;Button;Container;List;ScrollableContainer;Scroller;Slider;Text;TextInput;
		}
		

		/**
		 * 加载视图数据 
		 * @param data 精灵数据
		 * @param view 视图
		 * @return 
		 * 
		 */
		static public function loadView(data:SpriteData,view:View=null):View{
			
			//图集
			addAtlases(data);
			return  cascadeSprite(data,null,view,null,true) as View;
		}
		
		/**
		 * 加载精灵数据
		 * @param data 精灵数据
		 * @param sprite 精灵
		 * @return 
		 * 
		 */
		static public function loadSprite(data:SpriteData,sprite:DisplayObject=null):DisplayObject{
			return cascadeSprite(data,null,sprite);
			
		}
		
		/**
		 * 创建精灵对象
		 * @param data 精灵数据
		 * @return 
		 * 
		 */
		static public function createSprite(data:SpriteData):DisplayObject{
			//图集
			addAtlases(data);
			return cascadeSprite(data);
		}
		
		
		
		/**
		 * 获取视图上指定id的精灵 
		 * @param view
		 * @param id
		 * @return 
		 * 
		 */
		static public function getSprite(view:View,id:String):DisplayObject{
			return view.getSprite(id);
		}
		
//		static private var _callBack:Function;
		/**
		 * 添加资源图集 
		 * @param data 精灵数据
		 * @return 图集名
		 * 
		 */
		static public function addAtlases(data:SpriteData):void{
			if(data.assetsUrl && File.exists(data.assetsUrl)){
				var assetsName:String=data.configUrl.substr(data.assetsUrl.lastIndexOf("/")+1);
				assetsName=assetsName.substr(0,assetsName.indexOf("."));
//				ResourceManager.addAtlases(assetsName,data.assetsUrl,data.configUrl);
				
//				var configName:String=assetsName+".txt";
//				var configStr:String=("id	path	atlas	cache	type	type1	type2\n"+assetsName+"	/"+data.assetsUrl+"	/"+data.configUrl+"	0	1	1	7");
//				File.write(Utils.getDefaultPath(configName),configStr);
				var res:Res=new Res();
//				_callBack=callback;
//				res.addEventListener(HttpEvent.RES_LOAD_COMPLETE,onComplete);
//				res.appendCfg(configName,false);
				res.appendCfgBean(assetsName,data.assetsUrl,data.configUrl,0,1,1,7);
			}
		}
		
//		static private function onComplete(e:HttpEvent):void
//		{
//			// TODO Auto Generated method stub
//			if(_callBack){
//				_callBack();
//				_callBack=null;
//			}
//		}
		
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
		static public function cascadeSprite(data:SpriteData,pSprite:DisplayObject=null,sprite:DisplayObject=null,root:View=null,isLoad:Boolean=false):DisplayObject{
			if(!sprite && data){		//不存在创建sprite
				var cls:Class;
				try{
					cls=(data.runtime && data.runtime!="")? 
						getDefinition(data.runtime) as Class
					:getDefinition(data.type) as Class;
				}catch(err:Error){
					cls=getDefinition(data.type) as Class;
				}
				if(cls){
					if(data.type=="core.display.Image"){
						sprite= new cls(null) ;
					}else{
						sprite= new cls() ;
					}
				}
			}
			if(sprite){
				//初始化根视图引用
				if(root==null && sprite is View)
					root=sprite as View;
				//级联创建子
				for each(var child:SpriteData in data.children){	
					if(isLoad && sprite is View){		//view 放入背景层
						cascadeSprite(child,View(sprite).background,null,root);
					}else
						cascadeSprite(child,sprite,null,root);
				}
				//属性赋值
				for (var prop:String in data.properties){
					var value:*=data.properties[prop];	//view 只处理源路径
					if(sprite is View && (isLoad || prop=="spriteMap"))
						continue;
					try{
//						if(sprite.hasOwnProperty("$"+prop))
//							sprite["$"+prop]=value;
//						else
							sprite[prop]=value;
					}catch(e:Error){
						//TODO: Bitmap[texture]
						//		will be missing;
					}
				}
				if(data.type=="core.text.TextField"){
					TextField(sprite).setSize(data.properties["width"],data.properties["height"]);
				}
				if(data.type=="core.display.Image"){
					var skin:BitmapSkin=data.properties["texture"];		//为Image应用皮肤
					if(skin){
						if(skin.textureData){
							Image(sprite).texture=new Texture(skin.textureData);
						}else if(skin.textureName){
							Image(sprite).texture=Res.getTexture(skin.textureName);
						}
					}
					
				}
				//加入显示列表
				if(pSprite && sprite is DisplayObject  &&  pSprite is DisplayObjectContainer)
					DisplayObjectContainer(pSprite).addChild(DisplayObject(sprite));
//				//渲染
//				if(sprite is ISprite){
//					ISprite(sprite).render();
//				}
					
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