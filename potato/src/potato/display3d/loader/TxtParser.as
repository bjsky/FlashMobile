package potato.display3d.loader
{
    import flash.utils.ByteArray;
    
    import core.events.EventDispatcher;
    import core.filesystem.File;

	/**
	 * 文件解析器  
	 * @author superFlash
	 * 
	 */
    public class TxtParser extends EventDispatcher
    {
        private var b:ByteArray;
        protected var line:uint;
        private var sav_pos:int;
        private var sav_line:uint;
		protected var isAscii:Boolean=false;
        
        public function loadFile(path:String):void
        {
			trace("loadFile ", path);
            b=File.readByteArray(path);
            line=1;
        }
		public function loadStream(data:ByteArray):void
		{
			b=data;
			line=1;
		}
		
		public function setBApos(pos:int):void
		{
			b.position -= pos;
		}
        
        private function jumpBlank():void
        {
            while (b.position<b.length) {
                var c:int=b.readUnsignedByte();
                if (c>0x20) {
                    --b.position;
                    break;
                }
                if (c==0xd)
                    line++;
            }
        }
        
        private function _readWord():String
        {
            jumpBlank();
            var start:int=b.position;
            while (b.position<b.length) {
                var c:int=b.readUnsignedByte();
                if (c<=0x20) {
                    --b.position;
                    break;
                }
            }
            var end:int=b.position;
            
            b.position=start;
			
            //return b.readMultiByte(end-start,"936");
			if (isAscii)
				return b.readMultiByte(end-start,"936");
			else 
            	return b.readUTFBytes(end-start);
        }
        
        public function readWord():String
        {
            var word:String=_readWord();
            if (!word || word.indexOf("//")!=0)
                return word;
            
            while (b.position<b.length) {
                if (b.readUnsignedByte()==0xd) {
                    ++line;
                    break;
                }
            }
            return readWord();
        }
        
        public function readNoBlank():String
        {
            var word:String=readWord();
            if (!word)
                throw new Error("expect no blank");
            return word;
        }
        
        public function readNumber():Number
        {
            var word:String=readNoBlank();
            return parseFloat(word);
        }
        
        public function readNumberDefault(defaultValue:Number=0):Number
        {
            savePos();
            var word:String=readWord();
            if (word) {
                var n:Number=parseFloat(word);
                if (!isNaN(n))
                    return n;
            }
            restorePos();
            return defaultValue;
        }
        
        private function savePos():void
        {
            sav_pos=b.position;
            sav_line=line;
        }
        
        private function restorePos():void
        {
            b.position=sav_pos;
            line=sav_line;
        }
        
        public function expectWord(s:String):void
        {
            var word:String=readWord();
            if (word!=s)
                throw new Error("expect "+s+" "+word+" line "+line);
        }
        
        public function expectWord0Or1Times(s:String):Boolean
        {
            savePos();
            if (readWord()!=s) {
                restorePos();
                return false;
            }
            return true;
        }
        
        public function expectWord0OrAnyTimes(s:String):void
        {
            for (;;) {
                savePos();
                if (readWord()!=s) {
                    restorePos();
                    break;
                }
            }
        }
        
        protected function throwUnexpect(s:String):void
        {
            throw new Error("unexpect "+s+" line "+line);
        }
		
		public function isRead(s:String):Boolean{
			savePos();
			if (readWord()==s) {
				restorePos();
				return false;
			}
			restorePos();
			return true;
		}
    }
}