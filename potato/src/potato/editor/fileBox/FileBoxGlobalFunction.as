package potato.editor.fileBox
{
	import potato.utils.Utils;

	public class FileBoxGlobalFunction
	{
		private static const REG_C:RegExp=/^[\u4E00-\u9FA5]+$/;
		
		// 如果最后一个字符是分割线，切掉最后一个分割线
		public static function clearLastSepatrator(str:String):String
		{
			var lIndex:int=str.lastIndexOf(FileBoxDefine.DIRECTORY_SEPATRATOR);
			
			while(lIndex+1==str.length&&str.length>0)// 如果最后一个字符是分割线，切掉最后一个分割线
			{
				str=str.substr(0,str.length-1);
				lIndex=str.lastIndexOf(FileBoxDefine.DIRECTORY_SEPATRATOR);
			}
			return str;
		}
		
		//如果最后一个字符不是分隔符, 补充一个分隔符到最后
		public static function addLastSepatrator(str:String):String
		{
			var lIndex:int = str.lastIndexOf(FileBoxDefine.DIRECTORY_SEPATRATOR);
			if (lIndex != str.length-1)
				str += FileBoxDefine.DIRECTORY_SEPATRATOR;
			return str;
		}
		
		/**
		 * 判断字符串内是否包含中文 
		 * @param str
		 * @return 
		 */		
		public static function hasCNCharacters(str:String):Boolean
		{
			for (var i:uint = 0; i < str.length; i++)
			{
				if (REG_C.test(str.charAt(i)))
					return true;
			}
			return false;
		}
		
		//判断路径是否为绝对路径
		public static function isAbsolutePath(path:String):Boolean
		{
			//windows操作系统判断是否 盘符开头
			if ((Utils.platformVer() <= Utils.PV_WIN))
			{
				var rootPathArr:Array = Utils.getPCLetters();
				for each (var rootPath:String in rootPathArr)
				{
					if (path.indexOf(rootPath) >=0)
						return true;
				}
			}
			
			//linux操作系统判断是否/开头
			return path.indexOf(FileBoxDefine.DIRECTORY_SEPATRATOR) == 0;
		}
		
		/**
		 * 清理冗余路径表示
		 */
		public static function clearPath(path:String):String
		{
			if(/.+\/.+\/\.\.$/.test(path))// 匹配a/b/..结尾后修改为a
			{
				path=path.replace(/\/.+\/\.\.$/,'');
			}
			else if(/^\S+\/\.\.\/S+/.test(path))// 匹配a/../b开头（如何用正则一步到位？）
			{
				var tempArr:Array=path.split("//");
				if(tempArr[0]==tempArr[2])// 如果是a/../a,截去a/../
				{
					path=path.replace(/^\w+\/\.\./,'');
				}
			}else if(/.+\/\.$/.test(path))// 如果选择了当前目录，截去最后斜线后的内容
			{
				path=path.replace(/\/\.$/,'');
			}else if(/^.+\/\.\.$/.test(path))// 如果是abc/..结尾
			{
				path=".";
			}else if(/^.\//.test(path))// 如果是./abc开头的，简化为abc开头
			{
				path=path.replace(/^.\//,'');
			}
			return path;
		}
		
		/**
		 * 查找path对应的根目录路径
		 * @param path
		 * @return 
		 */		
		public static function getRootPath(path:String):String
		{
			var rootPathArr:Array = FileBoxDefine.ROOT_PATH_ARR;
			for (var i:uint = 0; i < rootPathArr.length; i++)
			{
				var rootPath:String = rootPathArr[i];
				if (path.indexOf(rootPath) == 0)
					return rootPath;
			}
			return "";
		}
		
	}
}