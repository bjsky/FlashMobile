package potato.utils
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import core.filesystem.File;
	import core.system.Capabilities;

	public class Utils
	{
		public function Utils()
		{
		}
		public static var testPVR:Boolean = false;
		
		///////////// 配置文件里可用的文件路径常量 ///////////////
		private static const COMMON:RegExp = /@common/g;			//通用资源的文件夹，会被替换为 common
		private static const LANGUAGE:RegExp = /@language/g;		//语言地区，会被替换为 -l 参数传入的值
		private static const RESOURCE:RegExp = /@resource/g;		//资源格式，会被替换为 pvr, dxt, atc, png 中的一个

		public static const PV_DEV:int = 0;
		public static const PV_WIN:int = 1; //avm
		public static const PV_IPAD:int = 2; //iPad
		public static const PV_IPHONE:int = 3; //iPhone
		public static const PV_ANDROID:int = 4;
		
		public static const IPA_IPAD:int = 5;//appstore ipad                51   appstore免费
		public static const IPA_IPHONE:int = 6;//appstore iphone            61   appstore免费
		
		
		public static const UC_IPAD:int=7;//UC  ipad
		public static const UC_IPHONE:int=8;//UC  iphone 
		public static const UC_ANDROID:int=9;//UC android
		
		public static const DJ_IPAD:int=10;//当乐  ipad
		public static const DJ_IPHONE:int=11;//当乐  iphone 
		public static const DJ_ANDROID:int=12;//当乐 android
		
		public static const PP_IPAD:int=13;//PP  ipad
		public static const PP_IPHONE:int=14;//PP  iphone 
		public static const PP_ANDROID:int=15;//PP android
		
		public static const MI_IPAD:int=16;//小米  ipad
		public static const MI_IPHONE:int=17;//小米  iphone 
		public static const MI_ANDROID:int=18;//小米 android
		
		public static const GFAN_IPAD:int=19;//机锋 ipad
		public static const GFAN_IPHONE:int=20;//机锋  iphone 
		public static const GFAN_ANDROID:int=21;//机锋 android
		
		public static const UUCUN_IPAD:int=22;//悠悠村 ipad
		public static const UUCUN_IPHONE:int=23;//悠悠村  iphone 
		public static const UUCUN_ANDROID:int=24;//悠悠村 android
		
		public static const MOBAGE_IPAD:int=25;//梦宝谷 ipad
		public static const MOBAGE_IPHONE:int=26;//梦宝谷  iphone 
		public static const MOBAGE_ANDROID:int=27;//梦宝谷 android
		
		public static const BAIDU_IPAD:int=28;//百度手机助手  ipad
		public static const BAIDU_IPHONE:int=29;//百度手机助手   iphone 
		public static const BAIDU_ANDROID:int=30;//百度 手机助手 android
		
		public static const BAIDUG_IPAD:int=31;//百度 游戏中心ipad
		public static const BAIDUG_IPHONE:int=32;//百度 游戏中心  iphone 
		public static const BAIDUG_ANDROID:int=33;//百度  游戏中心android
		
		public static const QIKE_IPAD:int=34;//7K  ipad
		public static const QIKE_IPHONE:int=35;//7K   iphone 
		public static const QIKE_ANDROID:int=36;//7K  android
		
		public static const QIHU_IPAD:int = 37 ; // 奇虎 360 ipad
		public static const QIHU_IPHONE:int = 38 ; // 奇虎 360 iphone
		public static const QIHU_ANDROID:int = 39 ; // 奇虎 360 android
		
		public static const WAN_37_ANDROID:int = 40;//37玩	android
		
		public static const BAIDUYUN_ANDROID:int = 43;//百度云	android
		
		public static const PPS_ANDROID:int = 46;//PPS	android
		
		public static const IPAFREE_IPAD:int = 51;//appstore ipad   免费
		
		public static const WDJ_IPAD:int = 52;     //豌豆荚   ipad
		public static const WDJ_IPHONE:int = 53;   //豌豆荚   iphone
		public static const WDJ_ANDROID:int = 54;  //豌豆荚  android
		
		public static const MZW_IPAD:int = 55;     //拇指玩   ipad
		public static const MZW_IPHONE:int = 56;   //拇指玩   iphone
		public static const MZW_ANDROID:int = 57;  //拇指玩  android
		
		public static const AZSC_IPAD:int = 58;     //安智市场   ipad
		public static const AZSC_IPHONE:int = 59;   //安智市场     iphone
		public static const AZSC_ANDROID:int = 60;  //安智市场   android
		
		public static const IPAFREE_IPHONE:int = 61;//appstore iphone  免费
		
		public static const LD_IPAD:int  = 62       //乐逗         ipad
		public static const LD_IPHONE:int  = 63     //乐逗         iphone
		public static const LD_ANDROID:int  = 64    //乐逗         android
		
		public static const YYH_IPAD:int  = 65       //应用汇         ipad
		public static const YYH_IPHONE:int  = 66     //应用汇          iphone
		public static const YYH_ANDROID:int  = 67    //应用汇          android
		
		public static const YXJD_IPAD:int  = 68      //游戏基地         ipad
		public static const YXJD_IPHONE:int  = 69     //游戏基地            iphone
		public static const YXJD_ANDROID:int  = 70    //游戏基地           android
		
		public static const WSD_IPAD:int  = 71       //沃商店         ipad
		public static const WSD_IPHONE:int  = 72     //沃商店            iphone
		public static const WSD_ANDROID:int  = 73    //沃商店           android
		
		public static const AYX_IPAD:int  = 74       //爱游戏            ipad
		public static const AYX_IPHONE:int  = 75     //爱游戏            iphone
		public static const AYX_ANDROID:int  = 76    //爱游戏           android
		
		public static const CMGE_IPAD:int  = 77       //中手游            ipad
		public static const CMGE_IPHONE:int  = 78     //中手游             iphone
		public static const CMGE_ANDROID:int  = 79    //中手游            android
		
		public static const ZSY_IPAD:int = 5001;     //中手游   appstroe   ipad
		public static const ZSY_IPHONE:int = 6001;    //中手游   appstroe   iphone
		
		public static const PPTV_IPAD:int  = 83       //pptv    ipad
		public static const PPTV_IPHONE:int  = 84     //pptv    iphone
		public static const PPTV_ANDROID:int  = 85    //pptv    android
		
		public static const PIPAW_IPAD:int  = 83       //琵琶网    ipad
		public static const PIPAW_IPHONE:int  = 84     //琵琶网    iphone
		public static const PIPAW_ANDROID:int  = 85    //琵琶网    android
		
		public static const YOUMI_IPAD:int  = 86       //有米   ipad
		public static const YOUMI_IPHONE:int  = 87     //有米    iphone
		public static const YOUMI_ANDROID:int  = 88    //有米    android
		
		public static const APP49_IPAD:int  = 89       //49app   ipad
		public static const APP49_IPHONE:int  = 90     //49app    iphone
		public static const APP49_ANDROID:int  = 91    //49app    android
		/**语言环境*/
		public static var DEFAULTLOCALE:String = Locale.getDefault().toString();
		
		/**
		 * 在路径不是以 / 开始时，使用的默认前缀
		 * @param path
		 * @return 
		 */		
		public static function getDefaultPath(path:String):String {
			path = StringUtil.trim(path);
			var s:String;
			if (path.indexOf("/") == 0) {
				s = path.substr(1);
			} else {
				s = DEFAULTLOCALE + "/" + Utils.getsupportResStr() + "/" + path;
			}
			return s;
		}
		
		private static var supportResStr:String;
		public static function getsupportResStr():String {
			if (supportResStr)
				return supportResStr;
			return "pc";
			if(Utils.PV_DEV == Utils.platformVer() || Utils.PV_WIN == Utils.platformVer())
			{
				return "pc";
			}
			
			if(File.exists("HD")){ //如果根目录中存在HD文件，表示使用png
				supportResStr = "png";
			}else{
				if (Capabilities.supportsPVRTC)
					supportResStr = "pvr";
				else if (Capabilities.supportsDXT3)
					supportResStr = "dxt";
				else if (Capabilities.supportsATC)
					supportResStr = "atc";
				else
					supportResStr = "png";
			}
			return supportResStr;
		}
		
		/**
		 * 获取平台版本 
		 * @return 
		 */
		private static var platver:int = -1;
		public static function platformVer():int {
			if (platver >= 0) return platver;
			var s:String = Capabilities.version.toLowerCase();
			if (StringUtil.beginsWith(s, "win"))
			{
				platver = PV_WIN;
			}
			else if (StringUtil.beginsWith(s, "nd:ipad"))
			{
				platver = PV_IPAD;
			}
			else if (StringUtil.beginsWith(s, "nd:iphone"))
			{
				platver = PV_IPHONE;
			}
			else if (StringUtil.beginsWith(s, "nd:android"))
			{
				platver = PV_ANDROID;
			}
			else if (StringUtil.beginsWith(s, "iap:iphone"))
			{
				platver = IPA_IPHONE;
			}
			else if (StringUtil.beginsWith(s, "iap:ipad"))
			{
				platver = IPA_IPAD;
			}
			else if (StringUtil.beginsWith(s, "iapfree:iphone"))
			{
				platver = IPAFREE_IPHONE;
			}
			else if (StringUtil.beginsWith(s, "iapfree:ipad"))
			{
				platver = IPAFREE_IPAD;
			}
			else if (StringUtil.beginsWith(s, "uc:ipad"))
			{
				platver = UC_IPAD;
			}
			else if (StringUtil.beginsWith(s, "uc:iphone"))
			{
				platver = UC_IPHONE;
			}
			else if (StringUtil.beginsWith(s, "uc:android"))
			{
				platver = UC_ANDROID;
			}
			else if (StringUtil.beginsWith(s, "dj:ipad"))
			{
				platver = DJ_IPAD;
			}
			else if (StringUtil.beginsWith(s, "dj:iphone"))
			{
				platver = DJ_IPHONE;
			}
			else if (StringUtil.beginsWith(s, "dj:android"))
			{
				platver = DJ_ANDROID;
			}
			else if (StringUtil.beginsWith(s, "pp:ipad"))
			{
				platver = PP_IPAD;
			}
			else if (StringUtil.beginsWith(s, "pp:iphone"))
			{
				platver = PP_IPHONE;
			}
			else if (StringUtil.beginsWith(s, "pp:android"))
			{
				platver = PP_ANDROID;
			}
			else if (StringUtil.beginsWith(s, "mi:ipad"))
			{
				platver = MI_IPAD;
			}
			else if (StringUtil.beginsWith(s, "mi:iphone"))
			{
				platver = MI_IPHONE;
			}
			else if (StringUtil.beginsWith(s, "mi:android"))
			{
				platver = MI_ANDROID;
			}
			else if (StringUtil.beginsWith(s, "gfan:ipad"))
			{
				platver = GFAN_IPAD;
			}
			else if (StringUtil.beginsWith(s, "gfan:iphone"))
			{
				platver = GFAN_IPHONE;
			}
			else if (StringUtil.beginsWith(s, "gfan:android"))
			{
				platver = GFAN_ANDROID;
			}
			else if (StringUtil.beginsWith(s, "uucun:ipad"))
			{
				platver = UUCUN_IPAD;
			}
			else if (StringUtil.beginsWith(s, "uucun:iphone"))
			{
				platver = UUCUN_IPHONE;
			}
			else if (StringUtil.beginsWith(s, "uucun:android"))
			{
				platver = UUCUN_ANDROID;
			}
			else if (StringUtil.beginsWith(s, "mobage:ipad"))
			{
				platver = MOBAGE_IPAD;
			}
			else if (StringUtil.beginsWith(s, "mobage:iphone"))
			{
				platver = MOBAGE_IPHONE;
			}
			else if (StringUtil.beginsWith(s, "mobage:android"))
			{
				platver = MOBAGE_ANDROID;
			}
			else if (StringUtil.beginsWith(s, "bd:ipad"))
			{
				platver = BAIDU_IPAD;
			}
			else if (StringUtil.beginsWith(s, "bd:iphone"))
			{
				platver = BAIDU_IPHONE;
			}
			else if (StringUtil.beginsWith(s, "bd:android"))
			{
				platver = BAIDU_ANDROID;
			}
			else if (StringUtil.beginsWith(s, "bdyx:ipad"))
			{
				platver = BAIDUG_IPAD;
			}
			else if (StringUtil.beginsWith(s, "bdyx:iphone"))
			{
				platver = BAIDUG_IPHONE;
			}
			else if (StringUtil.beginsWith(s, "bdyx:android"))
			{
				platver = BAIDUG_ANDROID;
			}
			else if (StringUtil.beginsWith(s, "bdy:android"))
			{
				platver = BAIDUYUN_ANDROID;
			}
			else if (StringUtil.beginsWith(s, "qike:ipad"))
			{
				platver = QIKE_IPAD;
			}
			else if (StringUtil.beginsWith(s, "qike:iphone"))
			{
				platver = QIKE_IPHONE;
			}
			else if (StringUtil.beginsWith(s, "qike:android"))
			{
				platver = QIKE_ANDROID ; 
			}
			else if(StringUtil.beginsWith(s,"wan:android"))
			{
				platver = WAN_37_ANDROID;
			}
			else if(StringUtil.beginsWith(s,"pps:android"))
			{
				platver = PPS_ANDROID;
			}
			else if (StringUtil.beginsWith(s, "360:android"))
			{
				platver = QIHU_ANDROID ; 
			}
			else if (StringUtil.beginsWith(s, "360:ipad"))
			{
				platver = QIHU_IPAD ; 
			}
			else if (StringUtil.beginsWith(s, "360:iphone"))
			{
				platver = QIHU_IPHONE ; 
			}
			else if (StringUtil.beginsWith(s, "wdj:ipad"))
			{
				platver = WDJ_IPAD ; 
			}
			else if (StringUtil.beginsWith(s, "wdj:iphone"))
			{
				platver = WDJ_IPHONE ; 
			}
			else if (StringUtil.beginsWith(s, "wdj:android"))
			{
				platver = WDJ_ANDROID ; 
			}
			else if (StringUtil.beginsWith(s, "yyh:ipad"))
			{
				platver = YYH_IPAD ; 
			}
			else if (StringUtil.beginsWith(s, "yyh:iphone"))
			{
				platver = YYH_IPHONE ; 
			}
			else if (StringUtil.beginsWith(s, "yyh:android"))
			{
				platver = YYH_ANDROID ; 
			}
			else if (StringUtil.beginsWith(s, "cmge:ipad"))
			{
				platver = CMGE_IPAD ; 
			}
			else if (StringUtil.beginsWith(s, "cmge:iphone"))
			{
				platver = CMGE_IPHONE ; 
			}
			else if (StringUtil.beginsWith(s, "cmge:android"))
			{
				platver = CMGE_ANDROID ; 
			}
			else if (StringUtil.beginsWith(s, "pptv:ipad"))
			{
				platver = PPTV_IPAD ; 
			}
			else if (StringUtil.beginsWith(s, "pptv:iphone"))
			{
				platver = PPTV_IPHONE ; 
			}
			else if (StringUtil.beginsWith(s, "pptv:android"))
			{
				platver = PPTV_ANDROID ; 
			}
			else if (StringUtil.beginsWith(s, "pptv:ipad"))
			{
				platver = PIPAW_IPAD ; 
			}
			else if (StringUtil.beginsWith(s, "pptv:iphone"))
			{
				platver = PIPAW_IPHONE ; 
			}
			else if (StringUtil.beginsWith(s, "pptv:android"))
			{
				platver = PIPAW_ANDROID ; 
			}
			else if (StringUtil.beginsWith(s, "iapzsy:ipad"))
			{
				platver = ZSY_IPAD ; 
			}
			else if (StringUtil.beginsWith(s, "iapzsy:iphone"))
			{
				platver = ZSY_IPHONE ; 
			}
			else if (StringUtil.beginsWith(s, "youmi:ipad"))
			{
				platver = YOUMI_IPAD ; 
			}
			else if (StringUtil.beginsWith(s, "youmi:iphone"))
			{
				platver = YOUMI_IPHONE ; 
			}
			else if (StringUtil.beginsWith(s, "youmi:android"))
			{
				platver = YOUMI_ANDROID ; 
			}
			else if (StringUtil.beginsWith(s, "app49:ipad"))
			{
				platver = APP49_IPAD ; 
			}
			else if (StringUtil.beginsWith(s, "app49:iphone"))
			{
				platver = APP49_IPHONE ; 
			}
			else if (StringUtil.beginsWith(s, "app49:android"))
			{
				platver = APP49_ANDROID ; 
			}
			else
			{
				platver = PV_DEV;
			}
			return platver;
		}
		
		public static function parsePathInDev(path:String, language:String):String {
			path = StringUtil.trim(path);
			var s:String;
			if (path.indexOf("/") == 0) {
				s = path.substr(1);
				s = s.replace(COMMON, "common");
				s = s.replace(LANGUAGE, language);
				s = s.replace(RESOURCE, "pc");
			}
			else
			{
				s = language + "/pc/" + path;
			}
			return s;
		}
	
		/**
		 * 根据路径创建文件夹 
		 * @param path
		 */		
		public static function createPathForder(path:String):void
		{
			var forders:Array = path.split("/");
			for (var i:int = 0; i < forders.length; i++)
			{
				if(forders[i].indexOf(".") == -1)
				{
					var forderPath:String = "";
					for (var j:int = 0; j < i + 1; j++) 
					{
						forderPath += forders[j] + "/";
					}
					//					createForder(forderPath);
					File.createDirectory(forderPath);
				}
			}
		}
		
		/**
		 * 根据路径创建文件夹 
		 * @param path
		 */		
		public static function createPathForder2(path:String):void
		{
			var forders:Array = path.split("/");
			for (var i:int = 0; i < forders.length; i++)
			{
				if(forders[i].indexOf(".") == -1)
				{
					var forderPath:String = "";
					var isCreate:Boolean=true;
					for (var j:int = 0; j < i + 1; j++) 
					{
						isCreate=true;
						if(String(forders[j]).indexOf(":")>-1 || forders[j]=="")
							isCreate=false;
						forderPath += forders[j] + "/";
					}
					//					createForder(forderPath);
					if(isCreate)
						File.createDirectory(forderPath);
				}
			}
		}

		/**
		 * 获取跟目录盘符,可区分windows/linux
		 * @return 
		 */		
		public static function getExistsLetters():Array
		{
			return (Utils.platformVer() <= Utils.PV_WIN) ? getPCLetters() : ["/"];
		}

		/**
		 * 检测设备上有哪些盘符可用(该方法只在PC下windows操作系统下可用)
		 * 返回所有可用的盘符名称 如[C:, D:]
		 * 说明:由于AVM未提供对文件夹是否存在进行检测的功能,所以采用了一个比较绕路的办法.
		 * 读某盘符下全部文件,如果捕获到异常则认为那是一个不可用的盘符.
		 * 只从C盘检测到Z盘.
		 * @return 
		 */					
		public static function getPCLetters():Array
		{
			var start:String = "C";
			var letters:Array = new Array();
			for (var i:uint = 0; i < 26-2; i++)
			{
				var exist:Boolean = true;
				var letter:String = String.fromCharCode(start.charCodeAt(0) + i) + ":";
				try
				{
					File.getDirectoryListing(letter);
				}
				catch (e:Error)
				{
					if (String(e.message).indexOf("#3003") != -1)
						exist = false;
				}
				if (exist)
					letters.push(letter);
			}
			return letters;
		}
		
		/**
		 * 检测设备上路径是否可以访问 
		 * @param path
		 * @return 
		 */		
		public static function validFolder(path:String):Boolean
		{
			if (path == null) return false;
			var valid:Boolean = true;
			try
			{
				File.getDirectoryListing(path);
			}
			catch (e:Error)
			{
				if (String(e.message).indexOf("#3003") != -1)
					valid = false;
			}
			return valid;
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
		
		/**
		 * 对象深度拷贝 
		 * @param object
		 * @return 
		 * 
		 */
		static public function cloneObject(object:Object):Object{
			var qClassName:String = getQualifiedClassName(object);  
			qClassName=qClassName.replace("::",".");
			var objectType:Class = getDefinitionByName(qClassName) as Class;  
			registerClassAlias(qClassName, objectType);//这里
			var copier : ByteArray = new ByteArray();  
			copier.writeObject(object);  
			copier.position = 0;  
			return copier.readObject();  
		}
		
		
		/**
		 * 获取文件后缀 
		 * @param path
		 * @return 
		 * 
		 */
		static public function pathSuffix(path:String):String{
			var name:String = pathFileName(path);
			if(/[.]/.exec(name))
				return /[^.]+$/.exec(name.toLowerCase());
			else
				return "";
		}
		
		/**
		 * 获取文件名 
		 * @param path
		 * @return 
		 * 
		 */
		static public function pathFileName(path:String):String{
			return path.replace(/.*(\/|\\)/, "");
		}
	}
}