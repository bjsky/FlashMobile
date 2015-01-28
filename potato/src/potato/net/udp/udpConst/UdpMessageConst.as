package potato.net.udp.udpConst
{

	public class UdpMessageConst
	{
		public static const S_LOGIN:int=0x10; 		//客户端登录
		public static const R_LOGIN:int=0x20; 		//服务器登录响应
		
		public static const S_REQLIST:int=0x11;		//请求刷新推荐列表
		
		public static const S_HOLE:int=0x12; 		//请求打洞消息
		public static const R_HOLE:int=0x21; 		//打洞消息
		
		public static const S_HOLEEND:int=0x13; 	//打洞完成消息
		public static const R_HOLEEND:int=0x22; 	//打洞完成返回消息
		
		public static const S_DOWNEND:int=0x14; 	//文件下载完成消息
		
		public static const S_GETSHARE:int=0x15; 	//兑换共享奖励消息
		public static const R_GETSHARE:int=0x25; 	//兑换共享奖励返回消息
		
		
		public static const R_HEART:int=0x24; 		//客户端活跃心跳消息
		
		public static const S_GETFILE:int=0x30; 	 //请求发送文件连接
		public static const R_GETFILE:int=0x31; 	 //请求发送文件连接返回消息
		
		public static const S_GETDATA:int=0x32; 	 //请求发送数据
		public static const S_RETRYGETDATA:int=0x34; //请求重发数据
		public static const S_NETSTATUE:int=0x35; 	 //发送网络状态
		public static const S_COMPLETE:int=0x36;	 //文件接收完毕
		
		public static const R_GETDATA:int=0x33; 	 //文件数据
		
		public static const S_SEND_MESSAGE:int = 0x28;//测试玩

		public function UdpMessageConst()
		{
		}
	}
}