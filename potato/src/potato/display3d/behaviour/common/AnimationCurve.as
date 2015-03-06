package potato.display3d.behaviour.common
{
	import potato.display3d.data.behaviour.AnimationCurveData;

	/**
	 * 模拟unity曲线动画
	 */
	public class AnimationCurve
	{
		public static const LOOP:int = 1;			//循环曲线
		public static const PINGPONG:int = 2;		//反向曲线
		public static const ClampForever:int = 3;	//端点延续
		
		public var preWrapMode:int;
		public var postWrapMode:int;
		public var keys:Array = [];
		public var vals:Array = [];
		
		public function AnimationCurve(data:AnimationCurveData)
		{
			preWrapMode = data.preWrapMode;
			postWrapMode = data.postWrapMode;
			var len:int = data.keys.length/2;
			for(var i:int=0;i<len;i++){
				var j:int = i*2;
				keys[i] = data.keys[j];
				vals[i] = data.keys[j+1];
			}
		}
		
		/**
		 * time 单位秒
		 */
		public function Evaluate(time:Number):Number
		{
			if(keys.length <= 0)return 0;
			
			var start:Number = keys[0];
			var end:Number = keys[keys.length-1];
			var len:Number = end - start;
			var count:int = 0;
			var f:Boolean =false;
			
			if(time < start){
				switch(preWrapMode){
					case LOOP:
						while(time < start){
							time += len;
						}
						return getValue(time);
						break;
					case PINGPONG:
						count = (end - time) / len;
						time = time + count * len;
						if(count % 2 == 1){
							f = true;
							time = len - time;
						}
						return getValue(time, f);
						break;
					case ClampForever:
						return vals[0];
						break;
				}
			}else if(time > end){
				switch(postWrapMode){
					case LOOP:
						while(time > end){
							time -= len;
						}
						return getValue(time);
						break;
					case PINGPONG:
						count = (time - start) / len;
						time = time - count * len;
						if(count % 2 == 1){
							f = true;
							time = len - time;
						}
						return getValue(time, f);
						break;
					case ClampForever:
						return vals[vals.length-1];
						break;
				}
			}else{
				return getValue(time);
			}
			
			return 0;
		}
		/**
		 * time	区间内的时间
		 * rev	是否反转计算
		 */
		private function getValue(time:Number, rev:Boolean=false):Number
		{
			var len:int = keys.length;
			var i:int;
			var j:int;
			if(rev){
				for(i=len-1;i>0;i--){
					j = i-1;
					if(time < keys[i] && time >= keys[j]){
						return linear(i,j,time);
					}
				}
				return vals[0];
			}else{
				for(i=0;i<len-1;i++){
					j = i + 1;
					if(time>=keys[i] && time < keys[j]){
						return linear(i,j,time);
					}
				}
				return vals[len-1];
			}
		}
		//在pre和next之间线性插值
		private function linear(pre:int,next:int,time:Number):Number
		{
			var t1:Number = keys[pre];
			var t2:Number = keys[next];
			var v1:Number = vals[pre];
			var v2:Number = vals[next];
			
			return (time - t1) / (t2 - t1) * (v2 - v1) + v1;
		}
	}
}