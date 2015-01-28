package potato.editor.fileBox
{
	import flash.utils.getTimer;
	
	import core.display.Graphics;
	import core.display.Image;
	import core.display.Shape;
	import core.display.Texture;
	import core.display.TextureData;
	import core.events.Event;
	import core.events.TextEvent;
	import core.events.TouchEvent;
	import core.filesystem.File;
	import core.filesystem.FileInfo;
	import core.filters.ShadowFilter;
	import core.text.TextField;
	
	import potato.component.Bitmap;
	import potato.component.Button;
	import potato.component.Container;
	import potato.component.List;
	import potato.component.Text;
	import potato.component.TextInput;
	import potato.component.core.RenderType;
	import potato.component.data.BitmapSkin;
	import potato.component.data.Padding;
	import potato.component.data.TextFormat;
	import potato.component.event.ListEvent;
	import potato.editor.Combo;
	import potato.editor.ComboSkin;
	
	/**
	 * 文件浏览组件.
	 * <p>目录、文件两种操作模式<br>
	 * 支持两种列表视图<br>
	 * 可以根据后缀（多个）筛选文件<br>
	 * </p>
	 */
	public class FileBox extends Container
	{
		private var _tf_center:TextFormat=new TextFormat("黑体",22,0xffffff,TextField.ALIGN_CENTER,TextField.ALIGN_CENTER
			,new ShadowFilter(0x77000000,2,2,false));
		private var _tf_right:TextFormat=new TextFormat("黑体",22,0xffffff,TextField.ALIGN_RIGHT,TextField.ALIGN_CENTER
			,new ShadowFilter(0x77000000,2,2,false));
		private var _tf_left:TextFormat=new TextFormat("黑体",22,0xffffff,TextField.ALIGN_LEFT,TextField.ALIGN_CENTER
			,new ShadowFilter(0x77000000,2,2,false));
		
		// 是否是选择目录
		private var _isDirectory:Boolean=false;

		

		private var _rootPath:String=".";
		private var _path:String;
		private var _selectFilter:RegExp;
		private var _initExpanded:String="";// 初始化时给的筛选后缀字符串
		private var _expanded:String="";
		private var _expendedArr:Array=[];	
		private var _timeCount:int=0;// 双击计数器
		private var _lastIndex:int;// 双击判断是否对一个item做的 点击
		/**
		 * 目标文件名字
		 */
		private var aimName:String="";
		private var _callBackFun:Function;
		
		/**
		 * 当前路径下的文件和目录列表<br>
		 * 会根据过滤条件进行过滤
		 */
		private var _fileArr:Array=[];
		
		/**
		 * 文件（目录）列表容器
		 */
		private var _list:FileBoxList;
		
		/**
		 *确定按钮 
		 */		
		private var _okButton:Button;
		/**
		 *取消按钮 
		 */		
		private var _cancelBtn:Button;
		
		/**
		 * 回上级目录按钮
		 */		
		private var _backBtn:Button;
		
		/**
		 * 显示目录
		 */	
		private var  _pathTxt:Text; 
		
		/**
		 * 列表显示按钮
		 */		
		private var _listBtn:Button;
		
		/**
		 *缩略图 显示按钮
		 */		
		private var _thumbnailBtn:Button;
		/**
		 *文件名输入框 
		 */		
		private var _newFileNameInput:TextInput;
		/**
		 * "文件名"
		 */
		private var _fileNameTxt:Text;
		
		/**
		 * 筛选下拉列表组件
		 */
		private var _expandedComb:Combo;
		
		/**
		 * 是否过包含中文字符的目录 
		 */		
		private var _filterCNCharacters:Boolean=true;
		/**
		 *初始化时的步骤记录
		 */		
//		private var _createStep:int=0;
		
		/**
		 * @param width 宽度
		 * @param height 高度
		 * @param isDirect 是否只选择目录，为true时，expanded失效
		 * @param expanded 文件后缀筛选字符串（示例："png|jpg|xml"，"*"表示不做筛选）<br>
		 * @param rootPath 可以访问的根目录，这个目录的上级目录不可以访问。默认值是当前虚拟机所在目录“.”
		 */
		public function FileBox(width:Number, height:Number,isDirect:Boolean=false,expanded:String="*",filterCNCharacters:Boolean=true,rootPath:String=".")
		{
			super(width, height);
			this._isDirectory=isDirect;
			_initExpanded=expanded;
			_expendedArr=expanded.split("|");
			_filterCNCharacters=filterCNCharacters;
			_rootPath=rootPath;
			init();
		}
		
		/**
		 * 设置回调方法<br>
		 * 回调方法参数为路径字符串，如果没有作选择空字符串
		 */
		public function set callBackFun(value:Function):void
		{
			_callBackFun = value;
		}
		/**
		 * 设置后缀筛选字符串
		 */
		public function set expanded(value:String):void
		{
			if(_initExpanded!=value)
			{
				_initExpanded=value;
				_expendedArr=value.split("|");
				if(_expandedComb)
				{
					_expandedComb.dataSource=_expendedArr;
					if(_expendedArr.length)
					{
						_expandedComb.selectIndex=0;
					}
				}
			}
		}
		/**
		 * 设置是否是目录操作
		 */
		public function set isDirectory(value:Boolean):void
		{
			if(_isDirectory!=value)
			{
				_isDirectory = value;
				if(_newFileNameInput)
				{
					_newFileNameInput.visible=!_isDirectory;
				}
				if(_fileNameTxt)
				{
					_fileNameTxt.visible=!_isDirectory;
				}
				if(_expandedComb)
				{
					_expandedComb.visible=!_isDirectory;
				}
			}
		}
		/**
		 *打开指定路径<br>
		 * 路径包括的文件如果存在，默认会被选中<br>
		 * 不能选中目录
		 * @param broadcast 打开文件夹时是否派发事件
		 */		
		public function openFile(openPathStr:String, broadcast:Boolean=false):void
		{
			proOpen(openPathStr);
			doOpen(broadcast);
		}

		/**
		 * 手动第一次加载
		 * 设置aimName和_path
		 */
		private function proOpen(openPathStr:String):void
		{
			if(openPathStr==null||openPathStr=="")
			{
				openPathStr=".";
			}
			var pathStr:String=FileBoxGlobalFunction.clearPath(openPathStr);// 清理
			pathStr=pathStr.replace(FileBoxDefine.REPLACE_REG,FileBoxDefine.DIRECTORY_SEPATRATOR);// 替换
			aimName="";
			pathStr=FileBoxGlobalFunction.clearLastSepatrator(pathStr);
			var lIndex:int=pathStr.lastIndexOf(FileBoxDefine.DIRECTORY_SEPATRATOR);
			
//			while(lIndex+1==pathStr.length&&pathStr.length>0)
//			{
//				pathStr=pathStr.substr(0,pathStr.length-1);
//				lIndex=pathStr.lastIndexOf(DIRECTORY_SEPATRATOR);
//			}
			// 得到新的目标和路径
			{
				if(lIndex>-1)
				{
					aimName=pathStr.substr(lIndex+1,pathStr.length);// 得到路径中包括的名字
					//文件为有效文件或者文件名内包括.符号认定为文件名,进行截除,剩余部分保留为路径名
					if (File.exists(pathStr) || aimName.indexOf(".") != -1)
						pathStr=pathStr.substr(0,lIndex);// 纯路径
				}else
				{
					aimName=pathStr;
					//2015-01-19王昊将下面代码注释,原因是不再需要制定一个根目录
					//pathStr=".";
				}
			}
			path=pathStr;
		}
		/**
		 * 不处理路径参数直接打开
		 * 设置aimName和_path
		 */
		private function directOpen(pathStr:String):void
		{
			
			if(path!=pathStr&&_newFileNameInput)// 如果更换了目录
			{
				_newFileNameInput.text="";
				aimName="";
				path=pathStr;
			}else
			{
				if(_newFileNameInput)
				{
					aimName=_newFileNameInput.text;// 显示内容作为目标
				}
			}
			
		}
		/**
		 * 打开文件
		 * @param broadcast 打开文件夹时是否派发事件
		 */
		private function doOpen(broadcast:Boolean=true):void
		{
//			if(path==null)// 第一次进来
//			{
//				path=pathStr;
//			}
//			else 
//			{
//				if(path!=pathStr&&_newFileNameInput)// 如果更换了目录
//				{
//					_newFileNameInput.text="";
//					path=pathStr;
//				}else
//				{
//					if(_newFileNameInput)
//					{
//						aimName=_newFileNameInput.text;// 显示内容作为目标
//					}
//				}
//			}
			var evt:FileEvent;
			var showpath:String=new String(path);
			if(showpath.length)
			{
				showpath=showpath.replace(/^\./,"");// 替换开头的.
				showpath=showpath.replace(new RegExp("^/"),"");// 替换开头的.
			}
			_pathTxt.text="当前路径："+showpath;
			_fileArr.length=0;
			try{
				_fileArr=File.getDirectoryListing(this.path);
			}catch(e:Error){
				if (e.errorID == 3003){
					_pathTxt.text+=" 无法访问!";
					evt = new FileEvent(FileEvent.OPEN_ERROR);
					evt.path = this.path;
					dispatchEvent(evt);
				}
			}
			_fileArr=fliterPath(_fileArr);
			_fileArr.sortOn(["isDirectory","name"],[Array.NUMERIC|Array.DESCENDING,Array.CASEINSENSITIVE]);
			_list.dataSource=_fileArr;
			for(var j:uint=0;j<_fileArr.length;j++){
				if(FileBoxItemData(_fileArr[j]).name==aimName){
					_list.selectIndex=j;
					break;
				}else{
					_list.scrollY=0;
				}
			}
			this._list.setY();
			
			if (broadcast){
				evt = new FileEvent(FileEvent.OPEN_FOLDER);
				evt.path = this.path;
				dispatchEvent(evt);
			}
		}
		/**
		 * 初始化显示
		 */
		private function init():void
		{
			var gap:int=5;
			var topLineH:int=35;
			var bottomLineH:int=35;
			initBg();
			var listBg:Bitmap=new Bitmap();
			listBg.skin=new BitmapSkin("textbg.png","15,50,15,20");
			listBg.x=gap;
			listBg.y=topLineH;
			listBg.width=_width-2*gap;
			listBg.height=_height-topLineH-bottomLineH-gap;
			addChild(listBg);
			
			_list=new FileBoxList();
			_list.renderType=RenderType.IMMEDIATELY;
			_list.selectType=List.SELECT_SINGLE;
			_list.itemRender=FileBoxItemRenderSmall;
			
			_list.x=gap*2;
			_list.y=topLineH+gap;
			_list.width=_width-2*gap;
			_list.height=listBg.height-gap*2;
			_list.hScrollerVisible=false;
			_list.addEventListener(ListEvent.ITEM_TAP,listSelectChangeHandler);
			_list.addEventListener(ListEvent.SELECT_CHANGE,listSelectChangeHandler);
			this.addChild(_list);
			
			_listBtn=new Button([new BitmapSkin("listUp.png"),new BitmapSkin("listDown.png")],null,30,25,null);
			_listBtn.x=_width-_listBtn.width-gap;
			_listBtn.y=7;
			_listBtn.addEventListener(TouchEvent.TOUCH_BEGIN,onlistBtn);
			this.addChild(_listBtn);
			
			_thumbnailBtn=new Button([new BitmapSkin("thumbnailUp.png"),new BitmapSkin("thumbnailDown.png")],null,30,25,null);
			_thumbnailBtn.x=_listBtn.x-_thumbnailBtn.width-gap;
			_thumbnailBtn.y=7;
			_thumbnailBtn.addEventListener(TouchEvent.TOUCH_BEGIN,onThumbnailBtn);
			this.addChild(_thumbnailBtn);
			
			_backBtn=new Button([new BitmapSkin("backBtn.png"),new BitmapSkin("backBtn.png")],null,25,20,null);
			_backBtn.x=gap;
			_backBtn.y=10;
			_backBtn.addEventListener(TouchEvent.TOUCH_BEGIN,onBackBtn);
			this.addChild(_backBtn);
			
			_pathTxt=new Text("当前路径：",null,NaN,35,_tf_left);
			_pathTxt.width=_width-gap*5-_backBtn.width-_thumbnailBtn.width-_listBtn.width;
			_pathTxt.x=_backBtn.x+_backBtn.width+gap;
			_pathTxt.y=7;
			addChild(_pathTxt);
			
			_cancelBtn=new Button([new BitmapSkin("buttonUp.png","5,5,5,5"),new BitmapSkin("buttonUp.png","5,5,5,5")],"取消",80,35,_tf_center);
			_cancelBtn.x=_width-_cancelBtn.width-gap;
			_cancelBtn.y=_height-_cancelBtn.height-gap;
			_cancelBtn.addEventListener(TouchEvent.TOUCH_BEGIN,onCancleBtn);
			this.addChild(_cancelBtn);
			
			_okButton=new Button([new BitmapSkin("buttonUp.png","5,5,5,5"),new BitmapSkin("buttonUp.png","5,5,5,5")],"确 定",80,35,_tf_center);
			_okButton.x=_cancelBtn.x-_okButton.width-gap;
			_okButton.y=_cancelBtn.y;
			_okButton.addEventListener(TouchEvent.TOUCH_BEGIN,onOkButton);
			this.addChild(_okButton);
//			if(_isDirectory==false)	
//			{
				if(this._expendedArr.length==0)
				{
					_expendedArr.push("*");
				}
				var comboSkin:ComboSkin=new ComboSkin(new BitmapSkin("buttonUp.png","5,5,5,5"),new BitmapSkin("comboBg.png","10,10,10,10"),4
					,new BitmapSkin("comboBtn.png"),new BitmapSkin("comboBtn.png"),new BitmapSkin("comboBtn.png"),NaN,10);
				_expandedComb=
					new Combo(_expendedArr,FileBoxComboItemRender,comboSkin,_tf_center,150,35,NaN,new Padding(2,0,6,8));
				_expandedComb.x=_okButton.x-gap-_expandedComb.width;
				_expandedComb.y=_height-_expandedComb.height-gap;
				_expandedComb.autoPosition=true;
				_expandedComb.addEventListener(ListEvent.SELECT_CHANGE,listSeletedHandler);
				_expandedComb.selectIndex=0;
				addChild(_expandedComb);
				_expandedComb.visible=!_isDirectory;
				
				_fileNameTxt=new Text("文件名：",null,90,35,_tf_center);
				_fileNameTxt.x=gap;
				_fileNameTxt.y=_height-_fileNameTxt.height-gap;
				this.addChild(_fileNameTxt);
				_fileNameTxt.visible=!_isDirectory;
				
				_newFileNameInput=new TextInput();
				_newFileNameInput.restrict="[a-zA-Z0-9_.]+";
				_newFileNameInput.skin=new BitmapSkin("textbg.png","5,5,5,5");
				_newFileNameInput.textFormat=_tf_left;
				_newFileNameInput.width=_width-(_fileNameTxt.x+_fileNameTxt.width+gap)-(gap*2+_okButton.width*2)-gap-_expandedComb.width-gap;
				_newFileNameInput.height=35;
				_newFileNameInput.textFormat=_tf_right;
				_newFileNameInput.x=_fileNameTxt.x+_fileNameTxt.width+gap;
				_newFileNameInput.y=_fileNameTxt.y;
				_newFileNameInput.addEventListener(TextEvent.TEXT_INPUT,inputTextHandler);
				this.addChild(_newFileNameInput);
				_newFileNameInput.visible=!_isDirectory;
//			}
			setExpanded(_expendedArr[0]);
//			_createStep=1;
		}
		/**
		 *类型筛选 
		 * @param e
		 */		
		private function listSeletedHandler(e:ListEvent):void
		{
			e.stopPropagation();
			var fileType:String=e.item.data as String;
			setExpanded(fileType);
			if(path)
			{
//				this.openFile(this.path);
				this.doOpen();
			}
		}
		private function inputTextHandler(evt:TextEvent):void
		{
			if(!/[a-z0-9_.]+/.test(evt.text))// when in windows system ,lowercase and uppercase are same. 
			{
				_newFileNameInput.text="";
				return;
			}
			if(/^\./.test(evt.text))// when in unix system,if a file name start with "."that means it is hidden 
			{
				_newFileNameInput.text="";
				return;
			}
			if(this._selectFilter)
			{
				if(!_selectFilter.test(evt.text))
				{
					if(this._list.selectIndex!=-1)
					{
						this._list.selectIndex=-1;
					}
					return;
				}
			}
//			this.list.dataSource=this.fileArr;// 不让list选中任何一项
			this._list.selectIndex=-1;
			for(var i:int=0;i<this._fileArr.length;i++)// 试图匹配list其中一项
			{
				var fInfo:FileBoxItemData=_fileArr[i] as FileBoxItemData;
				if(!fInfo.isDirectory)
				{
					if(fInfo.name==evt.text)
					{
						this._list.selectIndex=i;
						this._list.setY();
						break;
					}
				}
			}
		}
		private function initBg():void
		{
			var _shape:Shape=new Shape();
			var _g:Graphics=_shape.graphics;
			_g.beginFill(0xffffff, 0.5);
			_g.drawRect(0, 0,_width,_height);
			_g.endFill();
			var td:TextureData = TextureData.createRGB(_width, _height, true, 0x0);
			td.draw(_shape);
			var tex:Texture = new Texture(td);
			var img:Image=new Image(tex)
			addChild(img);
		}
		private function onlistBtn(e:Event):void
		{
			if(this._list.itemRender!=FileBoxItemRenderSmall)
			{
				this._list.itemRender=FileBoxItemRenderSmall;
				this._list.setY();
			}
		}
		private function onThumbnailBtn(e:Event):void
		{
			
			if(this._list.itemRender!=FileBoxItemRenderBig)
			{
				this._list.itemRender=FileBoxItemRenderBig;
				this._list.setY();
			}
		}
		

		private  function listSelectChangeHandler(evt:ListEvent):void
		{
			var itemData:FileBoxItemData;
			if(evt.type==ListEvent.ITEM_TAP)
			{
				if(getTimer()-_timeCount<3000)
				{
					_timeCount=0;
					// todo 双击
					itemData=FileBoxItemData(evt.item.data);
					if(itemData.isDirectory&&_list.selectItem&&_list.selectItem.data.isDirectory)
					{
						if(itemData.name==_list.selectItem.data.name)
						{
							this.doSelectFolder();
							return;
						}
					}
				}else
				{
					_timeCount=getTimer();
					
				}
			}
			if(evt.type==ListEvent.SELECT_CHANGE){
				//				//				如果选中的不是文件夹
				//				var selectFile:FileInfo=FileInfo(evt.item.data);
				itemData=FileBoxItemData(evt.item.data);
				if(!itemData.isDirectory){
					if(_newFileNameInput)
					{
						var tempStr:String=itemData.name;
						_newFileNameInput.text=tempStr;
					}
				}else{
					if(_newFileNameInput)
					{
						_newFileNameInput.text="";
					}
				}
				_lastIndex=_list.selectIndex;
			}
		}
		
		/**
		 * ok按钮点击后执行的方法<br>
		 * 如果列表没有任何一项被选中，执行doSelectNothing方法；<br>
		 * 如果选中了一个目录，执行doSelectFolder方法；<br>
		 * 如果选中了一个文件，执行doSelectFile方法；<br>
		 * 子类覆盖上述三个方法，可以有自己不同的行为表现<br> 
		 * @param evt
		 * 
		 */
		private function onOkButton(evt:Event):void
		{
			if(_list.selectIndex==-1){
				doSelectNothing();
			}else{
				doSelectFile();
			}
		}
		private function onBackBtn(evt:Event):void
		{
			if(this.path==_rootPath)
			{
				return;
			}
			var tempArr:Array=this.path.split(FileBoxDefine.DIRECTORY_SEPATRATOR);
//			trace(">>>>>>>>>>>>"+this.path);
//			var splitStr:String="/";
//			var newPath:String=".";
			var newPath:String="";
			for(var i:int=0;i<tempArr.length-1;i++)
			{
				newPath+=tempArr[i]+FileBoxDefine.DIRECTORY_SEPATRATOR;
			}
//			openFile(newPath);
			newPath=FileBoxGlobalFunction.clearPath(newPath);
			newPath=FileBoxGlobalFunction.clearLastSepatrator(newPath);
//			this.directOpen(newPath);
			if(newPath=="")
			{
				newPath=_rootPath;
			}
			aimName="";
			path=newPath;
			this.doOpen();
		}
		private function onCancleBtn(evt:Event):void
		{
			if(_callBackFun!=null)
			{
				_callBackFun("");
			}
		}
		/**
		 * 过滤路径
		 * 1：根目录下不显示..(到上层)
		 * 2：有文件校验规则，过滤出符合校验的文件
		 * 3：没有文件校验规则，显示全部
		 */
		private function fliterPath(arr:Array):Array
		{
			var workArr:Array=[];
			var index:int=-1;
			
			for(var j:uint=0;j<arr.length;j++)
			{
				var itemData:FileBoxItemData=new FileBoxItemData();
				itemData.isDirectory=FileInfo(arr[j]).isDirectory;
				itemData.name=FileInfo(arr[j]).name;
				itemData.path=this.path;
				
				if(_filterCNCharacters && FileBoxGlobalFunction.hasCNCharacters(itemData.name))
					continue;
				
				if(_isDirectory)// 只见目录
				{
					if(itemData.isDirectory)
					{
						if(itemData.name!=".."&&itemData.name!=".")
						{
							workArr.push(itemData);
						}
					}
				}else 
				{
					if(	itemData.isDirectory)
					{
						if(itemData.name!=".."&&itemData.name!=".")
						{
							workArr.push(itemData);
						}
					}else
					{
						if(this._selectFilter)
						{
							if(this._selectFilter.test(itemData.name))
							{
								workArr.push(itemData);
							}
						}else
						{
							workArr.push(itemData);
						}
					}
				}
			}
			return workArr;
		}
		
		private function  doSelectNothing():void
		{
			if(this._newFileNameInput.text!="")
			{
				var sIndex:int=_expandedComb.selectIndex;
				var sStr:String=this._expendedArr[sIndex] as String;
				var newName:String=this._newFileNameInput.text;
				if(sStr!="*")
				{
					if(!new RegExp("\."+sStr+"$").test(newName))
					{
						newName+="."+sStr;
					}
				}
				_callBackFun(FileBoxGlobalFunction.clearPath(path+"/"+newName));
			}
			else if(_callBackFun!=null)
			{
				_callBackFun("");
			}
		}
		private function doSelectFolder():void
		{
//			openFile(path+"/"+_fileArr[_list.selectIndex].name);
			directOpen(path+"/"+_fileArr[_list.selectIndex].name);
			doOpen();
		}
		
		private function doSelectFile():void
		{
			if(_callBackFun!=null)
			{
				if(_list.selectIndex==-1)
				{
					return;	
				}
				
				var fInfo:FileBoxItemData=_fileArr[_list.selectIndex];
				var tempPath:String = FileBoxGlobalFunction.clearPath(fInfo.path+"/"+fInfo.name);
				_callBackFun(tempPath);
				
				var evt:FileEvent = new FileEvent(FileEvent.OPEN_FILE);
				evt.path = tempPath;
				dispatchEvent(evt);
				
//				if(_isDirectory)// 如果是选择目录，清理冗余路径表示
//				{
//					if(fInfo.isDirectory)
//					{
//						_callBackFun(clearPath(fInfo.path+"/"+fInfo.name));
//					}
//				}else
//				{
//					// todo 经过商议决定排除确定按钮点击后的多种分支，统一返回数据
//					//					if(fInfo.isDirectory)
//					//					{
//					
//					//						doSelectFolder();
//					//					}else
//					//					{
//					//						_selectFun([clearPath(path+"/"+fInfo.name)]);
//					_selectFun([clearPath(fInfo.path+"/"),fInfo.name,fInfo.isDirectory]);
//					//					}
//				}
			}
		}
		
		/**
		 * 设置筛选过滤后缀字符串<br>
		 * 格式实例："abc|def|123"<br>
		 * 以"*"表示匹配所有文件
		 * openFile 方法后调用无效
		 */
		private function setExpanded(value:String):void
		{
			if(value!="")
			{
				_expanded = value;
				
				if(value.indexOf("*")==0)
				{
					_selectFilter=null;
				}else
				{
//					_selectFilter=new RegExp("^[\\d|a-z|A-z|_|\\.]+\\.+(?:"+value+")$");
					_selectFilter=new RegExp("\."+value+"$");
				}
				
				_expanded = value;
			}
		}

		/**
		 * 要打开的路径
		 * 可以指定具体的文件名
		 */
		private function get path():String
		{
			return _path;
		}

		/**
		 * @private
		 */
		private function set path(value:String):void
		{
			_path = value;
			if(_rootPath == _path)
			{
				this._backBtn.visible=false;
			}else
			{
				this._backBtn.visible=true;
			}
		}

		public function set rootPath(value:String):void
		{
			_rootPath = value;
			if(_rootPath == path)
			{
				this._backBtn.visible=false;
			}else
			{
				this._backBtn.visible=true;
			}
		}

		public function get rootPath():String
		{
			return _rootPath;
		}

		/**
		 * 是否过滤中文目录 
		 * [read only]
		 */
		public function get filterCNCharacters():Boolean
		{
			return _filterCNCharacters;
		}

	}
}