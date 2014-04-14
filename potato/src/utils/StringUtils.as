package potato.utils
{
	public class StringUtils
	{
		public function StringUtils()
		{	
		}
		/**用字符串填充数组，并返回数组副本*/
		public static function fillArray(arr:Array, str:String, type:Class = null):Array {
			var temp:Array = arr.slice();
			if (Boolean(str)) {
				var a:Array = str.split(",");
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
	}
}