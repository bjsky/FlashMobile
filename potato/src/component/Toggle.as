package potato.component
{
	import flash.utils.Dictionary;
	
	import core.display.Image;
	import core.display.Texture;
	import core.events.Event;
	
	import potato.component.data.BitmapSkin;
	import potato.event.GestureEvent;
	import potato.event.UIEvent;
	import potato.gesture.TapGesture;
	import potato.resource.ResourceManager;
	import potato.utils.Filters;
	import potato.utils.StringUtil;
	
	/**
	 * 开关按钮，单独的Toggle可以是on/off，带标签的toggle是checkbox，带单选组的toggle是radioGroup,带多选组的toggle是checkboxGroup
	 * @author liuxin
	 * 
	 */
	public class Toggle extends Image 
		implements ISprite,IGroupItem
	{
		public function Toggle(skins:String="",selected:Boolean=false)
		{
			super(null);
			_tap=new TapGesture(this);
			_tap.addEventListener(GestureEvent.TAP,ontap);
			
			this.$skins=skins;
			this.$selected=selected;
			render();
		}
		
		public function setSkins(offSkin:BitmapSkin=null,onSkin:BitmapSkin=null,disableOffSkin:BitmapSkin=null
								 ,disableOnSkin:BitmapSkin=null):void{
			this.$offSkin=offSkin;
			this.$onSkin=onSkin;
			this.$disableOffSkin=disableOffSkin;
			this.$disableOnSkin=disableOnSkin;
			this.render();
		}
		/**
		 * 关闭 
		 */
		static private const OFF:uint=0;			
		/**
		 * 打开
		 */
		static private const ON:uint=1;
		/**
		 * 禁用 关闭 
		 */
		static private const DISABLE_OFF:uint=2;
		/**
		 * 禁用 打开
		 */
		static private const DISABLE_ON:uint=3;
		
		//----------------------------
		//	ISprite
		//----------------------------
		protected var _width:Number;
		protected var _height:Number;
		protected var _scale:Number;
		
		/**
		 * 宽度
		 * @param value
		 * 
		 */
		public function set width(value:Number):void{
			$width=value;
			render();
		}
		override public function get width():Number{
			if(!isNaN(_width))
				return _width;
			else
				return super.width;
		}
		public function set $width(value:Number):void{
			_width=value;
		}
		/**
		 * 高度 
		 * @param value
		 * 
		 */
		public function set height(value:Number):void{
			$height=value;
			render();
		}
		override public function get height():Number{
			if(!isNaN(_height))
				return _height;
			else
				return super.height;
		}
		public function set $height(value:Number):void{
			_height=value; 
		}
		/**
		 * 缩放 
		 * @param value
		 * 
		 */
		public function set scale(value:Number):void{
			_scale=value;
			scaleX=scaleY=_scale;
		}
		public function get scale():Number{
			return _scale;
		}
		
		//---------------------------
		// IGroupItem
		//--------------------------
		private var _data:Object;
		private var _selected:Boolean;
		private var _disable:Boolean;
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			$selected=value;
			if(!_disable){
				render();
			}
		}
		public function set $selected(value:Boolean):void{
			_selected = value;
		}
		
		public function get disable():Boolean
		{
			return _disable;
		}
		
		public function set disable(value:Boolean):void
		{
			$disable=value;
			render();
		}
		public function set $disable(value:Boolean):void{
			_disable = value;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		
		//-----------------------------
		//	property
		//----------------------------
		private var _skins:String;
		private var _state:uint=OFF;
		/**
		 * 禁用关闭皮肤 
		 * @return 
		 * 
		 */
		public function get disableOffSkin():BitmapSkin
		{
			return _skinsMap[DISABLE_OFF];
		}
		
		public function set disableOffSkin(value:BitmapSkin):void
		{
			$disableOffSkin=value;
			render();
		}
		public function set $disableOffSkin(value:BitmapSkin):void{
			_skinsMap[DISABLE_OFF] = value;
		}
		
		/**
		 * 禁用打开皮肤 
		 * @return 
		 * 
		 */
		public function get disableOnSkin():BitmapSkin
		{
			return _skinsMap[DISABLE_ON];
		}
		
		public function set disableOnSkin(value:BitmapSkin):void
		{
			$disableOnSkin=value;
			render();
		}
		public function set $disableOnSkin(value:BitmapSkin):void{
			_skinsMap[DISABLE_ON] = value;
		}
		
		/**
		 * 关闭皮肤 
		 * @return 
		 * 
		 */
		public function get offSkin():BitmapSkin
		{
			return _skinsMap[OFF];
		}
		
		public function set offSkin(value:BitmapSkin):void
		{
			$offSkin=value;
			render();
		}
		public function set $offSkin(value:BitmapSkin):void{
			_skinsMap[OFF] = value;
		}
		
		/**
		 * 打开皮肤 
		 * @return 
		 * 
		 */
		public function get onSkin():BitmapSkin
		{
			return _skinsMap[ON];
		}
		
		public function set onSkin(value:BitmapSkin):void
		{
			$onSkin=value;
			render();
		}
		public function set $onSkin(value:BitmapSkin):void{
			_skinsMap[ON] = value;
		}
		
		/**
		 * 皮肤 
		 * @return 
		 * 
		 */
		public function get skins():String
		{
			return _skins;
		}
		
		public function set skins(value:String):void
		{
			$skins = value;
			render();
		}
		public function set $skins(value:String):void{
			_skins=value;	
			_skinsArr=StringUtil.fillArray(_skinsArr,value,String);
			for (var i:int=0;i<_skinsArr.length;i++){
				var skinStr:String=_skinsArr[i];
				if(skinStr){
					var bSkin:BitmapSkin=new BitmapSkin();
					bSkin.textureName=skinStr;
					_skinsMap[i]=bSkin;
				}
			}
		}
		
		private function ontap(e:Event):void{
			this.selected=!selected;
			dispatchEvent(new UIEvent(UIEvent.TOGGLE_SELECT_CHANGE));
		}
		
		//------------------------------
		//	
		//------------------------------
		private var _skinsArr:Array=["","",""];
		private var _skinsMap:Dictionary=new Dictionary();
		private var _tap:TapGesture;
		
		private function set imageSkin(value:BitmapSkin):void{
			texture=null;
			var tex:Texture;
			if(value){
				if(value.textureData)
					tex=new Texture(value.textureData);
				else if(value.textureName)
					tex=ResourceManager.getTextrue(value.textureName);
			}
			if(!tex)
				return;
			texture=tex;
		}
		
		private function set imageFilter(value:Boolean):void{
			this.filter=value?Filters.FILTER_IMG_GRAY:null;
		}
		
		public function render():void
		{
			if(!offSkin) return;
			
			if(_selected){
				_state=_disable?DISABLE_ON:ON;
			}else{
				_state=_disable?DISABLE_OFF:OFF;	
			}
			var skin:BitmapSkin=_skinsMap[_state];
			if(_disable){		//禁用
				if(skin){
					this.imageSkin=skin;		//存在禁用皮肤
					this.imageFilter=false;
				}else{
					this.imageSkin=_skinsMap[OFF]; //不存在禁用皮肤取正常变灰
					this.imageFilter=true;
				}
			}else{
				this.imageFilter=false;
				this.imageSkin=skin?skin:_skinsMap[OFF];	//不存在取正常
			}
		}
		
		override public function dispose():void{
			super.dispose();
			if(_tap){
				_tap.removeEventListener(GestureEvent.TAP,ontap);
				_tap.dispose();
				_tap=null;
			}
			texture=null;
		}
	}
}