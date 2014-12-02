package potato.module
{
	/**
	 * 动画ui 
	 * @author liuxin
	 * 
	 */
	public interface IEffectUI
	{
		function show():void;
		function showComplete():void;
		
		function hide():void;
		function hideComplete():void;
	}
}