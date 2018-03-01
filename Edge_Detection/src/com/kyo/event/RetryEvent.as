package  com.kyo.event
{
	import com.kyo.event.simpleVideo.DynamicEvent;
	
	
	public class RetryEvent extends DynamicEvent
	{
		public function RetryEvent(type:String, dat:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, dat, bubbles, cancelable);
		}
		
		public static const LOAD_STARTED:String = "loadStartd";
		
		/**
		 * 所有的尝试都失败
		 */
		public static const RETRY_FAILED:String = "retryFailed";
		
		/**
		 * 单次尝试失败
		 */
		public static const SINGLE_RETRY_FAILED:String = "singleRetryFailed";
		
		public static const READY_TO_PLAY:String = "readyToPlay";
		
		public static const LOADER_IO_ERROR:String = "loaderIOError";
		public static const LOADER_SECURITY_ERROR:String = "loaderSRCURITYError";
		public static const LOADER_LOADED:String = "loaderLoaded";
		
		public static const GOT_LOAD_RESULT_INFO:String = "gotLoadResult";
		
	}
}