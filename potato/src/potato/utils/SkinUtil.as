package potato.utils
{
	import potato.component.data.BitmapSkin;

	public class SkinUtil
	{
		public function SkinUtil()
		{
		}
		
		/**
		 * 用字符串填充数组，并返回数组副本
		 * @param arr 要填充的数组
		 * @param str 源字符串
		 * @param type 数组数据类型
		 * @return 
		 * 
		 */
		public static function fillArray(arr:Array, str:String, type:Class = null,separator:String=","):Array {
			var temp:Array = arr.slice();
			if (Boolean(str)) {
				var a:Array = str.split(separator);
				for (var i:int = 0, n:int = Math.min(temp.length, a.length); i < n; i++) {
					var value:String = a[i];
					temp[i] = (value == "true" ? true : (value == "false" ? false : value));
					if (type != null) {
						temp[i] = type(value);
					}
				}
			}
			return temp;
		}
		
		public static function fillSkins(arr:Array,skins:*,separator:String=","):Array{
			var temp:Array = arr.slice();
			if (Boolean(skins)) {
				if(skins is String)
					var a:Array = skins.split(separator);
				else if(skins is Array)
					a=skins.slice();
				for (var i:int = 0, n:int = Math.min(temp.length, a.length); i < n; i++) {
					var value:* = a[i];
					if (value is String) {
						temp[i] = new BitmapSkin(value);
					}else if(value is BitmapSkin){
						temp[i] = value;
					}
				}
			}
			return temp;
		}
		
	}
}