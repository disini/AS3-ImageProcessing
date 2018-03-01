package com.view.tip
{
	/**
	 * 
	 * @author LiuSheng  QQ:532230294
	 * 创建时间 : 2017-7-13 下午3:02:11
	 *
	 */
	public class MouseTip1 extends MouseTipMC1
	{
		private static var _instance:MouseTip1;
		
		
		public function MouseTip1()
		{
			if(_instance)
			{
				throw new Error("VolumeUI can't be initialized twice!");
			}
			_instance = this;
		}
		
		public static function get instance():MouseTip1
		{
			return _instance ? _instance : new MouseTip1();
		}
		
		public function set content(value:String):void
		{
			this.tipText.text = value;
			this.bg.rect.width = this.tipText.width = this.tipText.textWidth + 10;
		}
		
	}
}