package com.kyo.media.simpleVideo
{
	import com.kyo.event.simpleVideo.SimpleVideoEvent;
	import com.utils.Log;

	public class VideoCallbackClient
	{
		private var _video:SimpleVideo;
		public function VideoCallbackClient(videoInstance:SimpleVideo)
		{
			_video = videoInstance;
		}
		//onCuePoint()、onImageData()、onMetaData()、onPlayStatus()、onSeekPoint()、onTextData() 和 onXMPData()。 
		public function onMetaData(info:Object):void {
			Log.info("VideoCallbackClient.onMetaData() : ");
			//EIUtil.logTrace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
			info.videoView = _video;
			info.loadIdx = _video.loadIdx;
			_video.duration = info.duration;
		/*	if(_video.isAutoSize){
				_video.changeSize(Number(info.width) , Number(info.height));
			}*/
			_video.metaDataInfo = info;
			
			_video.dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.GOT_METADATA, info));
//			notify(CMD.VIDEO_MATADATA,info);
		}
		public function onCuePoint(info:Object):void {
			//trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
		}
		
		public function onSeekPoint(item:Object):void {
			//trace("onSeekPoint "+item);
		}
		
		public function onPlayStatus(item:Object):void {
			//if(item) 
				//trace("onPlayStatus "+item);
		}
		
		public function onTextData(item:Object):void {
			//if(item)
				//trace("onTextData "+item);
		}
		
		public function onImageDataHandler(image:Object):void {
			//if(image)
				//trace("imageData length: " + image.data.length);
			/*var imageloader:Loader = new Loader();           
			imageloader.loadBytes(imageData.data); // imageData.data is a ByteArray object.
			addChild(imageloader);*/
		}
		
		public function onXMPData(data:Object):void{
			//if(data)
				//trace("onXMPData "+data);
		}
		
		public function destroy():void{
			_video = null;
		}
		
		
	}
}