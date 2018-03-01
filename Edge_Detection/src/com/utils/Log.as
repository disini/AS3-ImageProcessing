package com.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	

	/**
	 * 在线调试输出Log系统 
	 * @author sky
	 * 
	 */
	public class Log
	{
		private static var _s:Sprite;
		
		private static var _tf:TextField;
		
		//日志输出级别，数字越大级别越高，输出信息越多
		private static var _level:int = 0;
		
		private static const LEVEL_STRING:Array = ["[ERROR]","[WARN] ","[DEBUG]","[INFO] "];
		private static const LEVEL_FORMAT:Array = [new TextFormat(null,null,0xff0000),null,null,null];
		
		public function Log()
		{}
		
		public static function init(main:DisplayObjectContainer,width:Number=500,height:Number=400):void
		{
			return;
			
			
			
			if (ExternalInterface.available)
			{
				//检测了available还是可能发生SecurityError，要捕捉一下
				try
				{
					_tf.appendText("浏览器标识："+ExternalInterface.call("function(){ return navigator.userAgent; }")+"\n");	
				}
				catch(error:Error)
				{
					_tf.appendText("Error: " + error.message);
				}
			}
			
		}
		
		public static function toggleShow(isShow:Boolean):void
		{
			if (_s)
			{
				_s.visible = isShow;
			}	
		}
		
		public static function setLevel(level:int):void
		{
			_level = level;
			debug("Log level = ",_level);			
		}
		
		public static function info(...param):void
		{
			append(3,param);				
		}
		
		public static function debug(...param):void
		{
			append(2,param);
		}
		
		public static function warn(...param):void
		{
			append(1,param);			
		}
		
		public static function error(...param):void
		{	
			append(0,param);
		}
		
		public static function getText():String
		{
			return _tf.text;
		}
		
		private static var isConsoleSupported:Boolean = true;
		private static function append(type:int,param:Array):void
		{
			var date:Date = new Date();
			var text:String = LEVEL_STRING[type] + " " + date.toLocaleTimeString() + "    ." + date.milliseconds+" ms   --LSPlayer-- " + param.join(" ") + "\n";
			trace(text);
//			trace(date.toLocaleString());
			if(ExternalInterface.available)
			{
				try
				{
					isConsoleSupported&&ExternalInterface.call("console.log",text);
				}catch(e:Error){
					isConsoleSupported = false;
				}
			}else{
				if (_tf && _level >= type)
				{
					if (_tf.length > 100000)
					{
						_tf.text = "";
						_tf.appendText("too many log > 100000,clear!\n");					
					}
					var start:int = _tf.length;
					_tf.appendText(text);
					var end:int = _tf.length;
					if (LEVEL_FORMAT[type])
						_tf.setTextFormat(LEVEL_FORMAT[type],start,end);				
					_tf.scrollV = _tf.bottomScrollV;
				}
			}
		}
	}
}