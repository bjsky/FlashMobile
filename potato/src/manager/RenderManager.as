package potato.manager
{
	import flash.utils.Dictionary;
	
	import core.display.Stage;
	import core.events.Event;
	
	import potato.potato_internal;
	import potato.component.interf.ISprite;
	import potato.editor.layout.LayoutElement;
	import potato.event.PotatoEvent;

	/**
	 * 渲染管理器. 
	 * @author liuxin
	 * 
	 */
	public class RenderManager
	{
		public function RenderManager()
		{
		}
		use namespace potato_internal;
		private static var _invalidated:Boolean=false;
		
		/**
		 * 延迟渲染
		 */		
		public static const CALLLATER:uint=0;
		/**
		 * 立即渲染
		 */
		public static const IMMEDIATELY:uint=1;
		/**
		 * 手动渲染
		 */
		public static const NONE:uint=2;
		
		private static function invalidate():void {
			if(!_invalidated){
				_invalidated=true;
				Stage.getStage().addEventListener(Event.ENTER_FRAME,onValidate);
			}
		}
		
		private static function onValidate(e:Event):void {
			_invalidated=false;
			Stage.getStage().removeEventListener(Event.ENTER_FRAME, onValidate);
//			trace("_______render")
			//验证布局
			LayoutManager.update();
			//执行
//			for (var method:Object in _methods) {
//				exeCallLater(method as Function);
//			}
//			var i:int=0;
			for each(var _target:Object in _targets){
//				i++;
				for (var method:Object in _target){
					var args:Array = _target[method];
					delete _target[method];
					method.apply(null, args);
				}
			}
//			trace(i);
//			trace(System.privateMemory);
			Stage.getStage().dispatchEvent(new PotatoEvent(PotatoEvent.RENDER));
		}
		
		/**
		 * 立即验证组件 
		 * 
		 */
		public static function validateNow(sprite:ISprite):void{
			if(sprite.validateMode == IMMEDIATELY || sprite.validateMode == NONE){
				if(_targets[sprite]){
					var _target:Object=_targets[sprite];
					for (var method:Object in _target){
						var args:Array = _target[method];
						delete _target[method];
						if(sprite.validateMode == IMMEDIATELY)
							method.apply(null, args);
					}
					delete _targets[sprite];
				}
			}
		}
		
//		private var _methods:Dictionary = new Dictionary();
		private static var _targets:Dictionary = new Dictionary();
		
		/**
		 * 组件失效 
		 * @param target
		 * @param method
		 * @param args
		 * 
		 */
		public static function invalidateProperty(sprite:ISprite,method:Function,args:Array = null):void{
			//布局
			invalidateLayout(sprite);
			
			//组件延迟策略
			if(sprite.validateMode == CALLLATER){
				callLater(sprite,method,args);
			}else if(sprite.validateMode == IMMEDIATELY){
				method.apply(null,args);
			}
		}
		
		/**
		 * 布局失效 
		 * @param target
		 * 
		 */
		public static function invalidateLayout(target:ISprite):void{
			var layout:LayoutElement=LayoutManager.getElement(ISprite(target));
			if(layout)	//布局失效
				layout.invalidate();
		}
		
		
		/**
		 * 延迟调用方法 
		 * @param target
		 * @param method
		 * @param args
		 * 
		 */
		potato_internal static function callLater(target:Object,method:Function,args:Array=null):void{
			var _methods:Dictionary;
			if(_targets[target])
				_methods=_targets[target];
			else{
				_methods=new Dictionary();
				_targets[target]=_methods;
			}
			
			if (_methods[method] == null) {
				_methods[method] = args || [];
				invalidate();
			}
		}
		
		/**
		 * 清理组件引用 
		 * @param target
		 * 
		 */
		public static function dispose(target:Object):void{
			if(_targets[target]){
				for (var method:Object in _targets[target]){
					delete _targets[target][method];
				}
				delete _targets[target];
				target=null;
			}
		}
		
		private static function get count():Number{
			var i:Number=0;
			for (var key:* in _targets){
				i++;
			}
			return i;
		}
	}
}