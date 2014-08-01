package potato.utils
{
	public class Size
	{
		public function Size(width:Number=0,height:Number=0,numLines:int=1)
		{
			this.width=width;
			this.height=height;
			this.numLines=numLines;
		}
		
		
		private var _width:Number=0;
		private var _height:Number=0;
		private var _numLines:int=1;

		public function get numLines():int
		{
			return _numLines;
		}

		public function set numLines(value:int):void
		{
			_numLines = value;
		}

		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;
		}

		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}

	}
}