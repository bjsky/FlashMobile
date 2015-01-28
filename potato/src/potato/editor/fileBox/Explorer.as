package potato.editor.fileBox
{
	import core.display.DisplayObject;
	
	import potato.component.Container;
	import potato.utils.SharedObject;
	import potato.utils.Utils;
	
	/**
	 * 资源管理器 
	 * @author wanghao
	 */	
	public class Explorer extends Container
	{
		/**
		 * 默认组件标示符,如果组件使用默认标示符,将使用通用的历史记录 
		 */		
		private static const DEFAULT_NAME:String = "default_explorer";
		
		private var _folderTree:FolderTree; //文件夹列表
		private var _fileBox:FileBox; //文件浏览主见
		private var _rootPath:String; //顶级目录(根目录限定可后退至的顶级位置)
		private var _historyKey:String; //资源管理组件标示符,用于记录历史打开目录
		
		/**
		 * 构造资源管理器  
		 * @param width 宽度
		 * @param height 高度
		 * @param isDirect 设置FileBox的 isDirect,参考 FileBox内说明
		 * @param expanded 设置FileBox的 expanded,参考FileBox内说明
		 * @param rootPath 根目录,这个目录限制向上跳转的最大层级. "/"代表根目录
		 * @param historyKey 用于记录历史打开记录的key 如果未设置historyKey则不进行历史打开路径记录.每个historyKey只对应一条记录
		 */	
		public function Explorer(width:Number, height:Number, isDirect:Boolean=false, expanded:String="*", filterCNCharacters:Boolean=true, rootPath:String=FileBoxDefine.ROOT_PATH, historyKey:String=null)
		{
			super(width, height);
			
			this.rootPath = FileBoxGlobalFunction.clearLastSepatrator(rootPath);
			
			//初始化盘符列表
			_folderTree = new FolderTree(200, height, filterCNCharacters, this.rootPath);
			_folderTree.addEventListener(FileEvent.OPEN_FOLDER, folderOpenHandler);
			_folderTree.addEventListener(FileEvent.OPEN_ERROR, folderOpenError);
			addChild(_folderTree);
			
			//文件浏览组件
			_fileBox = new FileBox(width-200, height, isDirect, expanded, filterCNCharacters, this.rootPath);
			_fileBox.addEventListener(FileEvent.OPEN_FOLDER, folderOpenHandler);
			_fileBox.addEventListener(FileEvent.OPEN_ERROR, folderOpenError);
			_fileBox.x = 200;
			addChild(_fileBox);
			
			//组件标示符
			_historyKey = historyKey;
			
			//打开之前组件打开的路径
			var historyPath:String = getCookie();
			if (historyPath != null && historyPath.length) 
				openFile(historyPath);
			else
				openFile(_rootPath);
		}
		
		/**
		 * 文件夹打开事件处理
		 * @param evt
		 */		
		private function folderOpenHandler(evt:FileEvent):void
		{
			//处理联动
			var target:DisplayObject = evt.currentTarget as DisplayObject;
			var path:String = evt.path;
			switch (target)
			{
				case _folderTree:
				{
					//防止事件二次派发
					_fileBox.openFile(path, false);
					break;
				}
				case _fileBox:
				{
					_folderTree.openFolderByPath(path);
					break;
				}
				default:
					break;
			}
			
			//为_fileBox设置根目录
			if (_rootPath == FileBoxDefine.ROOT_PATH)
			{
				var currRootPath:String = FileBoxGlobalFunction.getRootPath(path);
				if (_fileBox.rootPath != currRootPath)
					_fileBox.rootPath = currRootPath;
			}
			
			//记录历史打开路径
			saveCookie(path);
			
			//向上抛出事件
			dispatchEvent(evt);
		}
		
		/**
		 * 文件夹打开错误
		 * @param evt
		 */
		private function folderOpenError(evt:FileEvent):void
		{
			if (evt.currentTarget == _fileBox)
			{
				//在收到2个事件时只向上抛出一个
				dispatchEvent(evt);
			}
		}
		
		/**
		 * 根据路径逐层打开并选中路径对应文件夹 
		 * @param path
		 */		
		public function openFile(path:String):void
		{
			//处理无法访问路径情况下构建失败的问题
			if ((path.indexOf(".") == -1 && !Utils.validFolder(path)) 
				|| (path == FileBoxDefine.ROOT_PATH && Utils.platformVer() <= Utils.PV_WIN))
			{
				path = FileBoxDefine.ROOT_PATH_ARR[0];
			}

			_folderTree.openFolderByPath(path);
			_fileBox.openFile(path, false);
		}
		
		/**
		 * 记录最后一次打开路径 
		 * @param path
		 */		
		private function saveCookie(path:String):void
		{
			if (_historyKey)
			{
				var obj:Object = SharedObject.getLocal(_historyKey).data;
				obj["path"] = path;
				SharedObject.getLocal(_historyKey).flush();
			}
		}
		
		/**
		 * 获取最后一次打开路径 
		 * @return 
		 */		
		public function getCookie():String
		{
			if (_historyKey)
				return SharedObject.getLocal(_historyKey).data["path"];
			return "";
		}
		
		/**
		 * 为文件管理器设置回调方法 
		 * @param fun
		 */		
		public function set callBackFun(fun:Function):void
		{
			if (_fileBox != null)
			{
				_fileBox.callBackFun = fun;
			}
		}
		
		/**
		 * 设置是否是目录操作
		 */
		public function set isDirectory(value:Boolean):void
		{
			if(_fileBox)
			{
				_fileBox.isDirectory=value;
			}
		}
		
		/**
		 * 设置后缀筛选字符串
		 */
		public function set expanded(value:String):void
		{
			if(_fileBox)
			{
				_fileBox.expanded=value;
			}
		}
		
		/**
		 * 资源管理组件标示符,用于记录历史打开目录
		 * [read only] 
		 * @return 
		 */		
		public function get historyKey():String
		{
			return _historyKey;
		}
		
		/**
		 * 处理内存回收 
		 */		
		override public function dispose():void
		{
			//文件夹列表
			removeChild(_folderTree).dispose();
			_folderTree = null;
			
			//文件浏览主见
			removeChild(_fileBox).dispose();
			_fileBox = null;
			
			super.dispose();
		}

		/**
		 * 根目录路径 
		 * @return 
		 */		
		private function get rootPath():String
		{
			return _rootPath;
		}
		
		/**
		 * 设置根目录路径 
		 * @param value
		 */		
		private function set rootPath(value:String):void
		{
			if (value == null || value.length == 0)
			{
				value = FileBoxDefine.ROOT_PATH;
			}
			_rootPath = value;
		}

	}
}