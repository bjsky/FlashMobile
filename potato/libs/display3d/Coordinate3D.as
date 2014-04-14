package potato.display3d
{
	import core.display3d.ObjectContainer3D;
	import core.display3d.SegmentSet;
	
	/**
	 * 三维坐标;  
	 * @author SuperFlash
	 * @time 2014/03/28
	 * 
	 */
	public class Coordinate3D extends ObjectContainer3D
	{
		
		private var _mangnitude:int=2000;
		private var _stepSize:int=200;
		private var _lineColor:uint=0x333333;
		
		public function Coordinate3D()
		{
			super();
			
			var sgset:SegmentSet = new SegmentSet();
			
			var vct:Vector.<Number>=Vector.<Number>(
				[
					-_mangnitude,0,0,0xFF0000,_mangnitude,0,0,0xFF0000,
					0,-_mangnitude,0,0x00FF00,0,_mangnitude,0,0x00FF00,
					0,0,-_mangnitude,0x0000FF,0,0,_mangnitude,0x0000FF,
				]
			);
			
			
			//20 x;
			for (var i:int=-10;i<=10;i++){
				if(i==0)continue;
				
				var len:int=i*_stepSize;
				vct.push(-_mangnitude);
				vct.push(0);
				vct.push(-len);
				vct.push(_lineColor);
				
				vct.push(_mangnitude);
				vct.push(0);
				vct.push(-len);
				vct.push(_lineColor);
			}
			
			//20 z;
			for (i=-10;i<=10;i++){
				if(i==0)continue;
				
				len=i*_stepSize;
				vct.push(-len);
				vct.push(0);
				vct.push(-_mangnitude);
				vct.push(_lineColor);
				
				vct.push(-len);
				vct.push(0);
				vct.push(_mangnitude);
				vct.push(_lineColor);
			}
			
			
			sgset.setSegments(vct,vct.length/4);
			addChild(sgset);
		}
	}
}