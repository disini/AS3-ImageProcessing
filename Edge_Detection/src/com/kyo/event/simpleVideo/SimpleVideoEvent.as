package com.kyo.event.simpleVideo
{
	
	
	public class SimpleVideoEvent extends DynamicEvent
	{
		public var info:Object = new Object();
		public function SimpleVideoEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, data, bubbles, cancelable);
			info = data;
		}
		
		/**
		 * 开始加载视频
		 */		
		public static const LOAD_START:String = "loadStart";
		
		public static const BUFFER_FULL2:String = "bufferFull2";
		
		public static const NS_PLAY_START2:String = "nsPlayStart2";
		
		public static const PLAY_COMPLETE2:String = "playComplete2";

		/**
		 * 视频播放完成
		 */
		public static const PLAY_COMPLETE:String = "playComplete";
		/**
		 * 缓冲中
		 */
		public static const BUFFER_EMPTY:String = "bufferEmpty";
		/**
		 * 缓冲区已满，可以播放
		 */		
		public static const BUFFER_FULL:String = "bufferFull";
		
		/**
		 * 播放进度，报告当前视频播放头的时间点
		 */
		public static const PLAYING_PROGRESS:String = "playingProgress";
		
		public static const LOADING_PROGRESS:String = "loadingProgress";
		
		
		/**
		 * 视频文件加载完成
		 */
		public static const LOAD_COMPLETE:String = "loadComplete";
		
		/**
		 * NS开始播放，此时得到NS的NetStream.Play.Start状态。但此时如果缓冲区未满，则还不能看到视频开始播放
		 */
		public static const NS_PLAY_START:String = "nsPlayStart";
		
		/**
		 * Video开始播放，此时是初次得到NS的NetStream.Buffer.Full状态。此事件只在某视频播放过程中派发一次，播放周期中后续不再派发。
		 */		
		public static const VIDEO_PLAY_START:String = "videoPlayStart";
		
		/**
		 * 视频被恢复播放
		 */		
		public static const VIDEO_RESUMED:String = "videoResumed";
		/**
		 * 视频被暂停
		 */		
		public static const VIDEO_PAUSED:String = "videoPaused";
		
		/**
		 * NS暂停播放
		 */		
		public static const NS_PAUSED:String = "nsPaused";
		
		/**
		 * NS恢复播放
		 */		
		public static const NS_RESUMED:String = "nsResumed";
		
		/**
		 * 获取到metadata
		 */		
		public static const GOT_METADATA:String = "gotMetadata";
		
		/**
		 * load failed
		 */		
		public static const LOAD_FAILED:String = "onLoadFailed";
		
		/**
		 * IOError
		 */		
		public static const ON_LOAD_IO_ERROR:String = "onLoadIOError";
		
		
	}
}