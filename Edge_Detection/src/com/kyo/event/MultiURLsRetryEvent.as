package  com.kyo.event
{
	import com.kyo.event.simpleVideo.DynamicEvent;
	
	
	public class MultiURLsRetryEvent extends DynamicEvent
	{
		public function MultiURLsRetryEvent(type:String, dat:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, dat, bubbles, cancelable);
		}
		
		//public static const GSLB_DATA_PASER_ERROR:String = "gslbDataParserError";
		/**
		 * 单次调度失败
		 */
		public static const SINGLE_GSLB_ERROR:String = "gslbError";
		/**
		 * 所有调度失败
		 */		
		public static const ALL_GSLB_ERROR:String = "allGslbError";
		/**
		 * 调度成功
		 */		
		public static const GSLB_FINISHED:String = "gslbFinished";
		
	}
}