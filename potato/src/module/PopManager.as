package potato.module
{
	import core.display.DisplayObject;
	import core.display.DisplayObjectContainer;
	import core.display.Stage;
	
	import potato.component.interf.IDataBinding;
	import potato.module.pop.Ipop;

	/**
	 * 弹窗管理器. 
	 * <p>管理弹窗实例，快速打开关闭弹窗，使弹窗居中或者靠前</p>
	 * @author liuxin
	 * 
	 */
	public class PopManager
	{
		public function PopManager()
		{
		}
		
		/**
		 * 弹出一个弹窗 
		 * @param pop 弹窗Class或者实例
		 * @param data 绑定数据(如果需要的话)
		 * @param parent 父对象
		 * @param modal 是否模态化
		 * @return 
		 * 
		 */
		public static function createPop(pop:*,parent:DisplayObjectContainer,data:Object,modal:Boolean=false):Ipop{
			var popIns:Ipop;
			if(pop is Class){
				popIns=new pop();
			}else if(pop is Ipop){
				popIns=Ipop(pop);
			}
			if(popIns is IDataBinding){
				IDataBinding(popIns).dataProvider=data;
			}
			popIns.open(parent,modal);
			return popIns;
		}
		
		/**
		 * 关闭窗口  
		 * @param pop 弹窗
		 * 
		 */
		public static function closePop(pop:Ipop):void{
			pop.close();
		}
		
		/**
		 * 使窗口靠前 
		 * @param pop
		 * 
		 */
		public static function frontPop(pop:Ipop):void{
			var parent:DisplayObjectContainer=DisplayObject(pop).parent;
			if(parent){
				parent.setChildIndex(DisplayObject(pop),parent.numChildren-1);
			}
		}
		
		/**
		 * 使一个弹出居中
		 * @param pop 弹窗实例
		 * @param centerX 居中x偏移
		 * @param centerY 居中y偏移
		 * 
		 */
		public static function centerPop(pop:Ipop,centerX:Number=0,centerY:Number=0):void{
			var parent:DisplayObjectContainer=DisplayObject(pop).parent;
			if(parent){
				DisplayObject(pop).x=(Stage.getStage().stageWidth-DisplayObject(pop).width)/2+centerX;
				DisplayObject(pop).y=(Stage.getStage().stageHeight-DisplayObject(pop).height)/2+centerY;
			}
		}
		
		
	}
}