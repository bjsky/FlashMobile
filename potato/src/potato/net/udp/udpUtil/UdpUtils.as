package potato.net.udp.udpUtil
{
	import flash.utils.ByteArray;
	
	import core.filesystem.FileStream;
	import core.utils.MD5;

	public class UdpUtils
	{
		private static const READBUFSIZE:int=10240; // 10k
		private static var md5Util:MD5=new MD5();
		private static var readBuf:ByteArray=new ByteArray();
		
		public function UdpUtils()
		{
		}
		public static function checkMd5(fs:FileStream, md5:String):Boolean
		{
			md5Util.init();

			fs.position=0;
			trace("==bytesAvailable=="+fs.bytesAvailable);
			while (fs.bytesAvailable >= READBUFSIZE)
			{
				fs.readBytes(readBuf, 0, READBUFSIZE);
				md5Util.update(readBuf, 0, READBUFSIZE);
			}
			var a:int=fs.bytesAvailable;
			trace("==a=="+a);
			if (a > 0)
			{
				fs.readBytes(readBuf, 0, a);
				md5Util.update(readBuf, 0, a);
			}
			md5Util.final();
			trace("==md5Util.toString()=="+md5Util.toString()+"==md5=="+md5);
			if (md5Util.toString() == md5)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		public static function toHex(ba:ByteArray, len:int):String
		{
			var s:String="0x";
			ba.position=0;

			if (ba.readByte() == 0x53 && ba.readByte() == 0x46 && ba.readByte() == 0x33)
			{
				s="消息=" + ba.readInt() + ", 块索引=" + ba.readInt() + ", 包索引=" + ba.readInt();
				return s;
			}
			ba.position=0;
			while (len > 0 && ba.bytesAvailable)
			{
				s=s + " " + ba.readUnsignedByte().toString(16);
				len--;
			}
			ba.position=0;
			return s;
		}
	}
}