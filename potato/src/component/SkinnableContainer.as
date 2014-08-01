package potato.component
{
	import core.display.DisplayObject;
	import core.display.DisplayObjectContainer;

	/**
	 * 三层容器 
	 * @author liuxin
	 * 
	 */
	public class SkinnableContainer extends Container
	{
		public function SkinnableContainer(width:Number=NaN, height:Number=NaN)
		{
			createChildren();
			super(width,height);
		}
		
		//----------------------
		// property
		//----------------------
		/**
		 * 内容 
		 */
		protected var _content:DisplayObjectContainer;
		public function get content():DisplayObjectContainer{
			return _content;
		}
		/**
		 * 背景 
		 */
		protected var _background:DisplayObjectContainer;
		public function get background():DisplayObjectContainer{
			return _background;
		}
		/**
		 * 前景 
		 */
		protected var _front:DisplayObjectContainer;
		public function get front():DisplayObjectContainer{
			return _front;
		}
		
		protected function createChildren():void{
			_background=new DisplayObjectContainer();
			super.addChild(_background);
			_content=new DisplayObjectContainer();
			super.addChild(_content);
			_front=new DisplayObjectContainer();
			super.addChild(_front);
		}
		
		
		
		//-------------------------
		// DisplayObjectContainer
		//-------------------------
		
		override public function addChild(child:DisplayObject):DisplayObject{
			return _content.addChild(child);
		}		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject{
			return _content.addChildAt(child,index);
		}
		override public function removeChild(child:DisplayObject):DisplayObject{
			return _content.removeChild(child);
		}
		override public function removeChildAt(index:int):DisplayObject{
			return _content.removeChildAt(index);
		}
		override public function get numChildren():int{
			return _content.numChildren;
		}
		override public function getChildAt(index:int):DisplayObject{
			return _content.getChildAt(index);
		}
		override public function getChildIndex(child:DisplayObject):int{
			return _content.getChildIndex(child);
		}
		override public function setChildIndex(child:DisplayObject, index:int):void{
			return _content.setChildIndex(child,index);
		}
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void{
			return _content.swapChildren(child1,child2);
		}
		override public function swapChildrenAt(index1:int, index2:int):void{
			return _content.swapChildrenAt(index1,index2);
		}
		
		
		override public function dispose():void{
			super.dispose();
			
		}
	}
}