package potato.editor.fileBox
{
	import potato.utils.Utils;

	public class FileBoxDefine
	{
		public static const IMAGE_REG:RegExp = /^[\d|\w|_]+\.(?:png|jpg|bmp)$/;// 字母下划线数字
		public static const REPLACE_REG:RegExp = new RegExp("\\");
		public static const DIRECTORY_SEPATRATOR:String = "/";
		public static const ROOT_PATH:String="/";
		public static const ROOT_PATH_ARR:Array = Utils.getExistsLetters();
	}
}