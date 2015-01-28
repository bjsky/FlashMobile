package potato.net.udp.vo
{
	import flash.utils.ByteArray;

	public class UdpReSendVo
	{
		private var _cmd:int; 			//发送消息cmd
		private var _msgId:uint;		//消息序号
		private var _bytes:ByteArray;   //发送的数据
		private var _offset:uint;		//bytes ByteArray对象中从零开始的偏移量，数据包由此处开始
		private var _length:int;		//数据包中的字节数。默认值0导致从由offset参数指定的值开始发送整个ByteArray
		private var _address:String;	//ip
		private var _port:int;			//端口
		
		private var _isResend:Boolean; 	//是否重发
		private var _resendCnt:int=0; 	//重发送次数
		private var _resendCyc:int; 	//重发周期
		

		public function UdpReSendVo(cmd:int,msgId:int,bytes:ByteArray,offset:uint,length:int,address:String,port:int)
		{
			this._cmd = cmd;
			this._msgId = msgId;
			this._bytes = bytes;
			this._offset = offset;
			this._length = length;
			this._address = address;
			this._port = port;
		}

		public function get resendCyc():int
		{
			return _resendCyc;
		}

		public function set resendCyc(value:int):void
		{
			_resendCyc = value;
		}

		public function get resendCnt():int
		{
			return _resendCnt;
		}

		public function set resendCnt(value:int):void
		{
			_resendCnt = value;
		}

		public function get isResend():Boolean
		{
			return _isResend;
		}

		public function set isResend(value:Boolean):void
		{
			_isResend = value;
		}

		public function get port():int
		{
			return _port;
		}

		public function set port(value:int):void
		{
			_port = value;
		}

		public function get address():String
		{
			return _address;
		}

		public function set address(value:String):void
		{
			_address = value;
		}

		public function get length():int
		{
			return _length;
		}

		public function set length(value:int):void
		{
			_length = value;
		}

		public function get offset():uint
		{
			return _offset;
		}

		public function set offset(value:uint):void
		{
			_offset = value;
		}

		public function get bytes():ByteArray
		{
			return _bytes;
		}

		public function set bytes(value:ByteArray):void
		{
			_bytes = value;
		}

		public function get msgId():uint
		{
			return _msgId;
		}

		public function set msgId(value:uint):void
		{
			_msgId = value;
		}

		public function get cmd():int
		{
			return _cmd;
		}

		public function set cmd(value:int):void
		{
			_cmd = value;
		}

	}
}