package potato.component
{
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	
	import core.display.DisplayObject;
	import core.display.DisplayObjectContainer;
	import core.filesystem.File;
	import core.filters.BorderFilter;
	import core.filters.ColorMatrixFilter;
	import core.filters.ConvolutionFilter;
	import core.filters.Filter;
	import core.filters.ShadowFilter;
	
	import potato.component.core.ISprite;
	import potato.component.data.BitmapSkin;
	import potato.component.data.Padding;
	import potato.component.data.TextFormat;
	import potato.component.external.ActionData;
	import potato.component.external.SpriteData;
	import potato.component.external.ViewManager;
	import potato.res.Res;
	
	/**
	 * 视图.
	 * <p>视图是编辑器界面的加载容器，通过指定sourceName加载视图文件，通过getSprite()获取组件</p>
	 * <p>在编辑器中使用时，应该创建继承View的视图类，在init中初始化控件，绑定事件等</p> 
	 * @author liuxin
	 * 
	 */
	public class View extends BorderContainer
	{
		public function View()
		{
			super();
		}

		//--------------------------
		//	IView
		//--------------------------
		private var _source:SpriteData;
		private var _spriteMap:Dictionary=new Dictionary();
		private var _sourceName:String;

		public function get sourceName():String
		{
			return _sourceName;
		}

		public function set sourceName(value:String):void
		{
			if(_sourceName!=value)
			{
				_sourceName = value;
				if(_sourceName){
					registerAlias();
					var path:String=Res.getViewSourcePath(_sourceName);
					if(path)
						loadSourceSprite(SpriteData(File.readByteArray(path).readObject()));
				}
			}
			
		}

		/**
		 * 精灵数据 
		 * @return 
		 * 
		 */
		public function loadSourceSprite(data:SpriteData):void
		{
			clearLoadSprite();
			_source=data;
			ViewManager.cascadeSprite(_source,background,this);
		}
		
		/**
		 * 精灵视图 
		 * @return 
		 * 
		 */
		public function clearLoadSprite():void
		{
			_source=null;
			while(background.numChildren>0){
				var child:DisplayObject=DisplayObjectContainer(background).removeChildAt(0);
				child.dispose();
				child=null;
			}
		}

		/**
		 * 精灵映射 
		 * @param value
		 * 
		 */
		public function set spriteMap(value:Dictionary):void{
			_spriteMap=value;
		}
		public function get spriteMap():Dictionary{
			return _spriteMap;
		}
		
		/**
		 * 获取指定id的精灵 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getSprite(id:String):DisplayObject{
			return DisplayObject(spriteMap[id]);
		}
		
		/**
		 * 释放资源 
		 * 
		 */
		override public function dispose():void
		{
			super.dispose();
			clearLoadSprite();
			while(numChildren>0){
				this.removeChildAt(0);
			}
		}
		
		/**
		 * 获取测量宽度
		 * @return 
		 * 
		 */
		override public function get measureWidth():Number{
			var measured:Number=super.measureWidth;
			return Math.max(measured,cascadeWidth(background));
		}
		
		private function cascadeWidth(cont:DisplayObjectContainer):Number{
			if(cont is ISprite){
				return ISprite(cont).width;
			}else{
				var max:Number = 0;
				for (var i:int = cont.numChildren - 1; i > -1; i--) {
					var comp:DisplayObject = cont.getChildAt(i);
					if (comp.visible) {
						var w:Number=(comp is DisplayObjectContainer)?cascadeWidth(comp as DisplayObjectContainer):comp.width;
						max = Math.max(comp.x + w*comp.scaleX, max);
					}
				}
				return max;
			}
		}
		
		/**
		 * 获取测量高度
		 * @return 
		 * 
		 */
		override public function get measureHeight():Number{
			var measured:Number=super.measureHeight;
			return Math.max(measured,cascadeHeight(background));
		}
		
		private function cascadeHeight(cont:DisplayObjectContainer):Number{
			if(cont is ISprite){
				return ISprite(cont).height;
			}else{
				var max:Number = 0;
				for (var i:int = cont.numChildren - 1; i > -1; i--) {
					var comp:DisplayObject = cont.getChildAt(i);
					if (comp.visible) {
						var w:Number=(comp is DisplayObjectContainer)?cascadeHeight(comp as DisplayObjectContainer):comp.height;
						max = Math.max(comp.y + w*comp.scaleY, max);
					}
				}
				return max;
			}
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
			Bitmap;BorderContainer;Button;Container;List;ScrollContainer;Scroller;Slider;Text;TextInput;
		}
		

	}
}