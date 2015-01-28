package tweenLite.easeing
{
	
	public class Cubic {
		public static const power:uint = 2;
		
		public static function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
			return c*(t/=d)*t*t + b;
		}
		public static function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
			return c*((t=t/d-1)*t*t + 1) + b;
		}
		public static function easeInOut (t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d*0.5) < 1) return c*0.5*t*t*t + b;
			return c*0.5*((t-=2)*t*t + 2) + b;
		}
	}
}