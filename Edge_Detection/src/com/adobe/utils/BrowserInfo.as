package com.adobe.utils
{
	import flash.external.ExternalInterface;
	
	public class BrowserInfo
	{
		private static var _info:String;
		private static var _name:String;
		private static var _version:String;
		private static var _host:String;
		private static var _href:String;
		private static var _pathname:String;
		private static var _webTitle:String;
		private static var _title:String;
		
		public static var is_msie:Boolean = false;
		public static var is_firefox:Boolean = false;
		public static var is_opera:Boolean = false;
		public static var is_chrome:Boolean = false;
		public static var is_safari:Boolean = false;
		public static var is_other:Boolean = false;
		
		public static const MSIE:String = "msie";
		public static const FIREFOX:String = "firefox";
		public static const OPERA:String = "opera";
		public static const CHROME:String = "chrome";
		public static const SAFARI:String = "safari";
		public static const OTHER:String = "other";
		
		/*
		* @public 在获取信息前首先要加载的函数（初始化）！
		**/
		public static function getBrowserInfo():String {
			try{
				if(ExternalInterface.available){
					_info = ExternalInterface.call("eval" , "navigator.userAgent");
					_getBrowserInfo();
					return "";
				}
			}catch(e:Error){
			}
			return "";
		}
		/*
		* @public GETTER!
		* @getter name 浏览器名称！
		* @getter version 浏览器版本！
		* @getter info 浏览器内核标识！
		* @getter host 当前域名！
		* @getter href 当前完整URL！
		* @getter pathname 除域名外的部分！
		* @getter webTitle 网页标题！
		**/
		public static function get name():String 
		{
			return _name;
		}
		public static function get version():String 
		{
			return _version;
		}
		public static function get info():String 
		{
			return _info;
		}
		static public function get host():String 
		{
			_host = _jsReturn("window.location.host");
			return _host;
		}
		
		static public function get href():String 
		{
			_href = _jsReturn("window.location.href");
			return _href;
		}
		
		static public function get pathname():String 
		{
			_pathname = _jsReturn("window.location.pathname");
			return _pathname;
		}
		
		static public function get webTitle():String 
		{
			_title = _jsReturn("window.location.title");
			return _jsReturn("document.title");
		}
		
		/**
		 * 获取当前页面地址
		 */
		static public function get ref():String
		{
			var url:String;
			try{
				url=ExternalInterface.call('flashGetHref');
				if(url.length>2){
					return escape(url);
				}
			}catch(e:Error){}
			try{
				return escape(ExternalInterface.call('eval',"window.location.href"));
			}catch(e:Error){}	
			return escape("-");
		}
		
		/*
		* @private.
		**/
		private static function _jsReturn(_jsAtrr:String):String {
			try{
				if(ExternalInterface.available){
					return ExternalInterface.call("eval" , _jsAtrr);
				}else{
					return "";
				}
			}catch(e:Error){				
			}
			return "";
		}
		private static function _getBrowserInfo():void {
			var rMsie:RegExp = /.*(msie) ([\w.]+).*/, // ie  
				rFirefox:RegExp = /.*(firefox)\/([\w.]+).*/, // firefox  
				rOpera:RegExp = /(opera).+version\/([\w.]+)/, // opera  
				rChrome:RegExp = /.*(chrome)\/([\w.]+).*/, // chrome  
				rSafari:RegExp = /.*version\/([\w.]+).*(safari).*/;// safari
			_execInfo([rMsie, rFirefox, rOpera, rChrome, rSafari]);
		}
		private static function _execInfo(_regArr:Array):void {
			var _localInfo:String = _info.toLowerCase();
			var _localMatchInfo:Array;
			for (var i:* in _regArr) {
				_localMatchInfo = _regArr[i].exec(_localInfo);
				if (_localMatchInfo != null) {
					if (_localMatchInfo[1] == SAFARI) {
						_name = _localMatchInfo[2];
						_version = _localMatchInfo[1];
					}else {
						_name = _localMatchInfo[1];
						_version = _localMatchInfo[2];
					}
					BrowserInfo["is_" + _name] = true;
					continue;
				}
			}
			if (_name == null || _name == ""){
				_name = OTHER;
				BrowserInfo.is_other = true;
			}
		}
	}
}