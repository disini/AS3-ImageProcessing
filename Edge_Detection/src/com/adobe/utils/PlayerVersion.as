/**
 * Author : linyang
 * Date   : 2012-3
 */
package com.adobe.utils
{
	import flash.system.Capabilities;
	
	/**
	 * FlashPlayer版本获取工具类
	 */
	public class PlayerVersion
	{
		private static var _bigCode:int;
		private static var _smallCode:int;
		/**
		 * 返回版本号
		 */
		private static function initialize():void
		{
			if(_bigCode == 0)
			{
				var version:String = Capabilities.version;
				version = version.split(" ")[1];
				var codeArr:Array = version.split(",");
				_bigCode = int(codeArr[0]);
				_smallCode = int(codeArr[1]);
			}
		}
		
		/**
		 * 是否为10,0,x地址版本
		 */
		public static function get is_10_0():Boolean
		{
			initialize();
			if(_bigCode==10 && _smallCode==0){
				return true;
			}
			return false;
		}
		
		/**
		 * 是否支持P2P协议
		 */
		public static function get supportP2P():Boolean
		{
			initialize();
			if(_bigCode>=11){
				return true;
			}
			if(_bigCode>=10 && _smallCode>=1){
				return true;
			}
			return false;
		}
		
		/**
		 * 是否支持StageVideo
		 */
		public static function get supportStageVideo():Boolean
		{
			initialize();
			if(_bigCode>=11){
				return true;
			}
			if(_bigCode>=10 && _smallCode>=2){
				return true;
			}
			return false;
		}
		
		/**
		 * 是否支持Stage3D
		 */
		public static function get supportStage3D():Boolean
		{
			initialize();
			if(_bigCode>=11){
				return true;
			}
			return false;
		}
		
		/**
		 * 是否支持LZMA原生解&压缩
		 */
		public static function get supportLZMA():Boolean
		{
			initialize();
			if(_bigCode>=11){
				if(_smallCode<=3){
					return false;
				}
				return true;
			}
			return false;
		}
		/**
		 * 是否支持全屏输入
		 * @return 
		 * 
		 */		
		public static function get supportInterativeInput():Boolean
		{
			return supportLZMA;
		}
	}
}