package com.media.simpleVideo.managers.retry
{
	/**
	 * 错误代码后缀
	 * @author Lukia Lee
	 * 
	 */	
	public class CommonErrorCode
	{
		public function CommonErrorCode()
		{
		}
		/**
		 * 网络错误，后缀为0，比如450是加载广告系统数据的网络错误，460是加载广告物料的网络错误
		 */
		public static const IO_ERROR:String = "0";
		public static const TIME_OUT_ERROR:String = "1";
		public static const SECURITY_ERROR:String = "2";
		
		/**
		 * 加载广告系统数据,数据解析错误
		 */	
		public static const DATA_PARSER_ERROR:String = "3";
		public static const OTHER_ERROR:String = "9";
		
		/*
		450 -- 加载广告系统数据,网络错误
		451 -- 加载广告系统数据,超时错误
		452 -- 加载广告系统数据,安全错误
		453 -- 加载广告系统数据,数据解析错误
		459 -- 加载广告系统数据,其它错误
		460 -- 加载广告物料,网络错误
		461 -- 加载广告物料,超时错误
		462 -- 加载广告物料,安全错误
		463 -- 加载广告物料,数据解析错误
		469 -- 加载广告物料,其它错误
		*/
	}
}