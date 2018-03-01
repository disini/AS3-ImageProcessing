/**
 * Video Player-Ad Interface Definition (VPAID) 2.0 
 * URL:http://www.iab.net/vpaid
 * Document:http://www.iab.net/media/file/VPAID_2.0_Final_04-10-2012.pdf
 */
package com.vpaid
{
	import flash.events.Event;
	public class VPAIDEvent extends Event
	{
		/**
		 *initAd之后，广告数据加载完成 
		 */		
		public static const AdLoaded : String = "AdLoaded";
		
		/**
		 *广告已经开始播放，调用startAd时返回这个状态
		 */		
		public static const AdStarted : String = "AdStarted";
		
		/**
		 *广告已终止，调用stopAd接口时返回这个状态
		 */		
		public static const AdStopped : String = "AdStopped";
		
		/**
		 *广告已跳过，调用skipAd接口时返回这个状态
		 */		
		public static const AdSkipped : String = "AdSkipped";
		
		/**
		 *广告线性属性改变 
		 */		
		public static const AdLinearChange : String = "AdLinearChange";
		
		/**
		 *广告尺寸改变， 调用resizeAd时返回
		 */		
		public static const AdSizeChange : String = "AdSizeChange";
		
		/**
		 *广告尺寸扩展 
		 */		
		public static const AdExpandedChange : String = "AdExpandedChange";
		
		/**
		 *广告是否可跳过的属性改变 
		 */		
		public static const AdSkippableStateChange : String = "AdSkippableStateChange";
		
		/**
		 *广告剩余时间 
		 */		
		public static const AdRemainingTimeChange : String = "AdRemainingTimeChange";
		
		/**
		 *广告总时长改变 
		 */		
		public static const AdDurationChange : String = "AdDurationChange";
		
		/**
		 *广告声音改变 
		 */		
		public static const AdVolumeChange : String = "AdVolumeChange";
		
		/**
		 *广告曝光 
		 */		
		public static const AdImpression : String = "AdImpression";
		
		/**
		 *广告视频开始播放 
		 */		
		public static const AdVideoStart : String = "AdVideoStart";
		
		/**
		 *广告视频播放完1/4 
		 */		
		public static const AdVideoFirstQuartile : String = "AdVideoFirstQuartile";
		
		/**
		 *广告视频播放完成1/2 
		 */		
		public static const AdVideoMidpoint : String = "AdVideoMidpoint";
		
		/**
		 *广告视频播放完成3/4 
		 */		
		public static const AdVideoThirdQuartile : String = "AdVideoThirdQuartile";
		
		/**
		 *广告视频播放完成 
		 */		
		public static const AdVideoComplete : String = "AdVideoComplete";
		
		/**
		 *广告被点击 
		 */		
		public static const AdClickThru : String = "AdClickThru";
		
		/**
		 *广告互动 
		 */		
		public static const AdInteraction : String = "AdInteraction";
		
		/**
		 *用户接受邀请 
		 */		
		public static const AdUserAcceptInvitation : String = "AdUserAcceptInvitation";
		
		/**
		 *用户操作最小化 
		 */		
		public static const AdUserMinimize : String = "AdUserMinimize";
		
		/**
		 *用户操作关闭
		 */		
		public static const AdUserClose : String = "AdUserClose";
		
		/**
		 *广告被暂停 
		 */		
		public static const AdPaused : String = "AdPaused";
		
		/**
		 *广告恢复播放 
		 */		
		public static const AdPlaying : String = "AdPlaying";
		
		/**
		 *广告日志打印 
		 */		
		public static const AdLog : String = "AdLog";
		
		/**
		 *广告错误 
		 */		
		public static const AdError : String = "AdError";
		/**
		 *需要底层播放器恢复播放 
		 */		
		public static const NeedVideoResume:String = "NeedVideoResume";
		/**
		 *需要底层播放器暂停播放 
		 */
		public static const NeedVideoPause:String = "NeedVideoPause";
		/**
		 *广告事件携带的数据 
		 */		
		/**
		 *需要底层播放器暂停播放 
		 */
		public static const NeedVideoEPause:String = "NeedVideoEPause";
		
		private var _data:Object;
		
		public function VPAIDEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		public function get data():Object {
			return _data;
		}
		
		override public function clone():Event{
			return new VPAIDEvent(type, data, bubbles, cancelable);
		}
	}
}