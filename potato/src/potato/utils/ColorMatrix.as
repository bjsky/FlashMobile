package potato.utils
{
	/**
	 * 颜色矩阵转换工具.
	 * <p>对底层colorMatrixFilter的操作封装。包含调整亮度、对比度、饱和度、色相、红绿蓝透明度通道。</p>
	 * @author liuxin
	 * @example 包含一个按钮的样例
	 * <listing>
	 * class ColorMatrixExample{
	 * 
	 *		public function ColorMatrixExample(){
	 *			var colormatrix:ColorMatrix = new ColorMatrix();
	 *			colormatrix.adjustRedMultiplier(skeleton.r * slot.r * regionAttachment.r);
	 *			colormatrix.adjustGreenMultiplier(skeleton.g * slot.g * regionAttachment.g);
	 *			colormatrix.adjustBlueMultiplier(skeleton.b * slot.b * regionAttachment.b);
	 *			colormatrix.adjustAlphaMultiplier(skeleton.a * slot.a * regionAttachment.a);
	 *			wrapper.filter = new ColorMatrixFilter(colormatrix.matrixList);
	 *		}
	 * }
	 * </listing>
	 */	
	dynamic public class ColorMatrix
	{
		// identity matrix constant:
		private static const IDENTITY_MATRIX:Array = [
			1,0,0,0,0,
			0,1,0,0,0,
			0,0,1,0,0,
			0,0,0,1,0,
			0,0,0,0,1
		];
		private static const LENGTH:Number = IDENTITY_MATRIX.length;
		
		private var _matrixList:Vector.<Number> = new Vector.<Number>();
		// initialization:
		public function ColorMatrix(matrix:Array = null)
		{
			matrix = fixMatrix(matrix);
			copyMatrix(((matrix.length == LENGTH) ? matrix : IDENTITY_MATRIX));
		}
		
		/**
		 * 颜色矩阵的值 
		 * @return 
		 * 
		 */
		public function get matrixList():Vector.<Number>
		{
			return _matrixList;
		}

		public function set matrixList(value:Vector.<Number>):void
		{
			_matrixList = value;
		}

		/**
		 * 重置颜色转换矩阵 
		 * 
		 */
		public function reset():void
		{
			for (var i:uint = 0; i < LENGTH; i++)
			{
				_matrixList[i] = IDENTITY_MATRIX[i];
			}
		}
		
		/**
		 * 改变亮度。
		 * @param value 可选区间是(-1,1)。大于0的值会提高亮度，小于0的值会降低亮度。 
		 * 
		 */
		public function adjustBrightness(value:Number):void
		{
			var x:Number = value;
			if (isNaN(value))
			{
				return;
			}
			multiplyMatrix([
				1,0,0,0,x,
				0,1,0,0,x,
				0,0,1,0,x,
				0,0,0,1,0,
				0,0,0,0,1
			]);
		}
		
		/**
		 * 改变对比度。
		 * @param value 可选区间是(-1,1)。大于0的值会提高对比度，小于0的值会降低对比度。 
		 * 
		 */
		public function adjustContrast(value:Number):void
		{
			if ( isNaN(value))
			{
				return;
			}
			var m0:Number = 1+value; //1+p_val/100;
			var m1:Number = 0.5*(-value)//-p_val*0.5/100;
			multiplyMatrix([
				m0,0,0,0,m1,
				0,m0,0,0,m1,
				0,0,m0,0,m1,
				0,0,0,1,0,
				0,0,0,0,1
			]);
			
		}
		
		/**
		 * 改变饱和度。
		 * @param value 可选区间是(-1,1)。大于0的值会提高饱和度，小于0的值会降低饱和度。'-1'会产生一个灰度图像。 
		 * 
		 */
		public function adjustSaturation(value:Number):void
		{
			if (isNaN(value))
			{
				return;
			}
			var lumR:Number = 0.3086;
			var lumG:Number = 0.6094;
			var lumB:Number = 0.0820;
			var x:Number=1+((value > 0) ? 3*value : value);
			
			multiplyMatrix([
				lumR*(1-x)+x,lumG*(1-x),lumB*(1-x),0,0,
				lumR*(1-x),lumG*(1-x)+x,lumB*(1-x),0,0,
				lumR*(1-x),lumG*(1-x),lumB*(1-x)+x,0,0,
				0,0,0,1,0,
				0,0,0,0,1
			]);
			
		}
		
		/**
		 * 改变图像的色调. 
		 * @param value 可选区间是(-1,1)。 
		 * 
		 */
		public function adjustHue(value:Number):void
		{
			value*=180;
			if (value == 0 || isNaN(value))
			{
				return;
			}
			
			var cosVal:Number = Math.cos(value * Math.PI / 180);
			var sinVal:Number = Math.sin(value * Math.PI / 180);
			
			
			var lumR:Number = 0.213;
			var lumG:Number = 0.715;
			var lumB:Number = 0.072;
			multiplyMatrix([
				lumR+cosVal*(1-lumR)+sinVal*(-lumR),lumG+cosVal*(-lumG)+sinVal*(-lumG),lumB+cosVal*(-lumB)+sinVal*(1-lumB),0,0,
				lumR+cosVal*(-lumR)+sinVal*(0.143),lumG+cosVal*(1-lumG)+sinVal*(0.140),lumB+cosVal*(-lumB)+sinVal*(-0.283),0,0,
				lumR+cosVal*(-lumR)+sinVal*(-(1-lumR)),lumG+cosVal*(-lumG)+sinVal*(lumG),lumB+cosVal*(1-lumB)+sinVal*(lumB),0,0,
				0,0,0,1,0,
				0,0,0,0,1
			]);
			
		}
		
		/**
		 * 调整红色通道偏移 
		 * @param value 区间-1到1
		 * 
		 */
		public function adjustRedOffset(value:Number):void{
			multiplyMatrix([
				1,0,0,0,value,
				0,1,0,0,0,
				0,0,1,0,0,
				0,0,0,1,0,
				0,0,0,0,1
			]);
		}
		
		/**
		 * 调整绿色通道偏移 
		 * @param value 区间-1到1
		 * 
		 */
		public function adjustGreenOffset(value:Number):void{
			multiplyMatrix([
				1,0,0,0,0,
				0,1,0,0,value,
				0,0,1,0,0,
				0,0,0,1,0,
				0,0,0,0,1
			]);
		}
		
		/**
		 * 调整蓝色通道偏移 
		 * @param value 区间-1到1
		 * 
		 */
		public function adjustBlueOffset(value:Number):void{
			multiplyMatrix([
				1,0,0,0,0,
				0,1,0,0,0,
				0,0,1,0,value,
				0,0,0,1,0,
				0,0,0,0,1
			]);
		}
		
		/**
		 * 调整透明通道偏移 
		 * @param value 区间-1到1
		 * 
		 */
		public function adjustAlphaOffset(value:Number):void{
			multiplyMatrix([
				1,0,0,0,0,
				0,1,0,0,0,
				0,0,1,0,0,
				0,0,0,1,value,
				0,0,0,0,1
			]);
		}
		
		/**
		 * 调整红色通道倍数
		 * @param value 大于1时加深通道颜色，小于1时减淡
		 * 
		 */
		public function adjustRedMultiplier(value:Number):void{
			if(value==1) return;
			multiplyMatrix([
				value,0,0,0,0,
				0,1,0,0,0,
				0,0,1,0,0,
				0,0,0,1,0,
				0,0,0,0,1
			]);
		}
		
		/**
		 * 调整绿色通道倍数
		 * @param value 大于1时加深通道颜色，小于1时减淡
		 * 
		 */
		public function adjustGreenMultiplier(value:Number):void{
			if(value==1) return;
			multiplyMatrix([
				1,0,0,0,0,
				0,value,0,0,0,
				0,0,1,0,0,
				0,0,0,1,0,
				0,0,0,0,1
			]);
		}
		
		/**
		 * 调整蓝色通道倍数
		 * @param value 大于1时加深通道颜色，小于1时减淡
		 * 
		 */
		public function adjustBlueMultiplier(value:Number):void{
			if(value==1) return;
			multiplyMatrix([
				1,0,0,0,0,
				0,1,0,0,0,
				0,0,value,0,0,
				0,0,0,1,0,
				0,0,0,0,1
			]);
		}
		
		/**
		 * 调整透明度通道倍数 
		 * @param value 大于1时加深通道颜色，小于1时减淡
		 * 
		 */
		public function adjustAlphaMultiplier(value:Number):void{
			if(value==1) return;
			multiplyMatrix([
				1,0,0,0,0,
				0,1,0,0,0,
				0,0,1,0,0,
				0,0,0,value,0,
				0,0,0,0,1
			]);
		}
		
//		private function adjustAlphaColor(red:Number,green:Number,blue:Number):void
//		{
//			// TODO Auto Generated method stub
//			red=(red+100)/100;
//			green=(green+100)/100;
//			blue=(blue+100)/100;
//			
//			multiplyMatrix([
//				red,0,0,0,0,
//				green-1,1,0,0,0,
//				blue-1,0,1,0,0,
//				0,0,0,1,0,
//				0,0,0,0,1
//			]);
//		}
		
		/**
		 * 合并一个颜色矩阵 
		 * @param matrix  颜色矩阵 
		 * 
		 */		
		public function concat(matrix:Array):void
		{
			matrix = fixMatrix(matrix);
			if (matrix.length != LENGTH)
			{
				return;
			}
			multiplyMatrix(matrix);
		}
		
		public function toString():String
		{
			return "ColorMatrix [ " + _matrixList.join(" , ") + " ]";
		}
		
		// private methods:
		protected function copyMatrix(matrix:Array):void
		{
			var l:Number = LENGTH;
			for (var i:uint = 0; i < l; i++)
			{
				_matrixList[i] = matrix[i];
			}
		}
		
		// multiplies one matrix against another:
		protected function multiplyMatrix(matrix:Array):void
		{
			var col:Array = [];
			for (var i:uint = 0; i < 5; i++)
			{
				for (var j:uint = 0; j < 5; j++)
				{
					col[j] = _matrixList[j + i * 5];
				}
				for (j = 0; j < 5; j++)
				{
					var val:Number = 0;
					for (var k:Number = 0; k < 5; k++)
					{
						val += matrix[j + k * 5] * col[k];
					}
					_matrixList[j + i * 5] = val;
				}
			}
		}
		// makes sure matrixes are 5x5 (25 long):
		private function fixMatrix(matrix:Array = null):Array
		{
			if (matrix == null)
			{
				return IDENTITY_MATRIX;
			}
			if (matrix is ColorMatrix)
			{
				matrix = matrix.slice(0);
			}
			if (matrix.length < LENGTH)
			{
				matrix = matrix.slice(0, matrix.length).concat(IDENTITY_MATRIX.slice(matrix.length, LENGTH));
			}
			else if (matrix.length > LENGTH)
			{
				matrix = matrix.slice(0, LENGTH);
			}
			return matrix;
		}
	}
}