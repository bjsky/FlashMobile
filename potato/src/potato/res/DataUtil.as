package potato.res
{
	import core.display.ParticleSystem2D;
	import core.filesystem.File;
	
	import potato.res.particle2DSystem.PexFileUtil;

	/**
	 * 数据工具. 
	 * <p>解析编辑器生成文件的数据 </p>
	 * @author liuxin
	 * 
	 */
	public class DataUtil
	{
		public function DataUtil()
		{
		}
		
		/**
		 * 获取2D粒子对象 和 发射时长构成的Array
		 * @param name 资源名
		 * @return Array[0]为2D粒子对象，Array[1]为发射时长（小于等于0时，表示持续发射）
		
		 */
		public static function getParticleSystem2D(name:String):Array{
			var b:ResBean = Res.getResBean(name);
			if(b==null)
			{
				return null;
			}
			var path:String=b.path;
			if(File.exists(path))
			{
				var ps:ParticleSystem2D=new ParticleSystem2D();
				var duration:Number=PexFileUtil.loadPexFile(path,ps);
				return [ps,duration];
			}
			return null;
		}
	}
}
