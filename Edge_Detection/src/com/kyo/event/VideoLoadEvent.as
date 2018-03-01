package com.kyo.event
{
	import com.kyo.event.simpleVideo.SimpleVideoEvent;
	import com.kyo.signal.notify;
	import com.utils.Log;
	
	import flash.events.EventDispatcher;

	public class VideoLoadEvent extends EventDispatcher
	{
		private var loadIdx:int=0;
		private var info:String;

		public function VideoLoadEvent()
		{
		}

		public function loadVideo():void
		{
			VideoViewArray.init();
			loadIdx=0;
			info=VectorVO.vectorVideo[loadIdx];
			if(info != null && info != "")
			{
				loadOne();
			}
			else
			{
				Log.info("第" + loadIdx + "视频地址为空， 准备加载下一个视频-------------->");
				loadNext();
			}
		}

		private function loadOne():void
		{
			if (loadIdx == VectorVO.vectorVideo.length)
			{
			
				return;
			}
			info=VectorVO.vectorVideo[loadIdx];
			if(info != null && info != "")
			{
				var video:VideoView=createVideo(info, loadIdx);
				video.addEventListener(SimpleVideoEvent.LOAD_COMPLETE, completeHandler);
				video.addEventListener(SimpleVideoEvent.LOAD_FAILED, loadFailedHandler);
//				VideoViewArray.pushVideoView(video);
				VideoViewArray.pushVideoView1(video, loadIdx);
				Log.info("加载第" + loadIdx + "视频-------------->");
			}
			else
			{
				Log.info("第" + loadIdx + "视频地址为空， 准备加载下一个视频-------------->");
				loadNext();
			}
		}
		
		protected function loadFailedHandler(event:Event):void
		{
			Log.info("第" + loadIdx + "个视频加载失败， 准备加载下一个视频-------------->");
			loadNext();
		}
		
		private function completeHandler(e:SimpleVideoEvent):void
		{
			if (loadIdx == VectorVO.vectorVideo.length - 1)
			{
				
				notify(CMD.VIDEO_SUCCESS);
//				return;
			}
			loadNext();
		}

		private function loadNext():void
		{
//			loadIdx=loadIdx + 1;
			loadIdx++;
			
			loadOne();
		}

		private function createVideo(url:String, idx:int):VideoView
		{
			var video:VideoView=new VideoView();
			video.autoPlay=false;
//			video.autoPlay=true;
			video.isCloseAfterPlayComplete = true;
			video.smoothing=true;
			video.loadIdx = idx;
			video.url=url;
			return video;
		}
	}
}
