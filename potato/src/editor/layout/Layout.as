package potato.editor.layout
{
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	
	import potato.potato_internal;
	import potato.component.interf.ISprite;

	/**
	 * 布局容器.
	 * <p>布局容器是可以管理布局元素的容器元件，通过add、remove方法管理布局元素。布局元素没有先后顺序，通过getElement可以获取子组件的布局元素</p>
	 * @author liuxin
	 * 
	 */
	public class Layout extends LayoutElement
	{
		use namespace potato_internal;

		/**
		 *  
		 * @param ui 被布局的uicomponent对象
		 * 
		 */
		public function Layout(ui:ISprite)
		{
			super(ui);
		}
		static public function registerAlias():void{
			registerClassAlias("potato.layout.Layout",Layout);
		}

		override public function set ui(value:ISprite):void
		{
			super.ui=value;
		}
		
		protected var _childrenMap:Dictionary=new Dictionary();
		protected var _childrenElements:Vector.<LayoutElement>=new Vector.<LayoutElement>();
		
		
		/**
		 * 添加一个ui或布局元素
		 * @param obj	添加的ui或布局元素
		 * @return 该ui的布局元素或添加的布局元素
		 * 
		 */
		public function add(obj:Object):LayoutElement{
			var el:LayoutElement;
			var ui:ISprite;
			if(obj is ISprite){
				ui=ISprite(obj);
				
				el = new LayoutElement(ui,this);
				//有先移除
				if(_childrenMap[ui]){
					_childrenElements.splice(_childrenElements.indexOf(_childrenMap[ui]),1,el);
				}else{
					_childrenMap[ui] = el;
					_childrenElements.push(el);
				}
				return el;
			}else if(obj is LayoutElement){
				el=LayoutElement(obj);
				
				//有先移除
				if (_childrenMap[el.ui]){
					_childrenElements.splice(_childrenElements.indexOf(_childrenMap[el.ui]),1,el);
				}else{
					el.belong=this;
					_childrenMap[el.ui] = el;
					_childrenElements.push(el);
				}
				return el;
			}else
				return null;
		}
		
		/**
		 * 移除一个ui或布局元素
		 * @param obj 移除的ui或布局元素
		 * 
		 */
		public function remove(obj:Object):void {
			var ui:ISprite;
			var el:LayoutElement;
			if(obj is ISprite){
				ui=ISprite(obj);
				el=_childrenMap[ui];
				
			}else if(obj is LayoutElement){
				ui=LayoutElement(obj).ui;
				el=_childrenMap[ui];
			}
			
			if (el) {
				var i:Number = 0;
				var l:Number = _childrenElements.length;
				for (i; i<l; ++i) {
					if (_childrenElements[i] == el) {
						_childrenElements.splice(i, 1);
						break;
					}
				}
				el.dispose();
				el = null;
				delete _childrenMap[ui];
			}
		}
		
		/**
		 * 获取ui的布局元素
		 * @param ui uicomponent
		 * @return elementUI
		 * 
		 */
		public function getElement(obj:Object):LayoutElement {
			var ui:ISprite;
			if(obj is ISprite){
				ui=ISprite(obj);
				return _childrenMap[ui];
			}else
				return null;
			
		}
		
		override public function dispose():void{
			super.dispose();
			for each(var children:LayoutElement in _childrenElements){
				children.dispose();
			}
			this._childrenMap==new Dictionary();
			this._childrenElements=new Vector.<LayoutElement>();
		}
	}
}