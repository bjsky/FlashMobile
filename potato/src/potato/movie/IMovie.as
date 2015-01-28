package potato.movie
{
	
	/**
	 * 动画接口. 
	 * @author liuxin
	 * 
	 */
	public interface IMovie
	{
		/**
		 * 播放 
		 * 
		 */
		function play():void;
		/**
		 * 停止 
		 * 
		 */
		function stop():void;
		/**
		 * 跳到第几帧停止 
		 * @param frame
		 * 
		 */
		function gotoAndStop(frame:int):void;
		/**
		 * 跳到第几帧播放 
		 * @param frame
		 * 
		 */
		function gotoAndPlay(frame:int):void;
//		/**
//		 * 总帧数 
//		 * @return 
//		 * 
//		 */
//		function get totalFrame():int;
//		/**
//		 * 当前帧 
//		 * @param value
//		 * 
//		 */
//		function set currentFrame(value:int):void;
//		function get currentFrame():int;
	}
}