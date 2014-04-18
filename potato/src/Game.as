package potato
{
	import core.display.Stage;
	
	import potato.manager.LayoutManager;
	

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
		/** 横屏**/
		static public const SCREEN_HORIZONTAL:String="Screen_Horizontal";
		/** 竖屏**/
		static public const SCREEN_VERTICAL:String="Screen_Vertical";
		
		/** 舞台**/
		static public var stage:Stage=Stage.getStage();
		/** 布局管理**/
		static public var layout:LayoutManager=new LayoutManager();
		
		/** x轴最大网格数**/
		static public var gridXMax:Number;
		/** y轴最大网格数**/
		static public var gridYMax:Number;
		/** 设备屏幕类型(确定缩放保持长宽比的依赖边，横屏宽度依赖高度，竖屏高度依赖宽度)**/
		static public var deviceScreenType:String;
		
		/**
		 * 初始化
		 * @note 确定屏幕类型
		 */
		static public function init():void{
			deviceScreenType=(stage.stageWidth>stage.stageHeight?SCREEN_HORIZONTAL:SCREEN_VERTICAL);
		}
		/** 设置网格布局尺寸**/
		static public function setGridMaxSize(xMax:Number,yMax:Number):void{
			gridXMax=xMax;
			gridYMax=yMax;
		}
	}
}