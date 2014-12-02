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
		 * 获取2D粒子对象 
		 * @param name 资源名
		 * @return 2D粒子对象
		 * 
		 */
		public static function getParticleSystem2D(name:String):ParticleSystem2D{
			var b:ResBean = Res.getResBean(name);
			var path:String=b.path;
			if(File.exists(path))
			{
				var ps:ParticleSystem2D=new ParticleSystem2D();
				PexFileUtil.loadPexFile(path,ps);
				return ps;
			}
			return null;
		}
	}
}
