package com.adobe.utils
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * ...
	 * @author john329
	 */
	public class BrowserOperator extends Object
	{
		public static function stdout(msg:String):void
		{
			try{
				ExternalInterface.call("console.log", msg);
			}catch(e:Error){}
		}
		
		public static function messageBox(msg:String):void
		{
			try{
				ExternalInterface.call("alert", msg);				
			}catch(e:Error){}
		}
		
		public static function openWindow(pageurl:String, window:String = "_blank"):void
        {
			try{
				if(pageurl==null||pageurl.indexOf("http://")==-1) return;
			}catch(e:Error){
				return;
			}
            var jscmd:String;
            var req:URLRequest;
            var browsername:String;
            jscmd = "window.open";
            req = new URLRequest(pageurl);			
            browsername = getBrowserName();
			try{
				if (browsername == "Firefox")
				{
					ExternalInterface.call(jscmd, pageurl,window);
				}
				else if (browsername == "IE")
				{
					ExternalInterface.call(jscmd, pageurl,window);
				}
				else if (browsername == "Safari")
				{
					navigateToURL(req, window);
				}
				else if (browsername == "Opera")
				{
					navigateToURL(req, window);
				}
				else
				{
					navigateToURL(req, window);
				}			
			}catch(e:Error){
				navigateToURL(req, window);
			}
            return;
        }

        private static function getBrowserName() : String
        {
            var browsername:String;
            var useragent:String;
			try{
				useragent = ExternalInterface.call(
					"function getBrowser(){return navigator.userAgent;}");
			}catch(e:Error){
				useragent = null;
			}
            if (useragent != null && useragent.indexOf("Firefox") >= 0)
            {
                browsername = "Firefox";
            }
            else if (useragent != null && useragent.indexOf("Safari") >= 0)
            {
                browsername = "Safari";
            }
            else if (useragent != null && useragent.indexOf("MSIE") >= 0)
            {
                browsername = "IE";
            }
            else if (useragent != null && useragent.indexOf("Opera") >= 0)
            {
                browsername = "Opera";
            }
            else
            {
                browsername = "Undefined";
            }
            return browsername;
        }
	}
	
}