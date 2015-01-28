package potato.component.core
{
	import flash.utils.Dictionary;
	
	import core.display.Stage;
	import core.events.Event;
	
	import potato.potato_internal;

	/**
	 * 渲染管理器. 
	 * <p>支持三种验证模式：延迟（默认），立即，和手动验证。布局验证发生在属性验证之后</p>
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
//			LayoutManager.update();
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
			Stage.getStage().dispatchEvent(new RenderEvent(RenderEvent.RENDER));
		}
		
		/**
		 * 立即验证组件 
		 * 
		 */
		public static function validateNow(sprite:ISprite):void{
			if(sprite.renderType == RenderType.IMMEDIATELY || sprite.renderType == RenderType.NONE){
				if(_targets[sprite]){
					var _target:Object=_targets[sprite];
					for (var method:Object in _target){
						var args:Array = _target[method];
						delete _target[method];
						if(sprite.renderType == RenderType.IMMEDIATELY)
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
//			LayoutManager.invalidateLayout(sprite);
			
			//组件延迟策略
			if(sprite.renderType == RenderType.CALLLATER){
				callLater(sprite,method,args);
			}else if(sprite.renderType == RenderType.IMMEDIATELY){
				method.apply(null,args);
			}
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