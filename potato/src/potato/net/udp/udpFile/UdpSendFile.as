package potato.net.udp.udpFile
{
	import flash.utils.ByteArray;
	
	import core.filesystem.File;
	import core.filesystem.FileStream;
	import core.net.UdpSocket;
	
	import potato.net.udp.udpConfig.UdpConfig;
	import potato.net.udp.udpConst.UdpMessageConst;
	import potato.net.udp.udpData.UdpRcvClientData;
	import potato.net.udp.udpUtil.UdpUtils;

	public class UdpSendFile
	{
		private var _url:String;
		private var _md5:String;
		private var _msgId:uint; //该文件发送的消息id，由接收端指定
		private var _fileSize:int=1;

		private var readFileStream:FileStream;

		private var _isLoadable:Boolean=true;//是否可下载

		private var byteNumInChunk:int; //每块中的字节数
		private var chunkNumInFile:int; //文件中的块数

		public var sendChunkIds:Vector.<int>; //需要传送的数据块索引数组
		public var resendIds:Vector.<int>; //重发id

		private var currSendChunk:int=-1; //当前正在发送的数据块
		private var currSendGram:int=-1; //当前正在发送的数据包索引
//		private var isSetPosition:Boolean = true;		//是否需要设置读文件头的位置

		private var sendBuf:ByteArray;
		private static const HEADER_POS:int=7;

		public var lastReqTime:uint;

		public function UdpSendFile(url:String, md5:String, msgId:uint)
		{
			_url=url;
			_md5=md5;
			_msgId=msgId;

			if (File.exists(url))
			{
				readFileStream=new FileStream();
				readFileStream.open(url, FileStream.READ);

				if (UdpUtils.checkMd5(readFileStream, _md5))
				{
					// 校验通过才初始化为可下载状态
					_isLoadable=true;
					readFileStream.position=0;
					_fileSize=readFileStream.bytesAvailable;
				}
				else
				{
					readFileStream.close();
				}
			}

			byteNumInChunk=UdpConfig.chunkSize * UdpConfig.PACK_SIZE;
			chunkNumInFile=Math.ceil(fileSize / Number(byteNumInChunk));
			sendChunkIds=new Vector.<int>();
			resendIds=new Vector.<int>();

			// 发送包头固定
			sendBuf=new ByteArray();
			sendBuf.writeByte(UdpConfig.HEXS); // S
			sendBuf.writeByte(UdpConfig.HEXF); // F
			sendBuf.writeByte(UdpMessageConst.R_GETDATA); // 文件数据
			sendBuf.writeUnsignedInt(_msgId); // 消息序号
			
		}


		public function get msgId():uint
		{
			return _msgId;
		}

		public function get md5():String
		{
			return _md5;
		}

		public function get url():String
		{
			return _url;
		}

		private function send(udpSocket:UdpSocket, client:UdpRcvClientData, chunkId:int, gramId:int):void
		{
			sendBuf.position=HEADER_POS;
			sendBuf.writeInt(chunkId);
			sendBuf.writeInt(gramId);

			var len:int=UdpConfig.PACK_SIZE;
			readFileStream.position=chunkId * byteNumInChunk + gramId * UdpConfig.PACK_SIZE;
			if (readFileStream.position + UdpConfig.PACK_SIZE > fileSize)
			{
				len=fileSize - readFileStream.position;
			}
			if(readFileStream!=null)
			{
				if(readFileStream.bytesAvailable != 0)
				{
					readFileStream.readBytes(sendBuf, sendBuf.position, len);
					trace("==sendBuf=="+sendBuf+"==position=="+sendBuf.position+"==len=="+len);
				}
			}
			udpSocket.send(sendBuf, 0, len + 15, client.ip, client.port);
			trace("发送文件数据"+"=chunkId="+chunkId+"=gramId="+gramId+"=len="+len+"=fileSize="+fileSize+"=position="+readFileStream.position+"=ip="+client.ip+"=port="+client.port);
		}

		/**
		 * 发送文件数据
		 * @param udpSocket
		 * @param client
		 * @param gramNum
		 */
		public function sendDatagram(udpSocket:UdpSocket, client:UdpRcvClientData, gramNum:int):void
		{
			///////////// 先发需要重发的数据 ////////
			var tv:Vector.<int>;
			trace("length:"+resendIds.length+",gramNum:"+gramNum);
			while (resendIds.length > 0 && gramNum > 0)
			{
				tv=resendIds.splice(0, 2);
				send(udpSocket, client, tv[0], tv[1]);
				gramNum--;
			}
			trace("==gramNum=="+gramNum);
			if (gramNum == 0)
				return;
			if (currSendChunk == -1)
			{
				trace("sendChunkIds长度:"+sendChunkIds.length);
				if (sendChunkIds.length == 0)
					return; //没有可发送的数据
//				currSendChunk = sendChunkIds.shift();
				currSendChunk=sendChunkIds.splice(0, 1)[0];
				currSendGram=0;
//				isSetPosition = true;
			}
//			var isFileEnd:Boolean = false;
			for (var i:int=0; i < gramNum; i++)
			{
				trace("循环");
				send(udpSocket, client, currSendChunk, currSendGram);
				currSendGram++;

//				if (isFileEnd || currSendGram == UdpConfig.chunkSize) {
				if (readFileStream.position == fileSize)
				{
					currSendChunk=-1;
					currSendGram=-1;
					return;
				}
				if (currSendGram == UdpConfig.chunkSize)
				{
					if (sendChunkIds.length == 0)
					{ 
						//发送完毕
						currSendChunk=-1;
						currSendGram=-1;
						return;
					}
					else
					{
						currSendChunk=sendChunkIds.shift();
						currSendGram=0;
//						isSetPosition = true;
					}
//				} else {
//					isSetPosition = false;
				}
			}

			trace("发送数据：", currSendChunk, currSendGram);
		}

		public function complete():void
		{
			if (readFileStream != null)
			{
				readFileStream.close();
			}
		}

		/**
		 * 文件大小
		 * @return
		 */
		public function get fileSize():int
		{
			return _fileSize;
		}

		/**
		 * 是否可下载
		 * @return
		 */
		public function get isLoadable():Boolean
		{
			return _isLoadable;
		}
	}
}