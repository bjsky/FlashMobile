package potato.component
{
	import flash.utils.Dictionary;
	
	import core.display.DisplayObject;
	import core.display.DisplayObjectContainer;
	import core.filesystem.File;
	
	import potato.component.data.SpriteData;
	import potato.component.interf.ISprite;
	import potato.manager.ViewManager;
	
	/**
	 * 视图.
	 * <p>视图是编辑器生成界面的基本单位。通过设置视图的编辑器数据或编辑器文件路径，可以自动创建该视图的界面。通过侦听UIEvent.VIEW_COMPLETE 事件处理视图加载完成</p>
	 * <p>视图的精灵映射中存储编辑器中所有命名的显示对象，可以通过getSprite()获取。</p>
	 * <p>在编辑器中使用自定义运行时类，创建继承自View的自定义类，可以扩展编辑器生成界面的功能，添加事件和逻辑代码。</p> 
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
		private var _sourcePath:String;
		private var _source:SpriteData;
		private var _spriteMap:Dictionary=new Dictionary();
		
		/**
		 * 精灵数据 
		 * @return 
		 * 
		 */
		public function loadSource(data:SpriteData):void
		{
			_source=data;
			while(background.numChildren>0){
				var child:DisplayObject=DisplayObjectContainer(background).removeChildAt(0);
				child.dispose();
				child=null;
			}
			ViewManager.loadView(_source,this);
		}
		
//		private function loadComplete():void{
//			ViewManager.cascadeSprite(_source,null,this,null,true);
//		}
		/**
		 * 精灵视图 
		 * @return 
		 * 
		 */
		public function get sourceSprite():DisplayObjectContainer
		{
			return background;
		}
		
		/**
		 * 精灵数据文件路径 
		 * @return 
		 * 
		 */		
		public function get sourcePath():String
		{
			return _sourcePath;
		}
		
		public function set sourcePath(value:String):void
		{
			if(_sourcePath!=value){
				_sourcePath = value;
				ViewManager.registerAlias();
				if(value)
					loadSource(SpriteData(File.readByteArray(_sourcePath).readObject()));
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
	}
}