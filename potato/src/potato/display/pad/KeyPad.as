package potato.display.pad
{
    import core.display.Stage;
    import core.events.Keyboard;
    import core.events.KeyboardEvent;
    
    import potato.utils.Utils;

    public class KeyPad extends GamePad
    {
        private var _map:Array;
        
        public function KeyPad(map:Array=null)
        {
            Stage.getStage().addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
            Stage.getStage().addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
            if (map==null) {
                if (Utils.platformVer() == Utils.PV_ANDROID)
                    map=[DPad.UP,DPad.DOWN,DPad.LEFT,DPad.RIGHT,DPad.BUTTON1,DPad.BUTTON2,DPad.BUTTON3,DPad.BUTTON4];
                else
                    map=[Keyboard.UP,Keyboard.DOWN,Keyboard.LEFT,Keyboard.RIGHT,0x31,0x32,0x33,0x34,0x35,0x36];
            }
            mapping(map);
        }
        
        public function dispose():void
        {
            Stage.getStage().removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
            Stage.getStage().removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
        }
        
        public function mapping(v:Array):void
        {
            _map=[];
            for (var i:int=0;i<v.length;++i) {
                _map[v[i]]=i+1;
            }
        }
        
        private function changeKey(code:uint):uint
        {
            if (Utils.platformVer() == Utils.PV_ANDROID) {
                if (code>=DPad.KEYCODE_1 && code<=DPad.KEYCODE_4) {
                    code+=DPad.BUTTON1-DPad.KEYCODE_1;
                }
            }
            return code;
        }
        
        private function onKeyDown(event:KeyboardEvent):void
        {
            var id:int=_map[changeKey(event.keyCode)];
            if (id>0)
                state|=1<<(id-1);
        }
        
        private function onKeyUp(event:KeyboardEvent):void
        {
            var id:int=_map[changeKey(event.keyCode)];
            if (id>0)
                state&=~(1<<(id-1));
        }
    }
}