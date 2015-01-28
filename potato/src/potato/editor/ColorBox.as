package potato.editor
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import core.display.DisplayObjectContainer;
	import core.display.Graphics;
	import core.display.Image;
	import core.display.Shape;
	import core.display.Texture;
	import core.display.TextureData;
	import core.events.TouchEvent;
	import core.filters.ShadowFilter;
	import core.text.TextField;
	
	import potato.component.Bitmap;
	import potato.component.Button;
	import potato.component.Container;
	import potato.component.Text;
	import potato.component.ToggleGroup;
	import potato.component.core.RenderManager;
	import potato.component.core.RenderType;
	import potato.component.data.BitmapSkin;
	import potato.component.data.TextFormat;
	import potato.component.event.ToggleGroupEvent;
	
	/**
	 * 色板组件.
	 * 
	 * @author yuzhifeng
	 * 
	 */
	public class ColorBox extends Container
	{
		public function ColorBox(width:Number=NaN, height:Number=NaN,preinstallColorList:Array=null,curColor:String="0xffffff")
		{
			super(width, height);
			_selectionColor=curColor;
			if(preinstallColorList==null)
			{
				createChildren();
			}
			else
			{
				_paleColorList=preinstallColorList;
				createChildren();
			}
			
		}
		
		//////////////////////////////
		// interface
		/////////////////////////////
		
		/**
		 * 放置文本框的数组
		 */		
		protected  var _txtList:Array=[];
		
		/**
		 * 色板的容器
		 */
		protected var _preinstallContainer:DisplayObjectContainer;
		
		/**
		 *  保存预设按钮
		 */
		protected var _paletteBtn:Button;	
		/**
		 *  确定按钮
		 */
		protected var _confirmBtn:Button;
		
		/**
		 *大颜色快的背景皮肤 
		 */		
		protected var _colorRectBg:Bitmap;
		/**
		 * 色条的背景图
		 */		
		protected var _colorBarBg:Bitmap;
		/**
		 * 缩略图
		 */		
		protected var _colorThumbnailBg:Bitmap;
		/**
		 * 色板容器背景
		 */		
		protected var _paletteBg:Bitmap;
		
		/**
		 * 预设颜色块的bgList
		 * 
		 */	
		protected var _paletteColorBtnList:Array=[];
		
		
		/**
		 * 文字样式 
		 */
		protected var _textFormat:TextFormat=new TextFormat("黑体",22,0xffffff,TextField.ALIGN_CENTER,TextField.ALIGN_CENTER
			,new ShadowFilter(0x77000000,2,2,false));
		private var _textFormat2:TextFormat=new TextFormat("黑体",22,0xffffff,TextField.ALIGN_LEFT,TextField.ALIGN_CENTER
			,new ShadowFilter(0x77000000,2,2,false));
		
		/**
		 * 颜色选择的回调函数 :
		 * function colorSelected(color:String):void;
		 */		
		public var colorSelected:Function;
		
		/**
		 * 预设颜色列表的回到函数
		 * function paleColor(color:Array):void;
		 */		
		public var paleColor:Function;
		
		
		////////////////////////////
		// private
		/////////////////////////////
		private var _selectionColor:String="ffffff";
		
		private var clickNum:int=1;//点击保存按钮的次数
		private var boo:Boolean;
		
		
		/**
		 * 预设色板的初始颜色
		 */		
		private var _paleColorList:Array=["000000","ffffff","ff0000","00ff00","0000ff","ffff00","00ffff","ff00ff",
			                              "ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff","ffffff"];
		/**
		 * 保存颜色的按钮
		 */	
		private function paleBtnEnd(e:TouchEvent):void
		{
			var textureD:TextureData=TextureData.createRGB(28,21,false,parseInt(_selectionColor,16));
			var tt:Texture=new Texture(textureD);
			
			if(boo)
			{
				((_preinstallContainer.getChildAt(seletionRect) as Button).getChildAt(1) as Image).texture=tt;
				_paleColorList.splice(seletionRect-1,1,_selectionColor);//记录颜色
				_group.select(_preinstallContainer.getChildAt(seletionRect) as Button);
				boo=false;
			}
			else
			{
				((_preinstallContainer.getChildAt(clickNum) as Button).getChildAt(1) as Image).texture=tt;
				_paleColorList.splice(clickNum-1,1,_selectionColor);//记录颜色
				_group.select(_preinstallContainer.getChildAt(clickNum) as Button);
				clickNum++;
				if(clickNum>=17)
				{
					clickNum=1;
				}
			}
			_group.select(_preinstallContainer.getChildAt(clickNum) as Button);
			
			if(paleColor!=null)
			{
				paleColor(_paleColorList);
			}
		}
		/**
		 * 确定
		 * @param e
		 */		
		private function conBtnEnd(e:TouchEvent):void
		{
			boo=false;
			//调用回调
			if(colorSelected!=null){
				colorSelected(_selectionColor);
			}
		}
		private var _group:ToggleGroup;
		/** 
		 * 预设颜色
		 */		
		private function palette():void
		{
			_group=new ToggleGroup();
			for(var i:int=0;i<16;i++)
			{
				var btn:Button=new Button([new BitmapSkin("buttonUp.png","5,5,5,5"),null,null,new BitmapSkin("buttonDown.png","5,5,5,5")],null,41,34);
				var ptd:TextureData=TextureData.createRGB(btn.width-13,btn.height-13,false,parseInt(_paleColorList[i],16));
				var im:Image=new Image(new Texture(ptd));
				im.x=im.y=5;
				btn.data=i;
				btn.addChild(im);
				btn.toggleGroup=_group;
				btn.x=(btn.width+3)*int(i%4)+10;
				btn.y=(btn.height+3)*int(i/4);
				_preinstallContainer.addChild(btn);
				_paletteColorBtnList.push(btn);
				im.addEventListener(TouchEvent.TOUCH_BEGIN,paletteTouch);
			}
			_group.select(_preinstallContainer.getChildAt(clickNum) as Button);
			_group.addEventListener(ToggleGroupEvent.SELECT_CHANGE,onChange);
//			_group.mutiSelectEnable=false;
		}
		private function onChange(e:ToggleGroupEvent):void
		{
//			trace(Button(ToggleGroup(e.currentTarget).selectedItem).data);
		}
		/**
		 *点击预设颜色 
		 */		
		private var seletionRect:int;
		private function paletteTouch(e:TouchEvent):void
		{
			changeColor(e.target.getPixel(e.localX,e.localY).toString(16).substr(2));
			seletionRect=_preinstallContainer.getChildIndex(e.target.parent);
			boo=true;
			trace(e.target);
//			trace(Button(e.target.parent).data)
			_group.select(Button(e.target.parent));
		}
		//文字
		private var _txt:Text;
		/**
		 * 文本框
		 */		
		private function txtL():void
		{
			for(var i:int=0;i<4;i++)
			{
				_txt=new Text("",null,80,30,_textFormat2);
				_txt.renderType=RenderType.IMMEDIATELY;
				addChild(_txt);
				_txt.x=276;
				_txt.y=(_txt.height+7)*i+205;
				if(i==3)
				{
					_txt.width=100;
					_txt.x=276;
					_txt.y=165;
				}
				_txtList.push(_txt);
			}
			_txtList[0].text="R:"+255;
			_txtList[1].text="G:"+255;
			_txtList[2].text="B:"+255;
			_txtList[3].text="0Xffffff";
		}
		private var _colorRect:Image;//大色块
		private var _colorBar:Image;//色条
		private var _colorThumbnail:Image;//缩略图
		private var _ThumbnailContainer:Container;//缩略图的容器（小色块）
		private var _rectContainer:Container;//大眼色块的容器
		private var _barContainer:Container;//颜色条的容器
		
		protected function createChildren():void
		{
			//bar
			_barContainer=new Container();
			_barContainer.x=5;
			_barContainer.y=275;
			this.addChild(_barContainer);
			
			_colorBarBg=new Bitmap();
			_colorBarBg.skin=new BitmapSkin("buttonUp.png","5,5,5,5");
			_colorBarBg.width=267;
			_colorBarBg.height=32;
			_barContainer.addChild(_colorBarBg);
			_colorBar=new Image(null);
			_barContainer.addChild(_colorBar);
			
			//rect
			_rectContainer=new Container();
			this.addChild(_rectContainer);
			
			_colorRectBg=new Bitmap();
			_colorRectBg.x=_colorRectBg.y=5;
			_colorRectBg.skin=new BitmapSkin("buttonUp.png","5,5,5,5");
			_colorRectBg.width=267;
			_colorRectBg.height=268;
			_rectContainer.addChild(_colorRectBg);
			_colorRect=new Image(null);
			_rectContainer.addChild(_colorRect);
			
			//Thumbnail缩略图
			_ThumbnailContainer=new Container();
			_ThumbnailContainer.x=377;
			_ThumbnailContainer.y=174;
			this.addChild(_ThumbnailContainer);
			
			_colorThumbnailBg=new Bitmap();
			_colorThumbnailBg.skin=new BitmapSkin("buttonUp.png","5,5,5,5");
			_colorThumbnailBg.width=87;
			_colorThumbnailBg.height=38;
			_colorThumbnailBg.x=-5;
			_colorThumbnailBg.y=-5;
			_ThumbnailContainer.addChild(_colorThumbnailBg);
			_colorThumbnail=ssp(0xffffff);
			_ThumbnailContainer.addChild(_colorThumbnail);
			
			//大色块的容器
			rectSp=new DisplayObjectContainer();
			rectSp.x=rectSp.y=10;
			_rectContainer.addChild(rectSp);
			
			//小色块的容器
			imgsp=new Container();
			_ThumbnailContainer.addChild(imgsp);
			
			//实例化大色块类
			color_rect=drawLine("000000");
			color_rect.y=-1;
			rectSp.addChild(color_rect);
			rectSp.addEventListener(TouchEvent.TOUCH_BEGIN,onBegin1);
			rectSp.addEventListener(TouchEvent.TOUCH_END,onEnd1);
			rectSp.addEventListener(TouchEvent.TOUCH_MOVE,onMove1);
			
			//实例化色条类
			color_Bar=new DisplayObjectContainer();
			_barContainer.addChild(color_Bar);
			color_Bar.addChild(saturability());
			color_Bar.addEventListener(TouchEvent.TOUCH_BEGIN,onBegin);
			color_Bar.addEventListener(TouchEvent.TOUCH_END,onEnd);
			color_Bar.addEventListener(TouchEvent.TOUCH_MOVE,onMove);
			//实例化小色块
			imgsp.addChild(_colorThumbnail);
			
			circ=cir();//大色块的去色点
			circ.x=circ.y=-7;
			circ.mouseEnabled=false;
			rectSp.addChild(circ);
			
			//色条上的滑块
			rectSlider=rect();
			rectSlider.x=3;
			rectSlider.y=270;
			rectSlider.mouseEnabled=false;
			addChild(rectSlider);
			
			//预设色板容器
			_preinstallContainer=new DisplayObjectContainer();
			_preinstallContainer.x=270;
			_preinstallContainer.y=10;
			addChild(_preinstallContainer);
			_paletteBg=new Bitmap();
			_paletteBg.x=5;
			_paletteBg.y=-5;
			_paletteBg.width=185;
			_paletteBg.height=156;
			_paletteBg.skin=new BitmapSkin("buttonUp.png","5,5,5,5");
			_paletteBg.mouseEnabled=false;
			_preinstallContainer.addChild(_paletteBg);
			
			palette();//色板
			
			_confirmBtn=new Button([new BitmapSkin("buttonUp.png","5,5,5,5"),new BitmapSkin("buttonDown.png","5,5,5,5")]
				,"确  定",115,45,_textFormat);//确定按钮
			_confirmBtn.x=345;
			_confirmBtn.y=262;
			addChild(_confirmBtn);
			_confirmBtn.addEventListener(TouchEvent.TOUCH_END,conBtnEnd);
			
			_paletteBtn=new Button([new BitmapSkin("buttonUp.png","5,5,5,5"),new BitmapSkin("buttonDown.png","5,5,5,5")]
				,"保存预设",115,45,_textFormat);//保存预设按钮
			_paletteBtn.x=345;
			_paletteBtn.y=212;
			addChild(_paletteBtn);
			_paletteBtn.addEventListener(TouchEvent.TOUCH_END,paleBtnEnd);
			
			txtL();
			changeColor(_selectionColor);
			
		}
		private var imgsp:DisplayObjectContainer;//小色块的容器
		private var color_Bar:DisplayObjectContainer;
		private var color_rect:DisplayObjectContainer;
		private var rectSp:DisplayObjectContainer;
		private var rectcolor:String;
		private var circ:Bitmap;
		private var rectSlider:Bitmap;
		/**
		 *取色点 
		 */		
		private function cir():Bitmap
		{
			var cir:Bitmap=new Bitmap(new BitmapSkin("circle.png"),15,15);
			return cir;
		}
		/**
		 * 色条上的滑块
		 */		
		private function rect():Bitmap
		{
			var slider:Bitmap=new Bitmap(new BitmapSkin("arrow.png"),15,15);
			return slider;
		}
		/**
		 *在大色块上的移动，按下，抬起 
		 */		
		private function onEnd1(e:TouchEvent):void
		{
			rectcolor=(colorRectSp.getPixel(circ.x+7,circ.y+7).toString(16)).substr(2);
			changeColor(rectcolor);
		}
		private function onBegin1(e:TouchEvent):void
		{   
			
			circ.x=globalToLocal(new Point(e.stageX,e.stageY)).x-17;
			circ.y=globalToLocal(new Point(e.stageX,e.stageY)).y-17;
			if(circ.x>247)
			{
				circ.x=247;
			}
			if(circ.x<-6)
			{
				circ.x=-6;
			}
			if(circ.y>248)
			{
				circ.y=248;
			}
			if(circ.y<-6)
			{
				circ.y=-6;
			}
			rectcolor=(colorRectSp.getPixel(circ.x+7,circ.y+7).toString(16)).substr(2);
			changeColor(rectcolor);
		}
		
		private function onMove1(e:TouchEvent):void
		{
			circ.x=globalToLocal(new Point(e.stageX,e.stageY)).x-17;
			circ.y=globalToLocal(new Point(e.stageX,e.stageY)).y-17;
			if(circ.x>247)
			{
				circ.x=247;
			}
			if(circ.x<-6)
			{
				circ.x=-6;
			}
			if(circ.y>248)
			{
				circ.y=248;
			}
			if(circ.y<-6)
			{
				circ.y=-6;
			}
			rectcolor=(colorRectSp.getPixel(circ.x+7,circ.y+7).toString(16)).substr(2);
			changeColor(rectcolor);
		}
		//取到色条颜色的值有变化，大色块变化，大色块变化，小色块也变化
		private function onBar():void
		{ 
			rectSp.setChildIndex(circ,rectSp.numChildren-1);
			color_rect=drawLine(barcolor);
			rectSp.addChild(color_rect);
			changeColor((rectSp.getPixel(circ.x+7,circ.y+7).toString(16)).substr(2));
		}
		/**
		 *改变小方块颜色
		 * @param str最终选取的颜色
		 * 
		 */	
		private function changeColor(str:String):void
		{
			_selectionColor=str;
			if(str.length>=8)
			{
				str=str.substr(2);
			}
			rectSp.setChildIndex(circ,rectSp.numChildren-1);//将小方块置顶
			if(imgsp.numChildren>0)
			{
				imgsp.removeChildAt(0);
			}
			imgsp.addChild(ssp(parseInt(str,16)));
			
			_txtList[0].text="R:"+parseInt(num1(str,0),16);
			_txtList[1].text="G:"+parseInt(num1(str,2),16);
			_txtList[2].text="B:"+parseInt(num1(str,4),16);
			_txtList[3].text="0x"+str;
		}
		/**
		 * 截取颜色值的方法
		 */		
		private function num1(n:String,index:uint=2):String
		{
			var str:String=n.substr(index,2);
			return str;
		}
		//色块的参数
		private var td2:TextureData;
		private var colorImg1:Image;
		private var mat:Matrix=new Matrix();
		private var cc:String;//左边颜色
		private var dd:String;//右边颜色
		private var c16:String;
		private var colorRectSp:DisplayObjectContainer=new DisplayObjectContainer();
		//左上角的颜色
		private var r:int=256;
		private var g:int=256;
		private var b:int=256;
		
		//右上角的颜色
		private var myR:Number=0;
		private var myG:Number=0;
		private var myB:Number=0;
		
		//加0的r、g、b
		private var r0:String;
		private var g0:String;
		private var b0:String;
		
		//加0的myR,myG,myB
		private var myR0:String;
		private var myG0:String;
		private var myB0:String;
		
		//递减的值
		private var djR:Number;
		private var djG:Number;
		private var djB:Number;
		/**
		 *大色块 
		 */	
		private function drawLine(c:String):DisplayObjectContainer
		{
			r=256;
			g=256;
			b=256;
			c16=c;
			myR=parseInt(c16.substr(0,2),16);
			myG=parseInt(c16.substr(2,2),16);
			myB=parseInt(c16.substr(4,2),16);
			djR=myR/255;
			djG=myG/255;
			djB=myB/255;
			mat.createGradientBox(252,255);
			for(var i:int=0;i<257;i++)
			{
				var sp:Shape=new Shape();
				sp.graphics.lineGradientStyle(1,Graphics.GRADIENT_LINEAR,[parseInt(cc,16),parseInt(dd,16)],[1,1],[0,255],mat);
				sp.graphics.moveTo(0,0);
				sp.graphics.lineTo(255,0);
				sp.graphics.endFill();
				var td:TextureData=TextureData.createRGB(255,1,true,0x000000);
				td.draw(sp);
				var img2:Image=new Image(new Texture(td));
				img2.y=i;
				colorRectSp.addChild(img2);
				myR-=djR;
				myG-=djG;
				myB-=djB;
				if(myR<=0)
				{
					myR=0;
				}
				if(myG<=0)
				{
					myG=0;
				}
				if(myB<=0)
				{
					myB=0;
				}
				r--;
				b--;
				g--;
				if(r<=0)
				{
					r=0;
				}
				if(g<=0)
				{
					g=0;
				}
				if(b<=0)
				{
					b=0;
				}
				r0=r.toString(16);
				g0=g.toString(16);
				b0=b.toString(16);
				
				if(r0.length<2)
				{
					r0=0+r0;
				}
				if(g0.length<2)
				{
					g0=0+g0;
				}
				if(b0.length<2)
				{
					b0=0+b0;
				}
				
				cc=r0+g0+b0;//从白到黑
				
				myR0=myR.toString(16);
				myG0=myG.toString(16);
				myB0=myB.toString(16);
				
				if(myR0.length<2)
				{
					myR0=0+myR0;
				}
				if(myG0.length<2)
				{
					myG0=0+myG0;
				}
				if(myB0.length<2)
				{
					myB0=0+myB0;
				}
				dd=myR0+myG0+myB0;
				if(colorRectSp.numChildren>256)
				{
					colorRectSp.removeChildAt(0);
				}
			}
			return colorRectSp;
		}
		//色条的参数
		private var img:Image;
		private var td:TextureData;
		private var alphas:Array = [1,1,1,1,1,1,1];
		private var colors:Array = [0xff0000,0xff00ff,0x0000ff,0x00ffff,0x00ff00,0xffff00,0xff0000];
		private var ratios:Array = [0,56,92,128,164,200,236,255];
		private var matrix:Matrix=new Matrix();
		private var barcolor:String;
		/**
		 *饱和度色条 
		 */	
		private function saturability():Image
		{
			matrix.createGradientBox (255,20) ;//在这里设置填充的宽高
			var sp:Shape=new Shape();
			sp.graphics.beginGradientFill(Graphics.GRADIENT_LINEAR,colors, alphas,ratios,matrix);
			sp.graphics.drawRect(0,0,255,20);
			sp.graphics.endFill();
			td=TextureData.createRGB(255,20);
			td.draw(sp);
			img=new Image(new Texture(td));
			img.y=5;
			img.x=5;
			return img;
		}
		/**
		 *在色条上移动，按下，抬起函数
		 */		
		private function onMove(e:TouchEvent):void
		{
			
			rectSlider.x=globalToLocal(new Point(e.stageX,e.stageY)).x-7;
			if(rectSlider.x>257)
			{
				rectSlider.x=257;
			}
			if(rectSlider.x<3)
			{
				rectSlider.x=3;
			}
			barcolor=num(td.getPixel(rectSlider.x-3,0).toString(16));
			onBar();
		}
		private function onEnd(e:TouchEvent):void
		{
			rectSlider.x=globalToLocal(new Point(e.stageX,e.stageY)).x-7;
			if(rectSlider.x>257)
			{
				rectSlider.x=257;
			}
			if(rectSlider.x<3)
			{
				rectSlider.x=3;
			}
			barcolor=num(td.getPixel(rectSlider.x-3,0).toString(16));
			onBar();
		}
		private function onBegin(e:TouchEvent):void
		{
			rectSlider.x=globalToLocal(new Point(e.stageX,e.stageY)).x-7;
		}
		/**
		 *截取颜色值的方法 
		 * @param n
		 * @return 
		 */		
		private function num(n:String):String
		{
			var str:String=n.substr(2);
			return str;
		}
		
		/**
		 *小色块
		 */		
		private function ssp(c:uint=0xff0000):Image
		{
			var td1:TextureData=TextureData.createRGB(75,25,false,c);
			var im:Image=new Image(new Texture(td1));
			return im;
		}
		
		/**
		 * 释放资源 
		 * 
		 */
		override public function dispose():void{
			super.dispose();
			RenderManager.dispose(this);
			
			if(rectSlider)
			{
				this.removeChild(rectSlider);
				rectSlider.dispose();
				rectSlider=null;
			}
			
			if(_preinstallContainer)
			{
				for(var i:int=0;i<_preinstallContainer.numChildren;i++)
				{
					_preinstallContainer.removeChild(_preinstallContainer.getChildAt(i));
				}
				this.removeChild(_preinstallContainer);
				_preinstallContainer.dispose();
				_preinstallContainer=null;
			}
			if(_rectContainer)
			{
				if(rectSp)
				{
					if(color_rect)
					{
						rectSp.removeChild(color_rect);
						color_rect.dispose();
						color_rect=null;
					}
					if(circ)
					{
						rectSp.removeChild(circ);
						circ.dispose();
						circ=null;
					}
					rectSp.removeEventListener(TouchEvent.TOUCH_BEGIN,onBegin1);
					rectSp.removeEventListener(TouchEvent.TOUCH_END,onEnd1);
					rectSp.removeEventListener(TouchEvent.TOUCH_MOVE,onMove1);
					_rectContainer.removeChild(rectSp);
					rectSp.dispose();
					rectSp=null;
				}
				if(_colorRectBg)
				{
					_rectContainer.addChild(_colorRectBg);
					_colorRectBg.dispose();
					_colorRectBg=null;
				}
				this.removeChild(_rectContainer);
				_rectContainer.dispose();
				_rectContainer=null;
			}
			if(_ThumbnailContainer)
			{
				if(imgsp)
				{
					_ThumbnailContainer.removeChild(imgsp);
					imgsp.dispose();
					imgsp=null;
				}
				if(_colorThumbnailBg)
				{
					_ThumbnailContainer.removeChild(_colorThumbnailBg);
					_colorThumbnailBg.dispose();
					_colorThumbnailBg=null;
				}
				
				this.removeChild(_ThumbnailContainer);
				_ThumbnailContainer.dispose();
				_ThumbnailContainer=null;
			}
			if(_barContainer)
			{
				if(color_Bar)
				{
					color_Bar.removeEventListener(TouchEvent.TOUCH_BEGIN,onBegin);
					color_Bar.removeEventListener(TouchEvent.TOUCH_END,onEnd);
					color_Bar.removeEventListener(TouchEvent.TOUCH_MOVE,onMove);
					_barContainer.removeChild(color_Bar);
					color_Bar.dispose();
					color_Bar=null;
				}
				if(_colorBarBg)
				{
					_barContainer.addChild(_colorBarBg);
					_colorBarBg.dispose();
					_colorBarBg=null;
				}
				this.removeChild(_barContainer);
				_barContainer.dispose();
				_barContainer=null;
			}
			if(_paletteBtn)
			{
				_paletteBtn.removeEventListener(TouchEvent.TOUCH_END,paleBtnEnd);
				this.removeChild(_paletteBtn);
				_paletteBtn.dispose();
				_paletteBtn=null;
			}
			if(_confirmBtn)
			{
				_confirmBtn.addEventListener(TouchEvent.TOUCH_END,conBtnEnd);
				this.removeChild(_confirmBtn);
				_confirmBtn.dispose();
				_confirmBtn=null;
			}
			_paletteColorBtnList=null;
			_txtList=null;
		}
	}
}