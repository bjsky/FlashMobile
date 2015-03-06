package potato.display3d.loader
{
    import core.events.Event;
    
    public class ParserEvent extends Event
    {
        private var _message : String;
        private var _parser : ParserBase;
        
        public static const PARSE_COMPLETE : String = 'parseComplete';
        
        public static const PARSE_ERROR : String = 'parseError';
        
        public function ParserEvent(type:String, parser:ParserBase, message:String='')
        {
            super(type);
            _parser = parser;
            _message = message;
        }
        
        public function get parser() : ParserBase
        {
            return _parser;
        }
        
        public function get message() : String
        {
            return _message;
        }
        
        public override function clone() : Event
        {
            return new ParserEvent(type, parser, message);
        }
    }
}