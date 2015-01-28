package potato.net.udp.udpConfig
{

	public class UdpConfig
	{
		// 要求上传速度最低10k，这里配置的超时10秒，即两秒内接收端如果没收到一个完整块（10k），则为超时
		public static const OUT_TIME:int=10000;
		public static const RESEND_OUT_TIME:int=5000;   //重发超时
		public static const PACK_SIZE:int=512;
		// 消息头
		public static const HEXS:int=0x53; 				// S
		public static const HEXF:int=0x46;				// F

		//TODO 当前状态， 不是 ST_UDP_READY 的情况下， 不能开始udp下载 
		public static const ST_UDP_LOGIN:int=1; //
		public static const ST_UDP_READY:int=2; //
		public static var status:int=ST_UDP_LOGIN;


		public static const SLEEP:int=20;					 // ms

		public static var localIp:String = "192.168.0.118"; //本机ip
		public static var localPort:int=9900; 				//本机端口

		// 消息重试
		public static const RETRY_CHECK_CYC:int=10; 		// 多少个周期检查一次是否重发消息
		public static var retryNum:int=3;
		public static var retryCyc:int=500; 				//重发消息的周期数， 间隔时间 = sleep * retryCyc

		// udp 中心服务器
		public static var serverIp:String="192.168.0.118";
		public static var serverPort:int=8910;

		public static var threadNum:int=3; 					//文件下载的线程数
		public static var sendFps:Number = 1000.0 / SLEEP;  //每秒内发送文件数据的频次

		// 共享信息
		public static var chunkSize:int; 					//传输文件时的分块大小，由服务器返回
		public static var upGramSpeed:int=200; 				//本客户端的初始上传速度，可以由用户设置，注意单位为gram(包)/s  ---- 速率kB/s = uploadSpeed * PACK_SIZE
		public static var uploadFlag:int=1; 				//是否开启上传


		public static var uid:int; 							//服务器分配的唯一id

		///////// 用户信息
		public static var userid:String="userId"; 		 	//用户id
		public static var gameid:String="gameId"; 		 	//游戏id
		public static var oxver:String="systemEdition";  	//系统版本
		public static var restype:String="resourceType"; 	//资源类型
		public static var resVer:String="resourceEdition";  //资源版本
		public static var downCom:int = 60;					//资源更新下载的完成度
		public static var shareFlag:int = 1;				//共享资源标记
		public function UdpConfig()
		{
		}

		/**
		 * 设置上传速度
		 * @param value 上传速率 byte/s
		 */
		public static function set upByteSpeed(value:int):void
		{
			upGramSpeed=value / PACK_SIZE;
		}

		public static function get upByteSpeed():int
		{
			return upGramSpeed * PACK_SIZE;
		}

		public static function init():void
		{

		}
	}
}