package utils
{
	import com.adobe.serialization.json.JSON;
	import com.utils.Log;
	
	import flash.display.DisplayObjectContainer;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;


	public  class Utils
	{
		public  function Utils()
		{
		}
		/**
		 * 将json格式字符串，解析成object对象
		 * 采用com.adobe.serialization.json.JSON.decode包
		 */
		public static function decode(str:String):Object
		{
			var obj:Object=new Object();
			try
			{
				obj=com.adobe.serialization.json.JSON.decode(str);
			}catch(e:Error)
			{
			obj = null;
			}
		return obj;
		}
		/**
		 * 将object对象，转换成json格式字符串
		 * 采用com.adobe.serialization.json.JSON.encode包
		 */
		public static function encode(obj:Object):String
		{
		return com.adobe.serialization.json.JSON.encode(obj);
		}
		/**
		 * 打开网址
		 */
		public static function navigateURL(url:String):void
		{
			navigateToURL(new URLRequest(url),"_blank");
		}
		
		/**
		 *  
		 * @param _milSeconds : 传入的时间值（单位为毫秒）
		 * @param _showMilSec : 是否显示毫秒
		 * @return 
		 * 
		 */		
		public static function getTimeStr1(_milSeconds:Number, _showMilSec:Boolean = true):String
		{
//			 var _value:uint = Math.round(_milSeconds / 1000);
			 var milSeconds:Number = _milSeconds % 1000; 
			 var _value:uint = _milSeconds / 1000;
			 var _hours:uint = _value / 3600;
			 var _minutes:uint = (_value / 60) % 60;
			 var _seconds:uint = _value % 60;
//			 var str1:String = transNumToStr(_hours) + ":" + transNumToStr(_minutes) + ":" + transNumToStr(_seconds) + "." + milSeconds.toFixed(3);
//			 var str1:String = transNumToStr(_hours) + ":" + transNumToStr(_minutes) + ":" + transNumToStr(_seconds) + "." + milSeconds;
			 var str1:String = transNumToStr(_hours) + ":" + transNumToStr(_minutes) + ":" + transNumToStr(_seconds);
			 var str2:String = milSeconds.toFixed(0);
			 if(str2.length > 3)
			 {
//				 ExternalInterface.call("alert", "milSeconds.length > 3");
				 Log.info("Utils.getTimeStr1() : milSeconds.length > 3");
			 }
			 var milSecondsStr:String = milSeconds < 100 ? (milSeconds + "0") : str2;
			 if(_showMilSec)
			 {
				 str1 += ("." + milSecondsStr);
			 }
			 
			 var arr:Array = str1.split(".");
			 if(arr.length > 2 && arr[1].length > 3)
			 {
//				 ExternalInterface.call("alert", "Utils.getTimeStr1() : str1 = " + str1);
				 Log.info("Utils.getTimeStr1() : str1 = " + str1);
			 }
				 
			 return str1;
		}
		
		public static function transNumToStr(_num:int):String
		{
			if(_num == 0)
			{
				return "00";
			}
			else if(_num > 0 && _num <10)
			{
				return "0" + _num;
			}
			else if(_num >= 10 && _num <= 60)
			{
				return _num.toString();
			}
			else
			{
//				throw new Error("time value can't be lager than 60!");
				return "err";
			}
		}
		
		public static function addDebugTextArea(_target:DisplayObjectContainer, locX:Number = 100, locY:Number = 100, _tfWidth:Number = 200):TextField
		{
			var tf:TextField = new TextField();
//			tf.textColor = 0xff0000;
			var textformat:TextFormat = new TextFormat(null, 20, 0xff0000, true);
			textformat.align = "center";
			tf.defaultTextFormat = textformat;
			tf.border = true;
			tf.background = true;
			tf.backgroundColor = 0xffffff;
//			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.text = "00:00:00";
			tf.width = _tfWidth;
			tf.height = 30;
			_target.addChild(tf);
			tf.x = locX;
			tf.y = locY;
			return tf;
		}
	}
}