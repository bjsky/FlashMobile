package potato.editor.fileBox
{
	import core.display.DisplayObject;
	
	import potato.component.Container;
	import potato.component.List;
	
	/**
	 * 建议高度为FileBoxItemRenderBig.SIZEH 和FileBoxItemRenderSmall.SIZEH 的公约数<br>
	 * 建议宽度为FileBoxItemRenderBig.SIZEH 和FileBoxItemRenderSmall.SIZEW 的公约数
	 */
	
	public class FileBoxList extends List
	{
		public var item0:Container;// item实例
		public var numC:int;// item数量
		public var iw:Number;// item宽
		public var ih:Number;// item高
		public const gap:int=5;// 间距
		public var numRow:int;// 列数目
		public var numLine:int;// 行数目
		public function FileBoxList(dataSource:Object=null, itemRender:Class=null, width:Number=NaN, height:Number=NaN)
		{
			super(dataSource, itemRender, width, height);
		}
		/**
		 * 必要时，制定list的显示范围，如果不理想建议调整list的尺寸
		 */
		public function setY():void
		{
			contentHeight=(ih+gap)*numLine;
			if(this.selectIndex==-1)
			{
				this.scrollY=0;
			}else
			{
				var ii:int=(this.selectIndex/numRow);
				var temp:int=(ih+gap)*ii;
				if(temp<this.height)
				{
					this.scrollY=0;
				}else
				{
					this.scrollY=temp-this.height+(ih+gap);
				}
				
			}
		}
		override protected function render():void
		{
			super.render();
			//  实现想要的布局方式,根据自身和渲染器尺寸重新进行位置调整
			if(this.numChildren)
			{
				 item0=this.getChildAt(0)as Container;
				 numC=this.numChildren;
				 iw=item0.width;
				 ih=item0.height;
				 numRow=this.width/iw;// 列
				if(numRow==0)
				{
					numRow=1;
				}
				numLine=numC/numRow;// 行
				if(numC%numRow)
				{
					numLine++;
				}
//				trace("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
//				trace("total:"+this.numChildren);
//				trace("iw:"+iw);
//				trace("ih:"+ih);
//				trace("numRow:"+numRow);
//				trace("numLine:"+numLine);
//				trace(")))))))))))))))))))))))))))))))))))))");
				for(var i:int=0;i<=numLine;i++)
				{
					for(var j:int=0;j<=numRow;j++)
					{
						if(i*numRow+j<numC)
						{
							var item:DisplayObject=this.getChildAt(i*numRow+j);
							item.x=(iw+gap)*j;
							item.y=(ih+gap)*i;
						}
					}
				}
				
			}else
			{
				numC=0;
				iw=0;
				ih=0;
				numRow=0;
				numLine=0;
			}
		}
	}
}