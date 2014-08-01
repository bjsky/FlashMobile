package potato.editor.layout
{
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	
	import potato.component.ISprite;

	/**
	 * 布局
	 * @author liuxin
	 * 
	 */
	public class Layout extends LayoutElement
	{
		/**
		 *  
		 * @param ui 被布局的uicomponent对象
		 * @param width 	设定的布局宽
		 * @param height	设定的布局高
		 * 
		 */
		public function Layout(ui:ISprite)
		{
			super(ui);
		}
		static public function registerAlias():void{
			registerClassAlias("potato.layout.Layout",Layout);
		}
//		static public function create(ui:ISprite,belong:Layout=null):Layout{
//			var l:Layout=new Layout();
//			l.ui=ui;
//			return l;
//		}
//		
		override public function set ui(value:ISprite):void
		{
			super.ui=value;
		}
		
		protected var _childrenDic:Dictionary=new Dictionary();
		protected var _childrenElements:Vector.<LayoutElement>=new Vector.<LayoutElement>();
		
		/**
		 * 子ui字典 （）
		 */
		public function set childrenDic(value:Dictionary):void{
			_childrenDic=value;	
		}
		public function get childrenDic():Dictionary{
			return _childrenDic;
		}
		/**
		 * 子元素字典（元素或布局） 
		 */
		public function set childrenElements(elements:Vector.<LayoutElement>):void{
			_childrenElements=elements;
		}
		public function get childrenElements():Vector.<LayoutElement>{
			return _childrenElements;
		}
		
		/**
		 * 添加一个ui或布局（继承IlayoutElement接口） 
		 * @param obj	添加的ui或布局
		 * @return 布局
		 * 
		 */
		public function add(obj:Object):LayoutElement{
			var el:LayoutElement;
			var ui:ISprite;
			if(obj is ISprite){
				ui=ISprite(obj);
				
				el = new LayoutElement(ui,this);
				//有先移除
				if(_childrenDic[ui]){
					_childrenElements.splice(_childrenElements.indexOf(_childrenDic[ui]),1,el);
				}else{
					_childrenDic[ui] = el;
					_childrenElements.push(el);
				}
				return el;
			}else if(obj is LayoutElement){
				el=LayoutElement(obj);
				
				//有先移除
				if (_childrenDic[el.ui]){
					_childrenElements.splice(_childrenElements.indexOf(_childrenDic[el.ui]),1,el);
				}else{
					el.belong=this;
					_childrenDic[el.ui] = el;
					_childrenElements.push(el);
				}
				return el;
				
			}else
				return null;
		}
		
		/**
		 * 移除一个ui或布局
		 * @param obj 待移除的ui或布局
		 * 
		 */
		public function remove(obj:Object):void {
			var ui:ISprite;
			var el:LayoutElement;
			if(obj is ISprite){
				ui=ISprite(obj);
				el=_childrenDic[ui];
				
			}else if(obj is LayoutElement){
				ui=LayoutElement(obj).ui;
				el=_childrenDic[ui];
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
				delete _childrenDic[ui];
			}
		}
		
		/**
		 * 获取ui的布局
		 * @param ui uicomponent
		 * @return elementUI
		 * 
		 */
		public function getElement(obj:Object):LayoutElement {
			var ui:ISprite;
			if(obj is ISprite){
				ui=ISprite(obj);
				return _childrenDic[ui];
			}else
				return null;
			
		}
		
		override public function dispose():void{
			super.dispose();
			
			this._childrenDic==new Dictionary();
			this._childrenElements=new Vector.<LayoutElement>();
		}
	}
}