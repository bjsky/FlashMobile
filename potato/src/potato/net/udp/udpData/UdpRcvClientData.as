package potato.net.udp.udpData
{
	import potato.net.udp.udpConfig.UdpConfig;
	import potato.net.udp.udpConfig.UdpConfig;

	public class UdpRcvClientData
	{
		private var _ip:String;
		private var _port:int;
		private var _address:String;

		///// 用来发回给该客户端，请求的总包数 - 已收到的总包数 == 丢包数
		public var reqAllGram:int=0; //请求的总包数
		public var rcvAllGram:int=0; //已收到的总包数
		public var rcvAllTime:uint=0; //收到的总包数花费时间，会排除空闲时间
		public var gps:int=UdpConfig.upGramSpeed; //每秒接收的包数(只是上几秒的平均值)，初始为最大上传速度

		public var lastRcvTime:uint; //上次收到数据的时间
		public var lastReqTime:uint; //最后一次请求时间

		// 用来保存最近 AVERAGE_NUM 次接收到的状态信息，计算发送速度用 
		public static const AVERAGE_NUM:int=8;
		public var rcvGramArr:Vector.<int>;
		public var rcvTimeArr:Vector.<Number>;
		public var totalGram:int;
		public var totalTime:Number=0;

		public function UdpRcvClientData(ip:String, port:int)
		{
			_ip=ip;
			_port=port;
			_address=_ip + ":" + _port;

			rcvGramArr=new Vector.<int>(AVERAGE_NUM);
			rcvTimeArr=new Vector.<Number>(AVERAGE_NUM);
			for (var i:int=0; i < AVERAGE_NUM; i++)
			{
				rcvGramArr[i]=gps;
				rcvTimeArr[1]=1;

				totalGram+=gps;
				totalTime++;
			}
		}

		public function get port():int
		{
			return _port;
		}

		public function get ip():String
		{
			return _ip;
		}

		public function get address():String
		{
			return _address;
		}

		public function reset():void
		{
			lastRcvTime=0;
			lastReqTime=0;
		}

	}
}