package com.kyo.event
{
	import flash.events.Event;
	
	/**
	 * ControlBar组件事件.
	 * @author linyang created on 2012-2013
	 */
	public class ControlBarEvent extends Event
	{		
		/**
		 * 播放器从等待中苏醒.
		 */
		public static const VIDEO_START_FROM_SLEEP:String = "videoStartFromSleep";
		/**
		 * 重播操作.
		 */
		public static const VIDEO_REPLAY:String = "videoReplay";
		/**
		 * 视频暂停操作.
		 */
		public static const VIDEO_PAUSE:String = "videoPause";
		/**
		 * 视频恢复播放.
		 */
		public static const VIDEO_RESUME:String = "videoResume";
		/**
		 * 进行SeekTo拖拽操作.
		 */
		public static const SEEK_TO:String = "seekTo";
		/**
		 * 跳过片尾.
		 */
		public static const JUMP_TAIL:String = "jumpTail";
		/**
		 * 播放下一集.
		 */
		public static const PLAY_NEXT:String = "playNext";
		/**
		 * 尺寸缩小.
		 */
		public static const DOCK_ZOOM_OUT:String = "dockZoomOut";
		/**
		 * 尺寸放大.
		 */
		public static const DOCK_ZOOM_IN:String = "dockZoomIn";
		/**
		 * 音量设置.
		 */
		public static const SET_VOLUME:String = "setVolume";
		/**
		 * 控制栏移动.
		 */
		public static const CONTROLBAR_MOVE:String = "controlbarMove";
		/**
		 * 比例调节.
		 */
		public static const SCALE_REGULATE:String = "scaleRegulate";
		/**
		 * 清晰度调节.
		 */
		public static const DEFINITION_REGULATE:String = "definitionRegulate";
		/**
		 * VIP码流提示.
		 */
		public static const DEFINITION_VIP:String = "definitionVip";
		/**
		 * 控制条彻底隐藏.
		 */
		public static const HIDESKIN:String = "hideSkin";
		/**
		 * 控制条彻底显示.
		 */
		public static const SHOWSKIN:String = "showSking";
		
		/**
		 *切换音频流 
		 */
		public static const CHANGEAUDIO:String = "changeAudio"
		
		/**
		 *切换字幕
		 */
		public static const CHANGCAPTION:String = "changeCaption"
			
			
		public var controlbarX:Number = 0;
		
		public var controlbarY:Number = 0;
		
		public var dataProvider:Object = {};
		
		public function ControlBarEvent(type:String , bubbles:Boolean = false , cancelable:Boolean = false)
		{
			super(type , bubbles , cancelable);
		}
		
		override public function clone():Event{
			var e:ControlBarEvent = new ControlBarEvent(type , bubbles , cancelable);
			e.controlbarX = controlbarX;
			e.controlbarY = controlbarY;
			e.dataProvider = dataProvider;
			return e;
		}
	}
}