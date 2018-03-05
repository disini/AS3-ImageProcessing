package utils
{
	import flash.display.BitmapData;

	/**
	 * 
	 * @author LiuSheng  QQ:532230294
	 * 创建时间 : 2018-3-2 上午10:51:42
	 *
	 */
	public class Calculation
	{
		
		public static var resultBmd:BitmapData;
		
		public function Calculation()
		{
		}
		
		public static function setup(w:int, h:int):void
		{
			resultBmd = new BitmapData(w, h, false, 0xffffffff);// ARGB	
		}
		
		public static function grayFilter(bmd:BitmapData):BitmapData
		{
//			var resultBmd:BitmapData = new BitmapData(bmd.width, bmd.height, false, 0xffffffff);// ARGB	
			for(var yLoc:int = 0; yLoc < bmd.height; yLoc++)
			{
				for(var xLoc:int = 0; xLoc < bmd.width; xLoc++)
				{
					var obj:Object = grayScale(bmd, xLoc, yLoc);
					var mag:uint = obj.gray;
					var grayColor:uint = (0xFF << 24) +  (mag << 16) + (mag << 8) + mag;
					resultBmd.setPixel32(xLoc, yLoc, grayColor);
				}
			}
			
			return resultBmd;
		}
		
		public static function sobelFilter(bmd:BitmapData, invert:Boolean = false):BitmapData
		{
//			var pixelsData:Array = new Array(bmd.width * bmd.height);
//			var pixelsData:Array = [];
//			var resultBmd:BitmapData = new BitmapData(bmd.width, bmd.height, false, 0xffffffff);// ARGB
			var t1:Number = new Date().time;
			
			for(var yLoc:int = 0; yLoc < bmd.height; yLoc++)
			{
				for(var xLoc:int = 0; xLoc < bmd.width; xLoc++)
				{
					var pOffset:int = ((bmd.width * yLoc) + xLoc) << 2;
					var newX:int;
					var newY:int;
					if((xLoc <= 0 || xLoc >= bmd.width - 1) || (yLoc < 0 || yLoc >= bmd.height - 1))
					{
						newX = 0;
						newY = 0;
					}
					else
					{
						newX = 
							-1 * getGrayValue(bmd, xLoc - 1, yLoc - 1) + // top left
							getGrayValue(bmd, xLoc + 1, yLoc - 1) + // top right
							-1 * getGrayValue(bmd, xLoc - 1, yLoc) + // middle left
							getGrayValue(bmd, xLoc + 1, yLoc) + // middle right
							-1 * getGrayValue(bmd, xLoc - 1, yLoc + 1) + // bottom left
							getGrayValue(bmd, xLoc + 1, yLoc + 1);  // bottom right
						
						newY = 
							-1 * getGrayValue(bmd, xLoc - 1, yLoc - 1) + // top left
							-1 * getGrayValue(bmd, xLoc, yLoc - 1) + // top middle
							-1 * getGrayValue(bmd, xLoc + 1, yLoc - 1) + // top right
							getGrayValue(bmd, xLoc - 1, yLoc + 1) + // bottom left
							getGrayValue(bmd, xLoc, yLoc + 1) + // bottom middle
							getGrayValue(bmd, xLoc + 1, yLoc + 1);  // bottom right
					}
					
					var mag:uint = uint(Math.sqrt(newX * newX + newY * newY));
					if(mag > 255)
						mag = 255;
					if(invert == true)
						mag = 255 - mag;
					
					var grayColor:uint = (0xFF << 24) +  (mag << 16) + (mag << 8) + mag;
					
					resultBmd.setPixel32(xLoc, yLoc, grayColor);
//					pixelsData[pOffset] = grayValue;
//					pixelsData[pOffset + 1] = grayValue;
//					pixelsData[pOffset + 2] = grayValue;
//					pixelsData[pOffset + 3] = 0xFF;
					
				}
			}
			
			
//			var newBmd:BitmapData = new BitmapData(bmd.width, bmd.height);
//			return newBmd;
			var t2:Number = new Date().time;
			var timePassed:Number = t2 - t1;
			trace("sobelFilter calculate finished! time passed is " + timePassed + "ms .");
			return resultBmd;
			
		}
		
		
		public static function grayScale(bmd:BitmapData, xLoc:int, yLoc:int):Object
		{
			if(xLoc < 0 || yLoc < 0)
				return {};
			if(xLoc >= bmd.width || yLoc >= bmd.height)
				return {};
			
			
			var pixelValue:uint = bmd.getPixel32(xLoc, yLoc);
								var alphaValue:uint = pixelValue >> 24 & 0xFF;
//			var alphaValue:uint = pixelValue >> 24;
			var redValue:uint = pixelValue >> 16 & 0xFF;
			var greenValue:uint = pixelValue >> 8 & 0xFF;
			var blueValue:uint = pixelValue & 0xFF;
			
			
//			var value:* = (25 >> 2) + (37 >> 1) + (98 >> 3);
//			var value:* = 37 >> 1;
			// Y=0.3R+0.59G+0.11B
			var grayValue:uint = (redValue >> 2) + (greenValue >> 1) + (blueValue >> 3);// 0.25, 0.5, 0.125
//			var grayValue:Number = Number(redValue) >> 2 + Number(greenValue) >> 1 + Number(blueValue) >> 3;
			return {alpha:alphaValue, red:redValue, green:greenValue, blue:blueValue, gray:grayValue};
		}
		
		public static function getGrayValue(bmd:BitmapData, xLoc:int, yLoc:int):uint
		{
			if(xLoc < 0 || yLoc < 0)
				return 0;
			if(xLoc >= bmd.width || yLoc >= bmd.height)
				return 0;
			
			var obj:Object = grayScale(bmd, xLoc, yLoc);
			return obj.gray;
		}
		
		
	}
}