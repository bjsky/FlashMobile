package potato.net.udp.udpData
{
	import flash.utils.Dictionary;

	public class UdpSendClientData
	{
		public static const STATE_READY:int=0;
		public static const STATE_SEND:int=1;
		public static const STATE_DISCARD:int=-1;
		public static const STATE_REQUEST:int=2;


		public var statue:int=0; //状态， 0=ready；1=正在传输；-1废弃的（网络问题）；2正在发送下载请求

		private var _ip:String;
		private var _port:int;
		private var _address:String;

		private var _uid:uint; //服务器给的唯一标识
		private var _upSpeed:int; //最大上传速度 gram/s

		public var retrySend:int=0; //尝试重试的次数


		///// 用来发回给该客户端，请求的总包数 - 已收到的总包数 == 丢包数
		public var reqAllGram:int=0; //请求的总包数
		public var rcvAllGram:int=0; //已收到的总包数
		public var rcvAllTime:uint=0; //收到的总包数花费时间，会排除空闲时间

		/////// 记录最后5秒内收到的包数
		public static const RECORD_NUM:int=5;
		public var gramNumArr:Vector.<int>;

		public var lastRcvTime:uint; //上次收到数据的时间
		public var lastReqTime:uint=0; //最后一次请求时间


		// 已发送请求的块，key--块索引；val--包含的包数。用于精确计算发送和接收包
		public var chunkDic:Dictionary;


		public function UdpSendClientData(ip:String, port:int, uid:uint, upSpeed:int)
		{
			_ip=ip;
			_port=port;
			_uid=uid;
			_upSpeed=upSpeed;

			_address=_ip + ":" + _port;

			gramNumArr=new Vector.<int>();
			for (var i:int=0; i < RECORD_NUM; i++)
			{
				gramNumArr[i]=0; //_upSpeed;
			}

			chunkDic=new Dictionary();
		}

		/**
		 * 获得剩下的还没有收到的包数
		 * @return
		 */
		public function getRemainGramNum():int
		{
			var sum:int=0;
			for each (var i:int in chunkDic)
			{
				sum+=i;
			}
			return sum;
		}

		public function get upSpeed():int
		{
			return _upSpeed;
		}

		public function get uid():uint
		{
			return _uid;
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
			statue=STATE_READY;
			lastRcvTime=0;
			lastReqTime=0;
			chunkDic=new Dictionary();
		}

	}
}