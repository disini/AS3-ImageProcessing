/**
 * Author : linyang
 * Date   : 2012-3
 */
package com.adobe.utils
{
	/**
	 * 时间格式转换
	 * <p>评论点时间格式00'00''</p>
	 * <p>播放器控制轴时间格式00:00/00:00</p>
	 */
	public class TimeUtil
	{		
		/**
		 * 将秒数转化为00:00格式   --》用于进度条的tip
		 * @param num 时间（单位：秒）
		 */
		public static function swap(num:Number):String
		{
			var hours:String;
			var min:String;
			if( int(num/60) < 10){
				hours = "0"+int(num/60)+":"
			}else {
				hours = int(num/60)+":"
			}
			if( int(num%60) < 10)
			{
				min = "0"+int(num%60)+"";
			}else{
				min = int(num%60)+"";
			}
			return hours + min;
		}		
		
		/**
		 * 将秒数转化为00:00  -->用于控制条栏的时间显示
		 */
		/* public static function swap3(num:Number):String{
			var str0:String = null;
			var str1:String = null;
			var str2:String = null;
			var m:VideoModel = ModelManager.getInstance().videoModel;
			if(m.v_total >= 3600){//已经到达小时级别了
				var n:int = int(num/3600);
				str0 = n<=9 ? "0"+n : ""+n;
				num = num%3600;
				str1 = int(num/60) <= 9 ? "0"+int(num/60) : ""+int(num/60);
				num = int(num%60);
				str2 = num <= 9 ? "0"+num : ""+num;
			}else{
				str1 = int(num/60) <= 9 ? "0"+int(num/60) : ""+int(num/60);
				str2 = int(num%60) <= 9 ? "0"+int(num%60) : ""+int(num%60);
			}
			return str0!=null ? str0+":"+str1+":"+str2 : str1+":"+str2;
		} */
		
		public static function swapHour(num:int):String
		{
			var str:String = num <= 9 ? "0" + num : String(num);
			return str;
		}
		
		public static function swapMinute(num:int):String
		{
			var str:String = num <= 9 ? "0" + num : String(num);
			return str;
		}
	}
}