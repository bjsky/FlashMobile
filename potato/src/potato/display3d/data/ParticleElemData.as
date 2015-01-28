package potato.display3d.data
{
	public class ParticleElemData extends ElemData
	{
		public function ParticleElemData()
		{
		}
		
		/**开始播放时间*/
		public var startTime:int = 0;//整个效果元素的开始时间，具体的发射器也有自己的开始时间，发射器的开始时间是在该值基础上再做的延迟；
//		/**该效果元素的生存时间，注意：一个效果元素可能包含好多发射器，每一个发射器都有自己独立的生存时间。*/
//		public var lifeTime:int;//整个效果元素的持续时间，主要用来在到期后销毁资源、派发播放完成事件，具体的发射器可能存活的时间比这个长，两者没有关系。
		
		/**粒子系统名**/
		public var particleName:String;
		
	}
}