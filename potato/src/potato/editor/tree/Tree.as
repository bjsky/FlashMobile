package potato.editor.tree
{
	import flash.utils.Dictionary;
	
	import core.display.DisplayObjectContainer;
	
	import potato.potato_internal;
	import potato.component.core.IRenderer;
	import potato.component.core.ISprite;
	import potato.component.core.RenderManager;
	import potato.component.core.RenderType;
	import potato.component.data.BitmapSkin;
	import potato.utils.SkinUtil;

	/**
	 * 树形结构
	 * @author EricXie
	 * 1、创建树形结构
	 * 2、更换Icon皮肤
	 * 3、更换背景皮肤
	 * 4、获取当前选中索引项和索引值 
	 * 5、添加内容到最后
	 * 6、删除索引项
	 */	
	public class Tree extends DisplayObjectContainer implements ISprite, IRenderer
	{
		use namespace potato_internal;
		/**
		 * Icon打开状态 
		 */			
		static public const NODE_OPEN:uint=1;			
		/**
		 *	Icon关闭状态 
		 */		
		static public const NODE_CLOSE:uint=0;

		//		列表数据		
		private var _dataSource:Object;
		//		选中项的索引值,如果是0的情况，初始赋值默认是0会跳出
		private var _selectIndex:int=-1;
		//		被选中项渲染器
		private var _selectedItem:TreeCellRenderer;
		//		皮肤字段
		private var _skins:String="";
		// 		渲染器背景皮肤
		private var _bgSkin:BitmapSkin;
		//		皮肤数组
		private var _skinsArr:Array=["",""];
		//		皮肤字典
		private var _skinsMap:Dictionary=new Dictionary();
		/**
		 * 顺序存放的所有 TreeCellRenderer 
		 */		  
		public var treeCellRendererList:Vector.<TreeCellRenderer>=new Vector.<TreeCellRenderer>();
		//		 存放起始渲染器的数据
		private var treeCellRendererArray:Array=[];
		//		xml数据
		private var xmlProvider:XML;
		//		存储解析后的渲染器属性数组	
		private var treeCellRendererVOArrayProvider:Array=[];
		//		内容渲染器
		private var _itemRender:Class;
		//	   最大深度	
		private var maxLevel:int;
		//	渲染器之间的间隙
		private var _gap:int=5;
		//		宽
		private var _width:Number;
		//		高
		private var _height:Number;
		//		缩放
		private var _scale:Number;
		//		条目宽度
		private var _itemWidth:Number;
		//		条目高度
		private var _itemHeight:Number;
		//		设置渲染项是否自动打开
		private var _autoOpenUp:Boolean;
		/**
		 * 树的索引总和
		 */
		public var itemSum:uint=0;
		
		/**
		 * 构造方法
		 * @param skins
		 * @param bgSkins
		 * @param dataSource
		 * @param itemRender
		 * @param width
		 */			
		public function Tree(skins:String,bgSkin:BitmapSkin,dataSource:Object=null,itemRender:Class=null,itemWidth:int=200,itemHeight:int=180,autoOpenUp:Boolean=true)
		{
			super();
			
			this.skins = skins;
			this.bgSkin = bgSkin;
			this.itemRender = itemRender;
			this.itemWidth = itemWidth;
			this.itemHeight = itemHeight;
			this.dataSource = dataSource;
			this.autoOpenUp = autoOpenUp;
			
			createChildren();
		}
		
		private var _renderType:uint=RenderType.CALLLATER;
		
		/**
		 * 渲染模式
		 * @return 
		 * 
		 */
		public function get renderType():uint
		{
			return _renderType;
		}
		
		public function set renderType(value:uint):void
		{
			_renderType = value;
			RenderManager.validateNow(this);
		}
		
		/**
		 * 组件失效
		 * @param method
		 * @param args
		 * 
		 */
		public function invalidate(method:Function, args:Array = null):void
		{
			RenderManager.invalidateProperty(this,method,args);
		}
		
		/**
		 * 验证
		 * 
		 */
		public function validate():void
		{
			render();
		}
		
		/**
		 *	被选中的项，包含TreeCellRendererVO，selected等数据可以调取 
		 * @return 
		 * 
		 */		
		public function get selectedItem():TreeCellRenderer
		{
			return _selectedItem;
		}

		public function set selectedItem(value:TreeCellRenderer):void
		{
			if(_selectedItem==value) return;
			_selectedItem = value;
			for(var i:uint=0;i<treeCellRendererList.length;i++){
				if(treeCellRendererList[i]==value){
					selectIndex=i;
				}
			}
		}
		
		/**
		 *	程视项背景皮肤 
		 * @return 
		 * 
		 */		
		public function get bgSkin():BitmapSkin
		{
			return _bgSkin;
		}

		public function set bgSkin(value:BitmapSkin):void
		{
			_bgSkin = value;
		}
		
		/**
		 *缩放 
		 * @return 
		 * 
		 */
		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void
		{
			_scale = value;
		}
		
		/**
		 *高 
		 * @param value
		 * 
		 */
		public function set height(value:Number):void
		{
			_height = value;
		}
		
		/**
		 *宽 
		 * @param value
		 * 
		 */
		public function set width(value:Number):void
		{
			_width = value;
		}
		
		/**
		 *侦听各项事件 
		 * 
		 */
		private function createChildren():void
		{
			this.addEventListener(TreeEvent.CLICK_NODE,clickNodeHandler);
			this.addEventListener(TreeEvent.SELECTED_ITEM,selectedItemHandler);
		}
		
		public function removeTreeEvent():void
		{
			this.removeEventListener(TreeEvent.CLICK_NODE,clickNodeHandler);
			this.removeEventListener(TreeEvent.SELECTED_ITEM,selectedItemHandler);
		}
		
		/**
		 *当选择一项时 
		 * @param evt
		 * 
		 */		
		private function selectedItemHandler(evt:TreeEvent):void
		{
			for(var i:uint=0;i<treeCellRendererList.length;i++){
				if(treeCellRendererList[i]==evt.item){
					treeCellRendererList[i].selectedItemBoolean=true;
					selectedItem=treeCellRendererList[i];
				}else{
					treeCellRendererList[i].selectedItemBoolean=false;
				}
			}
		}
		
		/**
		 *当操作展开或者关合一个树形结构时 
		 * @param evt
		 * 
		 */		
		private function clickNodeHandler(evt:TreeEvent):void
		{
			render();
		}
		
		/**
		 * 数据源 
		 * @param value
		 * 
		 */		
		public function set dataSource(value:Object):void
		{
			if(_dataSource==value) return;
			for(var k:uint;k<treeCellRendererList.length;k++){
				if(treeCellRendererList[k].parent==this){
					this.removeChild(treeCellRendererList[k]);
				}
				treeCellRendererList[k].dispose();
			}
			
			treeCellRendererArray.length=0;
			treeCellRendererList.length=0;
			if (value is XML) {
				xmlProvider = value as XML;
				resolveXMLData(value as XML);
				return ;
			}
			
			if (value is Array) {
				treeCellRendererVOArrayProvider = value as Array;
				resolveArrayData(value as Array);
				return ;
			}
		}
		
		public function get dataSource():Object
		{
			return _dataSource;
		}
		
		/**
		 *这里进行XMl转换为TreeCellRendererVO数组的操作
		 * @param dataXML
		 *
		 */
		protected function resolveXMLData(dataXML:XML):void {
			treeCellRendererVOArrayProvider = [];
			for each (var node:XML in dataXML.elements()) {
				treeCellRendererVOArrayProvider.push(splitXMLDataToVO(null, node));
			}
			resolveArrayData(treeCellRendererVOArrayProvider);
		}
		
		/**
		 *这里进行 TreeCellRendererVO数组转换为TreeCellRenderer的操作
		 * @param arrayTreeCellRendererVO Array<TreeCellRendererVO>
		 *
		 */
		protected function resolveArrayData(arrayTreeCellRendererVO:Array):void {
			treeCellRendererArray = [];
			treeCellRendererList.length=0;
			
			for each (var nodeVO:TreeCellRendererVO in arrayTreeCellRendererVO) {
				treeCellRendererArray.push(splitVOToRenderer(0, null, nodeVO));
			}
		}
		
		/**
		 *递归解析
		 * 将TreeCellRendererVo解析为TreeCellRenderer渲染项
		 * @param parentRenderer
		 * @param data
		 * @return
		 *
		 */
		protected function splitVOToRenderer(level:int, parentRenderer:TreeCellRenderer, data:TreeCellRendererVO,insertIndex:int=-1):TreeCellRenderer {
			var treeCellRenderer:TreeCellRenderer;
			if (_itemRender == null) {
				//treeCellRenderer = new TreeCellRenderer(skins,bgSkins,data.label,500);
				_itemRender = TreeCellRenderer;
			}
				
			treeCellRenderer = new _itemRender() as TreeCellRenderer;
			treeCellRenderer.iconSkins = this.skins;
			treeCellRenderer.bgSkin = this.bgSkin;
			treeCellRenderer.width = this.itemWidth;
			treeCellRenderer.height = this.itemHeight;
			treeCellRenderer.autoOpenUp = this.autoOpenUp;
			
			if (parentRenderer != null) {
				treeCellRenderer.parentNode = parentRenderer;
				if(insertIndex>=0){
					for(var i:uint=0;i<parentRenderer.childNodes.length;i++){
						if(parentRenderer.childNodes[i]==treeCellRendererList[insertIndex]){
							parentRenderer.childNodes.splice(insertIndex,0,treeCellRenderer)
						}
					}
				}
			}
			treeCellRenderer.level = level;
			
			if(insertIndex>=0){
				treeCellRendererList.splice(insertIndex,0,treeCellRenderer);
			}else{
				treeCellRendererList.push(treeCellRenderer);
			}
			
			if (data.hasChildNodes) {
				treeCellRenderer.childNodes.length=0;
				++level;
				maxLevel = level;
				
				for each (var nodeVO:TreeCellRendererVO in data.childNodes) {
					treeCellRenderer.childNodes.push(splitVOToRenderer(level, treeCellRenderer,
						nodeVO));
				}
			}
			treeCellRenderer.data = data;
			return treeCellRenderer;
		}
		
		/**
		 *递归解析
		 * 将XML解析为Array数组
		 * @param parentVo
		 * @param data
		 * @return
		 *
		 */
		protected function splitXMLDataToVO(parentVo:TreeCellRendererVO, data:XML):TreeCellRendererVO {
			var treeCellRendererVO:TreeCellRendererVO = new TreeCellRendererVO();
			
			treeCellRendererVO.label = data.@label;
			
			//解析属性
			for each (var attribute:XML in data.attributes()) {
				var attriName:String = String(attribute.name());
				var attriValue:String = String(attribute.toString());
				
				if (attriName != "label") {
					treeCellRendererVO[attriName] = attriValue;
				}
			}
			
			if (parentVo != null) {
				treeCellRendererVO.parentNode = parentVo;
			}
			
			//判断是否有子节点
			if (data.elements().length() > 0) {
				//还有子节点
				treeCellRendererVO.childNodes = [];
				
				for each (var node:XML in data.elements()) {
					treeCellRendererVO.childNodes.push(this.splitXMLDataToVO(treeCellRendererVO,
						node));
				}
			}
			return treeCellRendererVO;
		}
		/**
		 * 选中项索引
		 * @param value
		 * 
		 */
		public function set selectIndex(value:int):void
		{
			if(_selectIndex==value) return;
			_selectIndex=value;
			for(var i:uint=0;i<treeCellRendererList.length;i++){
				if(i==_selectIndex){
					treeCellRendererList[i].selectedItemBoolean=true;
				}else{
					treeCellRendererList[i].selectedItemBoolean=false;
				}
			}
		}
		
		public function get selectIndex():int
		{
			return _selectIndex;
		}

		/**
		 * 皮肤字符串 [正常，按下，禁用，选中]
		 * @param value
		 * 
		 */
		public function set skins(value:String):void{
			_skins=value;	
			_skinsArr=SkinUtil.fillArray(_skinsArr,value,String);
			for (var i:int=0;i<_skinsArr.length;i++){
				var skinStr:String=_skinsArr[i];
				if(skinStr){
					_skinsMap[i]=new BitmapSkin(skinStr);
				}
			}
		}
		
		public function get skins():String{
			return _skins;
		}
		
		/**
		 * 打开节点Icon皮肤 
		 * @param value
		 * 
		 */
		public function set noteOpenSkin(value:BitmapSkin):void{
			_skinsMap[NODE_OPEN]=value;
		}
		
		public function get noteOpenSkin():BitmapSkin{
			return _skinsMap[NODE_OPEN];
		}
		
		/**
		 * 关闭节点Icon皮肤
		 * @param value
		 * 
		 */
		public function set noteCloseSkin(value:BitmapSkin):void{
			_skinsMap[NODE_CLOSE]=value;
		}
		
		public function get noteCloseSkin():BitmapSkin{
			return _skinsMap[NODE_CLOSE];
		}
		
		/**
		 *删除索引项 
		 * @param index
		 * @return 
		 * 
		 */		
		public function removeItemAt(index:uint):TreeCellRenderer
		{
			var deleteTreeCellRenderer:TreeCellRenderer=treeCellRendererList[index];
			treeCellRendererList.splice(index,1);
			if(deleteTreeCellRenderer.childNodes){
				for(var i:uint=0;i<treeCellRendererList.length;i++){
					if(treeCellRendererList[i].parentNode==deleteTreeCellRenderer && treeCellRendererList[i].stage){
						this.removeChild(treeCellRendererList[i]);
						treeCellRendererList.splice(i,1);
					}
				}
			}
			if(deleteTreeCellRenderer.stage){
				this.removeChild(deleteTreeCellRenderer);
			}
			
			render();
			return deleteTreeCellRenderer;
		}
		
		/**
		 *通过添加XML数据追加项 
		 * @param dataXML
		 * 
		 */		
		public function addXMLItem(dataXML:XML):void
		{
			treeCellRendererVOArrayProvider.length=0;
			treeCellRendererArray.length=0;
			for each (var node:XML in dataXML.elements()) {
				treeCellRendererVOArrayProvider.push(splitXMLDataToVO(null, node));
			}
			for each (var nodeVO:TreeCellRendererVO in treeCellRendererVOArrayProvider) {
				treeCellRendererArray.push(splitVOToRenderer(0, null, nodeVO));
			}
			render();
		}
		
		/**
		 *通过添加数组数据追加项 
		 * @param dataXML
		 * 
		 */		
		public function addArrayItem(dataArr:Vector.<TreeCellRendererVO>):void
		{
			treeCellRendererVOArrayProvider.length=0;
			treeCellRendererArray.length=0;
		
			for each (var nodeVO:TreeCellRendererVO in dataArr) {
				treeCellRendererArray.push(splitVOToRenderer(0, null, nodeVO));
			}
			render();
		}
		
		/**
		 * 给树里面插入一个元素 
		 * @param dataArr
		 * @param itemIndex
		 * 
		 */		
		public function insertArrayItemAt(dataArr:Vector.<TreeCellRendererVO>,itemIndex:int):void
		{
			treeCellRendererVOArrayProvider.length=0;
			treeCellRendererArray.length=0;
			
			for each (var nodeVO:TreeCellRendererVO in dataArr) {
				if(itemIndex>=0){
					if(treeCellRendererList[itemIndex].parentNode!=null){
						splitVOToRenderer(treeCellRendererList[1].level, treeCellRendererList[1].parentNode as TreeCellRenderer, nodeVO,itemIndex)
					}else{
						splitVOToRenderer(0, null, nodeVO)
					}
				}
			}
			render();
		}
	
		/**
		 *渲染 
		 * 
		 */			
		public function render():void
		{
			if(!skins) return;
			for(var k:uint;k<treeCellRendererList.length;k++){
				if(treeCellRendererList[k].parent==this){
					this.removeChild(treeCellRendererList[k]);
				}
			}
			
			var sum:uint=0;
			for(var i:uint=0;i<treeCellRendererList.length;i++){
				if(treeCellRendererList[i].shows){
					treeCellRendererList[i].width = itemWidth;
					treeCellRendererList[i].height = itemHeight;
					this.addChild(treeCellRendererList[i]);
					treeCellRendererList[i].y=(treeCellRendererList[i].height+_gap)*sum;
					sum++;
				}
			}
			
			itemSum=treeCellRendererList.length;
			if(treeCellRendererList.length>0){
				height=itemSum*(treeCellRendererList[0].height+_gap);
			}
		}
		
		override public function dispose():void{
			super.dispose();
			RenderManager.dispose(this);
		}
		
		/**
		 * 设置内容渲染器 
		 * @param value
		 */	
		public function set itemRender(value:*):void
		{
			_itemRender = value as Class;
			invalidate(render);
		}
		
		/**
		 * 内容渲染器 Class类型 
		 * @param value
		 */	
		public function get itemRender():*
		{
			return _itemRender;
		}

		public function get itemWidth():Number
		{
			return _itemWidth;
		}

		public function set itemWidth(value:Number):void
		{
			if (_itemWidth != value)
			{
				_itemWidth = value;
				invalidate(render);
			}
		}

		public function get itemHeight():Number
		{
			return _itemHeight;
		}

		public function set itemHeight(value:Number):void
		{
			if (_itemHeight != value)
			{
				_itemHeight = value;
				invalidate(render);
			}
		}

		/**
		 * 条目间隔 
		 * @return 
		 */		
		public function get gap():int
		{
			return _gap;
		}

		public function set gap(value:int):void
		{
			_gap = value;
			invalidate(render);
		}

		/**
		 * 是否自动展开 
		 * @return 
		 */		
		public function get autoOpenUp():Boolean
		{
			return _autoOpenUp;
		}

		public function set autoOpenUp(value:Boolean):void
		{
			_autoOpenUp = value;
			for(var i:uint=0;i<treeCellRendererList.length;i++){
				treeCellRendererList[i].autoOpenUp = _autoOpenUp;
			}
		}

		
	}
}