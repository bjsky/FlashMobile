package potato.editor
{
	import potato.component.data.BitmapSkin;

	/**
	 * 下拉框皮肤. 
	 * @author liuxin
	 * 
	 */
	public class ComboSkin
	{
		/**
		 * 下拉框皮肤 
		 * @param textSkin 文本框皮肤
		 * @param listSkin 列表皮肤
		 * @param listWidthAdjust 列表宽度调整
		 * @param buttonUpSkin 按妞正常皮肤
		 * @param buttonDownSkin 按钮按下皮肤
		 * @param buttonDisableSkin 按钮禁用皮肤
		 * @param buttonMarginTop 按钮上边距
		 * @param buttonMarginRight 按钮右边距
		 * 
		 */
		public function ComboSkin(textSkin:BitmapSkin=null,listSkin:BitmapSkin=null,listWidthAdjust:Number=NaN
								  ,buttonUpSkin:BitmapSkin=null,buttonDownSkin:BitmapSkin=null,buttonDisableSkin:BitmapSkin=null
								   ,buttonMarginTop:Number=NaN,buttonMarginRight:Number=NaN)
		{
			this.textSkin=textSkin;
			this.listSkin=listSkin;
			this.listWidthAdjust=listWidthAdjust;
			this.buttonUpSkin=buttonUpSkin;
			this.buttonDownSkin=buttonDownSkin;
			this.buttonDisableSkin=buttonDisableSkin;
			this.buttonMarginTop=buttonMarginTop;
			this.buttonMarginRight=buttonMarginRight;
		}
		
		private var _textSkin:BitmapSkin;
		private var _buttonUpSkin:BitmapSkin;
		private var _buttonDownSkin:BitmapSkin;
		private var _buttonDisableSkin:BitmapSkin;
		private var _listSkin:BitmapSkin;
		private var _itemSkin:BitmapSkin;
		private var _itemSelectSkin:BitmapSkin;
		private var _listWidthAdjust:Number;
		private var _buttonMarginRight:Number;
		private var _buttonMarginTop:Number;
		
		
		/**
		 * 按钮上边距 
		 * @return 
		 * 
		 */
		public function get buttonMarginTop():Number
		{
			return _buttonMarginTop;
		}

		public function set buttonMarginTop(value:Number):void
		{
			_buttonMarginTop = value;
		}

		/**
		 * 按钮右边距 
		 * @return 
		 * 
		 */
		public function get buttonMarginRight():Number
		{
			return _buttonMarginRight;
		}

		public function set buttonMarginRight(value:Number):void
		{
			_buttonMarginRight = value;
		}

		/**
		 * 列表宽度调整 
		 * @return 
		 * 
		 */
		public function get listWidthAdjust():Number
		{
			return _listWidthAdjust;
		}

		public function set listWidthAdjust(value:Number):void
		{
			_listWidthAdjust = value;
		}

		/**
		 * 列表项目选中皮肤 
		 * @return 
		 * 
		 */
		public function get itemSelectSkin():BitmapSkin
		{
			return _itemSelectSkin;
		}

		public function set itemSelectSkin(value:BitmapSkin):void
		{
			_itemSelectSkin = value;
		}

		/**
		 * 列表项目皮肤 
		 * @return 
		 * 
		 */
		public function get itemSkin():BitmapSkin
		{
			return _itemSkin;
		}

		public function set itemSkin(value:BitmapSkin):void
		{
			_itemSkin = value;
		}

		/**
		 * 列表皮肤 
		 * @return 
		 * 
		 */
		public function get listSkin():BitmapSkin
		{
			return _listSkin;
		}

		public function set listSkin(value:BitmapSkin):void
		{
			_listSkin = value;
		}

		/**
		 * 按钮按下皮肤 
		 * @return 
		 * 
		 */
		public function get buttonDownSkin():BitmapSkin
		{
			return _buttonDownSkin;
		}

		public function set buttonDownSkin(value:BitmapSkin):void
		{
			_buttonDownSkin = value;
		}

		/**
		 * 按钮正常皮肤  
		 * @return 
		 * 
		 */
		public function get buttonUpSkin():BitmapSkin
		{
			return _buttonUpSkin;
		}

		public function set buttonUpSkin(value:BitmapSkin):void
		{
			_buttonUpSkin = value;
		}

		/**
		 * 按钮禁用皮肤 
		 * @return 
		 * 
		 */
		public function get buttonDisableSkin():BitmapSkin
		{
			return _buttonDisableSkin;
		}
		
		public function set buttonDisableSkin(value:BitmapSkin):void
		{
			_buttonDisableSkin = value;
		}
		
		/**
		 * 文字皮肤 
		 * @return 
		 * 
		 */
		public function get textSkin():BitmapSkin
		{
			return _textSkin;
		}

		public function set textSkin(value:BitmapSkin):void
		{
			_textSkin = value;
		}

	}
}