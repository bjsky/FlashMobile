package potato.editor.fileBox
{
	import core.filesystem.File;
	import core.filesystem.FileInfo;
	
	import potato.component.ScrollContainer;
	import potato.component.data.BitmapSkin;
	import potato.editor.tree.Tree;
	import potato.editor.tree.TreeCellRenderer;
	import potato.editor.tree.TreeCellRendererVO;
	import potato.editor.tree.TreeEvent;
	import potato.utils.Utils;
	
	/**
	 * 资源管理器内左侧文件夹列表 
	 * @author wanghao
	 */	
	public class FolderTree extends ScrollContainer
	{
		private static const ITEM_WIDTH:int = 200;
		private static const ITEM_HEIGHT:int = 40;
		
		private var _tree:Tree; //盘符浏览组件
		private var _treeCellRendererVOArr:Array; //当前展示目录结构对应全部数据
		private var _rootPath:String; //当前根目录路径
		private var _openFolderPathArr:Vector.<String>; //记录所有处理展开状态的路径
		private var _selectPath:String; //当前选中路径
		private var _filterCNCharacters:Boolean; //是否过滤中文文件名
		
		public function FolderTree(width:Number, height:Number, filterCNCharacters=true, rootPath:String=FileBoxDefine.ROOT_PATH)
		{
			super(width, height);
			this.width = width;
			this.height = height;
			
			hScrollEnable = false;
			hScrollerVisible = false;
			
			//是否过滤中文文件名
			_filterCNCharacters = filterCNCharacters;
			
			//根目录
			_rootPath = rootPath;
			
			//获取盘符数据
			_treeCellRendererVOArr = getRootVOArr(_rootPath);
			
			//记录当前处于打开状态的目录路径
			_openFolderPathArr = new Vector.<String>();
			
			//初始化盘符列表
			_tree = new Tree("treeArrow_close,treeArrow_open", new BitmapSkin("input_0_up","4,4,4,4"), _treeCellRendererVOArr, FolderTreeCellRenderer, ITEM_WIDTH, ITEM_HEIGHT, false);
			_tree.dataSource = _treeCellRendererVOArr;
			_tree.gap = 0;
			_tree.addEventListener(TreeEvent.CLICK_NODE, clickNodeHandler);
			_tree.addEventListener(TreeEvent.SELECTED_ITEM, selectedItemHandler);
			addChild(_tree);
		}
		
		/**
		 * 根据路径逐层展开并选中路径对应文件夹 
		 * 调用这个方法会重构整个路径上的目录结构
		 * @param path
		 */		
		public function openFolderByPath(path:String):void
		{
			path = cutPath(path);
			if (!Utils.validFolder(path))
			{
				var event:FileEvent = new FileEvent(FileEvent.OPEN_ERROR);
				event.path = path;
				dispatchEvent(event);
				return;
			}
			if (path == _selectPath) return;
			
			var i:uint;
			var node:TreeCellRenderer;

			var splitPath:Array = path.split(FileBoxDefine.DIRECTORY_SEPATRATOR);
			for (i = 0; i < splitPath.length; i++)
			{
				var subPath:String = splitPath.slice(0, i+1).join(FileBoxDefine.DIRECTORY_SEPATRATOR);
				//过滤根目录之前的目录结构
				if (!contains(subPath)) continue;
				//逐级加入打开列表
				if (_openFolderPathArr.indexOf(subPath) == -1)
				{
					_openFolderPathArr.push(subPath);
				}
				
				node = searchNodeByPath(subPath);
				//之前没有存储相应的目录结构
				if (node == null)
				{
					var lastIndex:int = subPath.lastIndexOf(FileBoxDefine.DIRECTORY_SEPATRATOR);
					var parentPath:String = (lastIndex > -1) ? subPath.substr(0, lastIndex) : subPath;
					var parentNode:TreeCellRenderer = searchNodeByPath(parentPath);
					//使用上级目录扩展
					expandChildNodes(parentNode, false);
				}
				else
				{
					//对当前目录进行扩展
					expandChildNodes(node, false);
				}
			}
			
			//恢复之前记录的展开 条目
			for (i = 0; i < _openFolderPathArr.length; i++)
			{
				var openPath:String = _openFolderPathArr[i];
				node = searchNodeByPath(openPath);
				
				//之前没有存储相应的目录结构
				if (node != null)
				{
					expandChildNodes(node, false);
				}
			}
			
			_selectPath = path;
			folderOpenOrClose();
			updateScrollY();
		}
		
		/**
		 * 检测当前路径是否为
		 * @param path
		 * @return 
		 */		
		private function contains(path:String):Boolean
		{
			if (_rootPath == FileBoxDefine.ROOT_PATH)
				return true;
			return path.indexOf(_rootPath) == 0;
		}
		
		/**
		 * 处理给入路径带有文件名的情况 ,将文件名截掉,只保留路径部分信息
		 * @param path
		 * @return 
		 */		
		private function cutPath(path:String):String
		{
			if (path == null) path = "";
			path = FileBoxGlobalFunction.clearPath(path);//清理
			path = path.replace(FileBoxDefine.REPLACE_REG, FileBoxDefine.DIRECTORY_SEPATRATOR);// 替换
			path = FileBoxGlobalFunction.clearLastSepatrator(path);
			if (path.indexOf(".") != -1)
			{
				var lIndex:int = path.lastIndexOf(FileBoxDefine.DIRECTORY_SEPATRATOR);
				if(lIndex > -1)
				{
					path = path.substr(0, lIndex);// 纯路径
				}
			}
			return path;
		}
		
		/**
		 * 选中条目时间处理 
		 * 
		 */		
		private function selectedItemHandler(evt:TreeEvent):void
		{
			selectedFolder(evt.item);
		}
		
		/**
		 * 点击开关事件处理 
		 * @param evt
		 */		
		private function clickNodeHandler(evt:TreeEvent):void
		{
			var node:TreeCellRenderer = evt.item;
			if (!node.selected)
			{
				expandChildNodes(node, true);
			}
			else
			{
				packUpChildNodes(node, true);
			}
		}
		
		/**
		 * 展开目录
		 * 展开目录时修改数据源,根据当前展开路径获取子目录文件系统信息,并插入至全局数据之中.
		 * 并使用修改过的数据对视图进行渲染
		 * @param treeCellRendererVO
		 */		
		private function expandChildNodes(currentCellRenderer:TreeCellRenderer, refreshView:Boolean=false):void
		{
			var currentNodeVO:TreeCellRendererVO = currentCellRenderer.treeCellRendererVO;
			var fileInfoArr:Array;
			try
			{
				if (currentNodeVO.parentNode == null && currentNodeVO.data.path == "")
					fileInfoArr = getFileInfoByLetters(Utils.getExistsLetters());
				else
					fileInfoArr = File.getDirectoryListing(currentNodeVO.data.path);
			}
			catch(e:Error)
			{
				if(e.errorID == 3003)
				{
					var evt:FileEvent = new FileEvent(FileEvent.OPEN_ERROR);
					evt.path = currentNodeVO.data.path;
					dispatchEvent(evt);
				}
			}
			if (fileInfoArr.length)
			{
				fileInfoArr.sortOn(["isDirectory","name"],[Array.NUMERIC|Array.DESCENDING,Array.CASEINSENSITIVE]);
				currentNodeVO.childNodes = new Array();
				//抓取目录子项,插入至当前条目下面
				for each (var fileInfo:FileInfo in fileInfoArr)
				{
					//删选数据过程中只显示目录,并过滤 ".",".."
					if (fileInfo.isDirectory && fileInfo.name != "." && fileInfo.name != "..")
					{
						if (_filterCNCharacters && FileBoxGlobalFunction.hasCNCharacters(fileInfo.name))
							continue;
						
						var rendererVO:TreeCellRendererVO = new TreeCellRendererVO();
						
						var itemData:FileBoxItemData = new FileBoxItemData();
						itemData.name = fileInfo.name;
						itemData.isDirectory = fileInfo.isDirectory;
						itemData.path = currentNodeVO.data.path ? currentNodeVO.data.path + FileBoxDefine.DIRECTORY_SEPATRATOR + fileInfo.name : fileInfo.name;
						
						rendererVO.label = fileInfo.name;
						rendererVO.data = itemData;
						rendererVO.parentNode = currentNodeVO;
						currentNodeVO.childNodes.push(rendererVO);
					}
				}
				
				_tree.dataSource = _treeCellRendererVOArr;
				//暂时没有找到更好的测量高度的办法,所以这里多处理了一次render
				_tree.render();
				contentHeight = _tree.itemSum*(ITEM_HEIGHT+_tree.gap);
				
				//记录打开当前打开目录路径
				if (_openFolderPathArr.indexOf(currentNodeVO.data.path) == -1)
				{
					_openFolderPathArr.push(currentNodeVO.data.path);
				}
				if (refreshView)
				{
					folderOpenOrClose();
				}
			}
		}
		
		/**
		 * 收起目录 
		 * @param treeCellRenderer
		 */		
		private function packUpChildNodes(treeCellRenderer:TreeCellRenderer, refreshView:Boolean=false):void
		{
			var currentNodeVO:TreeCellRendererVO = treeCellRenderer.treeCellRendererVO;
			currentNodeVO.childNodes = null;
			
			//清理之前记录的目录打开状态
			var currPath:String = currentNodeVO.data.path;
			var tempPathArr:Array = [];
			for each (var path:String in _openFolderPathArr)
			{
				//清理当前目录和子目录
				if (path.indexOf(currPath) == 0)
					tempPathArr.push(path);
			}
			for each (path in tempPathArr)
			{
				var index:int = _openFolderPathArr.indexOf(path);
				_openFolderPathArr.splice(index, 1);
			}
			
			_tree.dataSource = _treeCellRendererVOArr;
			//暂时没有找到更好的测量高度的办法,所以这里多处理了一次render
			_tree.render();
			contentHeight = _tree.itemSum*(ITEM_HEIGHT+_tree.gap);
			
			if (refreshView)
			{
				folderOpenOrClose();
			}
		}
		
		/**
		 * 更新数据源后展开新插入数据的面板 
		 * @param currentNode
		 */		
		private function selectedFolder(currentNode:TreeCellRenderer):void
		{
			var path:String = currentNode.treeCellRendererVO.data.path;
			_selectPath = path;
			
			var evt:FileEvent = new FileEvent(FileEvent.OPEN_FOLDER);
			evt.path = path;
			dispatchEvent(evt);
		}
		
		/**
		 * 由于Tree内重新设置数据源后无法记录之前设置的展开状态
		 * 所以需要按 _openFolderPathArr内记录数据恢复文件夹展开关闭状态
		 */		
		private function folderOpenOrClose():void
		{
			for each (var node:TreeCellRenderer in _tree.treeCellRendererList)
			{
				var path:String = node.treeCellRendererVO.data.path;
				node.selected = (_openFolderPathArr.indexOf(path) != -1);
				node.selectedItemBoolean = (path == _selectPath);
				if (node.selectedItemBoolean)
				{
					_tree.selectedItem = node;
				}
			}
			_tree.render();
		}
		
		/**
		 * 修正滚动位置 
		 */		
		private function updateScrollY():void
		{
			if (!_tree.selectedItem)
			{
				return;
			}
			if (_tree.height < height)
			{
				scrollY = 0;
			}
			else
			{
				if (_tree.selectedItem.y > height-ITEM_HEIGHT && _tree.selectedItem.y - scrollY >= height)
				{
					scrollY = _tree.selectedItem.y - height + ITEM_HEIGHT;
				}
				else if (scrollY > _tree.selectedItem.y)
				{
					scrollY = _tree.selectedItem.y;
				}
			}
		}
		
		
		/**
		* 根据数据内容,查找渲染条目匹配项 
		* @param currentNodeVO
		* @return 
		*/		
		private function searchNodeByVO(currentNodeVO:TreeCellRendererVO):TreeCellRenderer
		{
			for each (var node:TreeCellRenderer in _tree.treeCellRendererList)
			{
				if (node.treeCellRendererVO.data.path == currentNodeVO.data.path)
				{
					return node;
				}
			}
			return null;
		}
		
		/**
		 * 根据绝对路径查查找渲染条目匹配项 
		 * @param path
		 * @return 
		 */		
		private function searchNodeByPath(path:String):TreeCellRenderer
		{
			for each (var node:TreeCellRenderer in _tree.treeCellRendererList)
			{
				if (node.treeCellRendererVO.data.path == path)
				{
					return node;
				}
			}
			return null;
		}
		
		/**
		 * 打印目录数据 
		 * @param data
		 */		
		private function traceData(data:Array, level:int=0):void
		{
			return;
			var j:uint;
			var tabs:String;
			for (var i:uint = 0; i < data.length; i++)
			{
				var treeCellRendererVO:TreeCellRendererVO = data[i] as TreeCellRendererVO;
				tabs = "";
				for (j = 0; j < level; j++)
					tabs += "  ";
				trace (level, tabs, treeCellRendererVO.data.path);
				if (treeCellRendererVO.childNodes && treeCellRendererVO.childNodes.length){
					traceData(treeCellRendererVO.childNodes, level+1);
				}
			}
		}
		
		/**
		 * 打印显示节点信息 
		 * @param data
		 * @param level
		 */		
		private function traceTree(data:Vector.<TreeCellRenderer>, level:int=0):void
		{
			return;
			var i:uint, j:uint;
			var tabs:String;
			for (i = 0; i < data.length; i++)
			{
				var treeCellRenderer:TreeCellRenderer = data[i];
				trace (treeCellRenderer.treeCellRendererVO.data.path, treeCellRenderer.shows);
			}
		}
		
		/**
		 * 获取计算机根目录数组
		 * @return 
		 */		
		private function getRootVOArr(rootPath:String):Array
		{
			var treeCellRendererVOArr:Array = [];
			var rootVO:TreeCellRendererVO;
			var itemData:FileBoxItemData;
			
			if (rootPath == FileBoxDefine.ROOT_PATH)
			{
				var letters:Array = Utils.getExistsLetters();
				for each (var letter:String in letters)
				{
					itemData = new FileBoxItemData();
					itemData.name = letter;
					itemData.isDirectory = true;
					itemData.path = letter;
					
					rootVO = new TreeCellRendererVO();
					rootVO.label = letter;
					rootVO.data = itemData;
					
					treeCellRendererVOArr.push(rootVO);
				}
			}
			else
			{
				itemData = new FileBoxItemData();
				itemData.name = rootPath;
				itemData.isDirectory = true;
				itemData.path = rootPath;
				
				rootVO = new TreeCellRendererVO();
				rootVO.label = rootPath;
				rootVO.data = itemData;
				
				treeCellRendererVOArr.push(rootVO);
			}
			return treeCellRendererVOArr;
		}
		
		/**
		 * 根据盘符名生成根目录文件信息数组
		 * @param letters
		 * @return 
		 */		
		private function getFileInfoByLetters(letters:Array):Array
		{
			var fileInfoArr:Array = new Array();
			for (var i:uint = 0; i < letters.length; i++)
			{
				var letter:String = letters[i];
				var fileInfo:FileInfo = new FileInfo();
				fileInfo.isDirectory = true;
				fileInfo.name = letter;
				fileInfoArr[i] = fileInfo;
			}
			return fileInfoArr;
		}
		
		/**
		 * 当前选中路径 
		 * @return 
		 */		
		public function get selectPath():String
		{
			return _selectPath;
		}

		public function get itemWidth():int
		{
			return _tree.itemWidth;
		}
		
		/**
		 * 设置条目宽度
		 * @param value
		 */		
		public function set itemWidth(value:int):void
		{
			_tree.itemWidth = value;
		}
		
		public function get itemHeight():int
		{
			return _tree.itemHeight;
		}
		
		/**
		 * 设置条目高度 
		 * @param value
		 */		
		public function set itemHeight(value:int):void
		{
			_tree.itemHeight = value;
		}
		
		/**
		 * 处理内存回收 
		 */		
		override public function dispose():void
		{
			//盘符浏览组件
			removeChild(_tree).dispose();
			_tree = null;
			
			//当前展示目录结构对应全部数据
			_treeCellRendererVOArr.length = 0;
			_treeCellRendererVOArr = null;
			
			//记录所有处理展开状态的路径
			_openFolderPathArr.length = 0;
			_openFolderPathArr = null;
			
			super.dispose();
		}
		
		//暂时保留2个废弃方法,待FolderTree相对稳定后删除
		/**
		 * node节点的父节点保持打开状态
		 * 处理node节点"展开"/"关闭"状态
		 * @param node 操作节点
		 * @param value 打开关闭状态 true为打开,false为关闭
		 */		
		private function operateFolder(node:TreeCellRenderer, value:Boolean):void
		{
			keepParentFolderOpen(node);
			node.selected = value;
			_tree.render();
		}
		
		/**
		 * 保证当前目录节点的上级目录为打开状态 
		 * @param node
		 */		
		private function keepParentFolderOpen(node:TreeCellRenderer):void
		{
			while (node.parentNode){
				node = node.parentNode;
				node.shows = true;
				node.selected = true;
			}
		}

		/**
		 * 是否过滤中文文件名 
		 * [read only]
		 * @return 
		 */		
		public function get filterCNCharacters():Boolean
		{
			return _filterCNCharacters;
		}

	}
}