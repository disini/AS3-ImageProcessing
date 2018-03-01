package utils
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	
	import fl.motion.AdjustColor;
	
	
	
	/**
	 * 
	 * @author LiuSheng  QQ:532230294
	 * 创建时间 : 2016-10-19 上午9:49:43
	 *
	 */
	public class VideoGraphicsController extends VideoGraphicsController_MC
	{
		private var mColor:AdjustColor;
		private var mMatrix:Array;
		private var mFilter:Array;
		private var mColorMatrix:ColorMatrixFilter;
		
		private var _displayTarget:DisplayObject;
		
		
		
		public function VideoGraphicsController()
		{
//			super();
			mColor = new AdjustColor();
			mFilter = [];
			addEventListener(Event.CHANGE, onChange);
		}
		
		
		protected function onChange(evt:Event):void
		{
			
			mColor.brightness = stBrightness.value;
			mColor.contrast = stContrast.value;
			mColor.hue = stHue.value;
			mColor.saturation= stSaturation.value;
			
			applyChanging();
		}
		
		private function applyChanging():void
		{
			mFilter = [];
			mMatrix = mColor.CalculateFinalFlatArray();
			mColorMatrix = new ColorMatrixFilter(mMatrix);
			
			mFilter.push(mColorMatrix);
			if(displayTarget)
			{
				displayTarget.filters = mFilter;
			}
		}
		
		public function setBrightnessTo(value:int):void
		{
			mColor.brightness = value;
			applyChanging();
		}
		
		public function setContrastTo(value:int):void
		{
			mColor.contrast = value;
			applyChanging();
		}
		
		public function setHueTo(value:int):void
		{
			mColor.hue = value;
			applyChanging();
		}
		
		public function setSaturationTo(value:int):void
		{
			mColor.saturation = value;
			applyChanging();
		}
		

		public function get displayTarget():DisplayObject
		{
			return _displayTarget;
		}

		public function set displayTarget(value:DisplayObject):void
		{
			_displayTarget = value;
		}

	}
}