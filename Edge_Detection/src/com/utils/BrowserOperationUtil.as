package com.utils
{
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class BrowserOperationUtil extends Object
	{
		public static function stdout(msg:String):void
		{
			try{
				//ExternalInterface.call("console.log", msg);
			}catch(e:Error){}
		}
		
		public static function messageBox(msg:String):void
		{
			try{
				//ExternalInterface.call("alert", msg);				
			}catch(e:Error){}
		}
		
		public static function openWindow(pageurl:String, window:String = "_blank", windowparameters:String = "", isFullScreen:Boolean=false, stg:Stage=null):void
        {
            var jscmd:String;
            var req:URLRequest;
            var browsername:String;
            jscmd = "window.open";
            req = new URLRequest(pageurl);			
            browsername = getBrowserName();
			//trace("openWindow ", browsername);
			//navigateToURL(req, window);
			try{
				if(browsername == "Undefined"){
					navigateToURL(req, window);
				}else if (browsername == "Firefox"){
					//ExternalInterface.call(jscmd, pageurl, window, windowparameters);
					exitFullScreen(isFullScreen, stg);
					navigateToURL(req, window);
				}else if (browsername == "IE" || browsername=="Undefined"){
					///exitFullScreen(isFullScreen, stg);
					
					if(isFullScreen){
						navigateToURL(req, window);
//						trace("navigateToURL "+req.url);
					}else{
						ExternalInterface.call(jscmd, pageurl, window, windowparameters);
//						trace(jscmd+" "+req.url);
					}
				}else if (browsername == "Safari" || browsername == "Opera"){
					navigateToURL(req, window);
				}else{
					navigateToURL(req, window);
				}			
			}catch(e:Error){
				//trace("发监测有错 "+e.message);
				navigateToURL(req, window);
			}
        }
		
		private static function exitFullScreen(isFullScreen:Boolean, stg:Stage=null):void{
			if(stg){
				if(isFullScreen){
					stg.displayState = StageDisplayState.NORMAL;
				}
			}
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
			
			//trace("useragent:" + useragent);
			
            return browsername;
        }
	}
	
}