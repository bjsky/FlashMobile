package potato.movie
{
	import core.events.Event;
	
	/**
	 * 动画事件. 
	 * <p>包括进入帧，进入关键帧和播放完成等事件常量</p>
	 * @author liuxin
	 * 
	 */
	public class MovieEvent extends Event
	{
		public function MovieEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}
		
		/**
		 * 播放完成
		 */
		public static const COMPLETE:String="complete";
		
		/**
		 * 进入帧 
		 */
		public static const ENTER_FRAME:String="movie::enterFrame";
		
		/**
		 * 进入关键帧 
		 */
		public static const ENTER_KEY_FRAME:String="enterKeyFrame";
		
		/**
		 * 动作完成 
		 */
		public static const ACTION_COMPLETE:String="actionComplete";
	}
}