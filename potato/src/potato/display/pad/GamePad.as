package potato.display.pad
{
    public class GamePad implements IGamePad
    {
        public static const PAD_UP:int=1;
        public static const PAD_DOWN:int=2;
        public static const PAD_LEFT:int=4;
        public static const PAD_RIGHT:int=8;
        public static const PAD_1:int=16;
        public static const PAD_2:int=32;
        public static const PAD_3:int=64;
        public static const PAD_4:int=128;
		public static const PAD_5:int=256;
		public static const PAD_6:int=512;
        
        public var state:int;
        
        public function GamePad()
        {
            state=0;
        }
        
        public function get padUp():Boolean
        {
            return (state&PAD_UP)!=0;
        }
        
        public function get padDown():Boolean
        {
            return (state&PAD_DOWN)!=0;
        }
        
        public function get padLeft():Boolean
        {
            return (state&PAD_LEFT)!=0;
        }
        
        public function get padRight():Boolean
        {
            return (state&PAD_RIGHT)!=0;
        }
		public function get pad1():Boolean
		{
			return (state&GamePad.PAD_1)!=0;
		}
		
		public function get pad2():Boolean
		{
			return (state&GamePad.PAD_2)!=0;
		}
		
		public function get pad3():Boolean
		{
			return (state&GamePad.PAD_3)!=0;
		}
		
		public function get pad4():Boolean
		{
			return (state&GamePad.PAD_4)!=0;
		}
    }
}