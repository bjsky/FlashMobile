package potato.manager
{
	import flash.net.registerClassAlias;
	import flash.utils.getDefinitionByName;
	
	import core.display.DisplayObject;
	import core.display.DisplayObjectContainer;
	import core.display.Image;
	import core.display.Texture;
	import core.filesystem.File;
	import core.filters.BorderFilter;
	import core.filters.ColorMatrixFilter;
	import core.filters.ConvolutionFilter;
	import core.filters.Filter;
	import core.filters.ShadowFilter;
	import core.text.TextField;
	
	import potato.component.Bitmap;
	import potato.component.Button;
	import potato.component.ISprite;
	import potato.component.Text;
	import potato.component.View;
	import potato.component.data.BitmapSkin;
	import potato.component.data.Padding;
	import potato.component.data.SpriteData;
	import potato.component.data.TextFormat;
	import potato.resource.ResourceManager;

	

	/**
	 * ui管理器，读写ui对象，装配显示列表等 
	 * @author liuxin
	 * 
	 */
	public class ViewManager
	{
		public function ViewManager()
		{
		}
		
		static public function registerAlias():void{
			BitmapSkin.registerAlias();
			Padding.registerAlias();
			SpriteData.registerAlias();
			TextFormat.registerAlias();
			
			registerClassAlias("core.filters.Filter",Filter);
			registerClassAlias("core.filters.ColorMatrixFilter",ColorMatrixFilter);
			registerClassAlias("core.filters.ShadowFilter",ShadowFilter);
			registerClassAlias("core.filters.ConvolutionFilter",ConvolutionFilter);
			registerClassAlias("core.filters.BorderFilter",BorderFilter);
			
			//sprite
			Bitmap;Text;Button;
		}
		
		/**
		 * 为视图加载精灵数据文件 
		 * @param view	视图
		 * @param filePath	 精灵数据文件
		 * 
		 */
		static public function loadView(view:View,filePath:String):void{
			var data:Object=Object(File.readByteArray(filePath).readObject());
			loadSpriteData(view,data as SpriteData);
		}
		
		/**
		 * 为视图加载精灵数据 
		 * @param view	视图
		 * @param filePath	 精灵数据
		 * 
		 */
		static public function loadSpriteData(view:View,data:SpriteData):void{
			ResourceManager.addAtlases(data.assetsPath,data.assetsName+".xml",data.assetsName);
			for (var prop:String in data.properties){
				var value:*=data.properties[prop];
				view[prop]=value;
			}
			for each(var child:SpriteData in data.children){
				createSprite(view,child,data.assetsName,view);
			}
		
			view.render();
		}
		
		static public function loadAvatarSpriteData(avatarSprite:DisplayObject,data:SpriteData):void{
			for (var prop:String in data.properties){
				if(prop!="x" && prop!="y"){	//不要位置信息
					var value:*=data.properties[prop];
					avatarSprite[prop]=value;
				}
			}
			for each(var child:SpriteData in data.children){
				createAvatarSprite(avatarSprite,child);
			}
			if(avatarSprite is ISprite)
				ISprite(avatarSprite).render();
		}
		
		/**
		 * 从精灵数据获取视图 
		 * @param filePath
		 * @return 
		 * 
		 */
		static public function getView(filePath:String):View{
			var view:View=new View();
			view.sourceFilePath=filePath;
			return view;
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
	
		/**
		 * 级联创建精灵对象 
		 * @param pSprite	父精灵对象
		 * @param data	精灵数据
		 * @param root	根视图对象
		 * 
		 */
		static private function createSprite(pSprite:DisplayObject,data:SpriteData,assetsDic:String,root:View):DisplayObject{
			var cls:Class=Class(getDefinitionByName(data.type));
			if(cls){
				var sprite:DisplayObject
				if(data.type=="core.display.Image"){
					sprite= new cls(null) ;
				}else{
					sprite= new cls() ;
				}
				
				//级联创建子
				for each(var child:SpriteData in data.children){
					createSprite(sprite,child,assetsDic,root);
				}
				//属性赋值
				for (var prop:String in data.properties){
					var value:*=data.properties[prop];
					if(value is BitmapSkin){
						value.textureName=assetsDic+"::"+value.textureName;
					}
					try{
						if(sprite.hasOwnProperty("$"+prop))
								sprite["$"+prop]=value;
							else
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
					Image(sprite).texture=ResourceManager.getTextrue(assetsDic+"::"+data.properties["textureName"]);
				}
				//加入显示列表
				if(pSprite && sprite is DisplayObject  &&  pSprite is DisplayObjectContainer)
					DisplayObjectContainer(pSprite).addChild(DisplayObject(sprite));
				//渲染
				if(sprite is ISprite)
					ISprite(sprite).render();
				
				//视图精灵映射
				if(data.id){
					root.spriteMap[data.id]=sprite;
				}
				return sprite;
			}else
				return null;
		}
		
		static private function createAvatarSprite(pSprite:DisplayObject,data:SpriteData):DisplayObject{
			var cls:Class=Class(getDefinitionByName(data.type));
			if(cls){
				var sprite:DisplayObject
				if(data.type=="core.display.Image"){
					sprite= new cls(null) ;
				}else{
					sprite= new cls() ;
				}
				
				//级联创建子
				for each(var child:SpriteData in data.children){
					createAvatarSprite(sprite,child);
				}
				//属性赋值
				for (var prop:String in data.properties){
					var value:*=data.properties[prop];
					try{
						if(sprite.hasOwnProperty("$"+prop))
							sprite["$"+prop]=value;
						else
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
					sprite["texture"]=new Texture(data.imageTextureData);
				}
				//加入显示列表
				if(pSprite && sprite is DisplayObject  &&  pSprite is DisplayObjectContainer)
					DisplayObjectContainer(pSprite).addChild(DisplayObject(sprite));
				//渲染
				if(sprite is ISprite)
					ISprite(sprite).render();
				
				return sprite;
			}else
				return null;
		}
	}
}