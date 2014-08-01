package potato.component
{
	import flash.utils.Dictionary;
	
	import core.display.DisplayObject;
	import core.display.DisplayObjectContainer;
	import core.filesystem.File;
	
	import potato.component.data.SpriteData;
	import potato.manager.ViewManager;
	
	/**
	 * 视图 
	 * @author liuxin
	 * 
	 */
	public class View extends DisplayObjectContainer 
		implements ISprite
	{
		public function View()
		{
			super();
		}
		//----------------------------
		//	ISprite
		//----------------------------
		protected var _width:Number;
		protected var _height:Number;
		protected var _scale:Number;
		protected var _enable:Boolean=true;
		
		
		/**
		 * 宽度
		 * @param value
		 * 
		 */
		public function set width(value:Number):void{
			_width=value;
		}
		override public function get width():Number{
			return _width;
		}
		
		/**
		 * 高度 
		 * @param value
		 * 
		 */
		public function set height(value:Number):void{
			_height=value;
		}
		override public function get height():Number{
			return _height;
		}
		
		/**
		 * 缩放 
		 * @param value
		 * 
		 */
		public function set scale(value:Number):void{
			_scale=value;
			scaleX=scaleY=_scale;
		}
		public function get scale():Number{
			return _scale;
		}
		
		/**
		 * 可用性 
		 * @param value
		 * 
		 */
		public function set enable(value:Boolean):void{
			_enable=value;
		}
		public function get enable():Boolean{
			return _enable;
		}
		//--------------------------
		//	IView
		//--------------------------
		private var _sourceFilePath:String;
		private var _source:SpriteData;
		private var _spriteMap:Dictionary=new Dictionary();
		
		/**
		 * 精灵数据 文件
		 * @return 
		 * 
		 */
		public function get sourceFilePath():String
		{
			return _sourceFilePath;
		}
		
		public function set sourceFilePath(value:String):void
		{
			_sourceFilePath = value;
			if(_sourceFilePath && File.exists(_sourceFilePath)){
				ViewManager.loadView(this,_sourceFilePath);
			}
		}
		
		
		/**
		 * 精灵数据 
		 * @return 
		 * 
		 */
		public function get source():SpriteData
		{
			return _source;
		}
		
		public function set source(value:SpriteData):void
		{
			_source = value;
			ViewManager.loadSpriteData(this,value);
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
		
		override public function dispose():void
		{
			super.dispose();
			while(numChildren>0){
				this.removeChildAt(0);
			}
		}
		public function render():void
		{
		}
	}
}