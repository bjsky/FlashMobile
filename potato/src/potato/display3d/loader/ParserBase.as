package potato.display3d.loader
{
    import flash.utils.ByteArray;
    import flash.utils.getTimer;
    
    import core.display.Texture;
    import core.errors.AbstractMethodError;
    import core.events.EventDispatcher;
    import core.events.TimerEvent;
    import core.utils.Timer;
    
	/**
	 * 解析器基类，帧异步 
	 * @author superFlash
	 * 
	 */
    public class ParserBase extends EventDispatcher
    {
        protected static const PARSING_DONE:Boolean=true;
        protected static const MORE_TO_PARSE:Boolean=false;
        
        public var obj:*;
        
        protected var _byteData:ByteArray;
        
        private var _parsingComplete:Boolean;
        private var _parsingFailure:Boolean;
        private var _timer:Timer;
        private var _frameLimit:Number;
        private var _lastFrameTime:Number;
        private var _textureFunc:Function;

        public function parseAsync(data:ByteArray,textureFunc:Function,frameLimit:Number=30):void
        {
            _parsingComplete=false;
            _parsingFailure=false;
            
            _byteData=data;
            _textureFunc=textureFunc;
            startParsing(frameLimit);
        }
        
        protected function getTextData():String
        {
            _byteData.position=0;
            return _byteData.readUTFBytes(_byteData.bytesAvailable);
        }
        
        protected function getTexture(url:String):Texture
        {
            var texture:Texture;
            try {
                texture=_textureFunc(url);
            } catch (e:Error) {
                trace("can't get texture "+url);
                texture=null;
            }
            return texture;
        }
        
        protected function hasTime():Boolean
        {
            return ((getTimer()-_lastFrameTime)<_frameLimit);
        }
        
        protected function proceedParsing():Boolean
        {
            throw new AbstractMethodError;
            return true;
        }

        private function onInterval(event:TimerEvent):void
        {
            _lastFrameTime=getTimer();
            try {
                if (proceedParsing())
                    finishParsing();
            } catch (e:Error) {
                trace("parser fail - "+e);
                _parsingFailure=true;
                finishParsing();
            }
        }
        
        private function startParsing(frameLimit:Number):void
        {
            _frameLimit=frameLimit;
            _timer=new Timer(_frameLimit,0);
            _timer.addEventListener(TimerEvent.TIMER,onInterval);
            _timer.start();
        }
        
        private function finishParsing():void
        {
            _timer.removeEventListener(TimerEvent.TIMER,onInterval);
            _timer.stop();
            _timer=null;
            _parsingComplete=true;
            _byteData=null;
            _textureFunc=null;
            dispatchEvent(new ParserEvent(ParserEvent.PARSE_COMPLETE,this));
        }
    }
}