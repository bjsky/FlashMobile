package potato.component
{
	import core.display.Shape;
	import core.display.Texture;
	import core.display.TextureData;
	
	import potato.component.data.Padding;
	
	
	/**
	 * 滚动条.
	 * <p>可以设置方向为垂直或者水平。</p>
	 * <p>如果设置宽高，则滚动条使用设置的宽高。否则根据滚动条的方向，水平滚动条宽使用默认宽度，高度依据路径皮肤的高度，垂直滚动条高度使用默认高度，宽度依据路径皮肤的高度</p>
	 * <p>可以设置滚动条的滑块比例和滑块位置，位置为百分比，值域为[0,1]</p> 
	 * @author liuxin
	 * 
	 */
	public class Scroller extends Slider
	{
		/**
		 * 创建滚动条 
		 * @param skins 皮肤
		 * @param direction 方向
		 * @param width 宽
		 * @param height 高
		 * @param thumbRatio 滑块大小
		 * @param val 刻度值
		 * 
		 */
		public function Scroller(skins:String="",direction:String="vertical",width:Number=NaN,height:Number=NaN,val:Number=0,barPadding:Padding=null,thumbRatio:Number=0.5)
		{
			super(skins,direction,width,height,val,barPadding);
			
			this.thumbRatio=thumbRatio;
		}
		private var _thumbRatio:Number=0.5;
		
		/**
		 * 按钮大小比率，从0到1；
		 * @param value
		 * 
		 */		
		public function set thumbRatio(value:Number):void{
			_thumbRatio=value;
			if(_thumbRatio>1)
				_thumbRatio=1;
			if(_thumbRatio<0)
				_thumbRatio=0;
			invalidate(render);
		}
		public function get thumbRatio():Number{
			return _thumbRatio;
		}
		
		override protected function renderThumb():void{
			var tw:Number=width-(thumbPadding?thumbPadding.paddingLeft+thumbPadding.paddingRight:0);
			var th:Number=height-(thumbPadding?thumbPadding.paddingTop+thumbPadding.paddingBottom:0)
				
			//滑块
			if(direction==HORIZONTAL){
				_thumb.width=thumbRatio*tw;
				_thumb.height=th;
			}else{
				_thumb.height=thumbRatio*th;
				_thumb.width=tw;
			}
			if(thumbSkin){
				_thumb.skin=thumbSkin;
				_thumb.alpha=1;
			}else{
				var thutd:TextureData=TextureData.createRGB(_thumb.width,_thumb.height);
				var thuSha:Shape=new Shape();
				thuSha.graphics.beginFill(0x333333);
				thuSha.graphics.drawRect(0,0,_thumb.width,_thumb.height);
				thuSha.graphics.endFill();
				thutd.draw(thuSha);
				_thumb.texture=new Texture(thutd);
				_thumb.alpha=0.67;
			}

		}
	}
}