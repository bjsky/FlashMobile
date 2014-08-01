package potato
{
	import core.display.Stage;
	

	/**
	 * 2d游戏实例<br />
	 * @author liuxin
	 * @note 用静态实例将2d资源集中管理
	 */
	public class Game
	{
		public function Game()
		{
			
		}
		/** 舞台**/
		static public var stage:Stage=Stage.getStage();
		
	}
}