package  potato.editor.fileBox
{
	import core.display.Graphics;
	import core.display.Image;
	import core.display.Shape;
	import core.display.Texture;
	import core.display.TextureData;
	import core.filters.ShadowFilter;
	import core.text.TextField;
	
	import potato.component.Bitmap;
	import potato.component.Button;
	import potato.component.Container;
	import potato.component.Text;
	import potato.component.core.IListItem;
	import potato.component.core.IToggle;
	import potato.component.data.BitmapSkin;
	import potato.component.data.TextFormat;

	
	/**
	 * 文件展示渲染器<br>
	 * 这是一个矩形的容器，左侧显示文件的缩略图，缩略图右侧显示文件的名称
	 */	
	public class FileBoxItemRenderSmall extends Container
		implements IListItem,IToggle	
	{
		public static const FILTER_TEXT_SHADOW:ShadowFilter = new ShadowFilter(0x77000000,2,2,false);
		public static const FONT_TITLE_LEFT:TextFormat=new TextFormat("黑体",22,0xd6d6d6,TextField.ALIGN_LEFT,1,FILTER_TEXT_SHADOW);
		public static const SIZEH:int=40;
		public static const SIZEW:int=400;
		private const _iconSize:int=25;
		private var _index:int;
		private var _btn:Button;
		private var _data:FileBoxItemData;
		private var icon:Bitmap;
		private var texts:Text;// 文件（夹）名字
		private var _bg:Bitmap;
		private var _selected:Boolean=false;
		private var _toggleEnable:Boolean=false;

		public function get toggleEnable():Boolean
		{
			return _toggleEnable;
		}

		public function set toggleEnable(value:Boolean):void
		{
			_toggleEnable = value;
		}

		
		public function FileBoxItemRenderSmall()
		{
			super(SIZEW,SIZEH);
			createChildren();
		}
	
		/**
		 *索引值 
		 * @return 
		 * 
		 */		
		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}
		/**
		 *获得数据时，文件夹和文件分开渲染 
		 * @param value
		 * 
		 */		
		public function set data(value:Object):void
		{
			_data=value as FileBoxItemData;
			texts.text=_data.name;
			if(_data.isDirectory){
				icon.skin=new BitmapSkin("files.png");
			}else
			{
				// 是图片的情况
				if(FileBoxDefine.IMAGE_REG.test(_data.name))
				{
					var textrueData:TextureData=TextureData.createWithFile(_data.path+"\\"+_data.name);
					if(textrueData.width>textrueData.height && textrueData.width>_iconSize){// 宽图,宽度大于标准
						icon.width=_iconSize;
						icon.height=(_iconSize/textrueData.width)*textrueData.height;
					}else if(textrueData.height>textrueData.width && textrueData.height>_iconSize){// 高图,高度大于标准
						icon.width=(_iconSize/textrueData.height)*textrueData.width;
						icon.height=_iconSize;
					}
					else if(textrueData.height==textrueData.width&&textrueData.height>_iconSize)// 正方形,边长大于标准
					{
						icon.width=_iconSize;
						icon.height=_iconSize;
					}
					else{
						icon.width=textrueData.width;
						icon.height=textrueData.height;
					}
					icon.y=(SIZEH-icon.height)>>1;
					icon.skin=new BitmapSkin(textrueData);
				}
				else
				// 不是图片文件
				{
					icon.skin=new BitmapSkin("file.png");
				}
			}
		}
		public function get data():Object
		{
			return _data;
		}
		public function get label():String{
			return "";
		}
		/**
		 *当被选中时，重新渲染底背景 
		 * @param value
		 * 
		 */		
		public function set selected(value:Boolean):void
		{
			if(_selected!=value){
				_selected=value;
				if(_selected){
					_bg.skin=new BitmapSkin("comboBg.png","10,10,10,10");
					_bg.width=this.width;
				}else{
					_bg.skin=null;
				}
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		/**
		 *创建子项 
		 * 
		 */		
		private function createChildren():void{
			initBg();
			var gap:int=5;
			_bg=new Bitmap(null,SIZEH,SIZEH);
			addChild(_bg);
			icon=new Bitmap(null,_iconSize,_iconSize);
			this.addChild(icon);
			icon.y=(SIZEH-_iconSize)>>1;
			texts=new Text("",null,(SIZEW-_iconSize-gap),40,FONT_TITLE_LEFT);
			this.addChild(texts);
			texts.x=icon.x+_iconSize+gap;
			texts.y=(SIZEH-texts.height)>>1;
			this.height=texts.height;
		}
		private function initBg():void
		{
			var _shape:Shape=new Shape();
			var _g:Graphics=_shape.graphics;
			_g.beginFill(0xffffff, 0.05);
			_g.drawRect(0, 0,SIZEW,SIZEH);
			_g.endFill();
			var td:TextureData = TextureData.createRGB(SIZEW, SIZEH, true, 0x0);
			td.draw(_shape);
			var tex:Texture = new Texture(td);
			var img:Image=new Image(tex)
			addChild(img);
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(icon){
				this.removeChild(icon);
				icon.dispose();
				icon=null;
			}
			if(texts){
				this.removeChild(texts);
				texts.dispose();
				texts=null;
			}
		}
	}
}