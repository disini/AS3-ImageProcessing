package com.kyo.media.simpleVideo
{
	import com.adobe.utils.StringUtil;
	import com.media.simpleVideo.managers.retry.IRetryViewLoader;
	import com.media.simpleVideo.managers.retry.RetryManager;
	import com.kyo.event.RetryEvent;
	
	import flash.display.DisplayObject;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.getTimer;
	
	public class SimpleRetryVideo extends SimpleVideo implements IRetryViewLoader{
		public function SimpleRetryVideo(_loadingWatingTime:Number=8, _retryGapTime:Number=0, _retryMaxCount:int=2, needReloading:Boolean = false){
			super(needReloading);
			isRefuseSameURL = false;
			_retryMng = new RetryManager(this);
			_retryMng.loadWaitingTime = _loadingWatingTime;
			_retryMng.retryGapTime = _retryGapTime;
			_retryMng.retryMaxCount = _retryMaxCount;
			//_retryMng.dispatchEvent(new RetryEvent(RetryEvent.LOAD_STARTED));
		}
		private var _retryMng:RetryManager;
		private var _loadDuration:uint;
		private var beginTime:uint;
		
		override public function set url(value:String):void{
			if(value)
				value = StringUtil.trim(value);
			
			super.url = value;
		}
		
		override protected function loadVideo():void{
			super.loadVideo();
			beginTime = getTimer();
		}
		
		override public function onLoadComplete():void{
			recodeDuration();
			_retryMng.dispatchEvent(new RetryEvent(RetryEvent.LOADER_LOADED));
			super.onLoadComplete();
		}
		
		override protected function ioErrorHandler(event:IOErrorEvent = null):void{
			super.ioErrorHandler();
			recodeDuration();
			_retryMng.dispatchEvent(new RetryEvent(RetryEvent.LOADER_IO_ERROR));
		}
		
		override protected function securityErrorHandler(event:SecurityErrorEvent = null):void{
			super.securityErrorHandler(event);
			recodeDuration();
			_retryMng.dispatchEvent(new RetryEvent(RetryEvent.LOADER_SECURITY_ERROR));
		}
		
		private function recodeDuration():void{
			var now:int = getTimer();
			loadDuration = now - beginTime;
		}
		
		public function get loadDuration():uint{
			return _loadDuration;
		}
		
		public function set loadDuration(value:uint):void{
			_loadDuration = value;
		}
		
		public function startLoad():void{
			loadVideo();
		}
		
		public function get fileSize():uint{
			return ns.bytesTotal;
		}
		
		override protected function onReadyToPlay():void{
			super.onReadyToPlay();
			recodeDuration();
			_retryMng.dispatchEvent(new RetryEvent(RetryEvent.READY_TO_PLAY));
		}
		
		override public function closeVideo():void{
			super.closeVideo();
			//_retryMng.destroy();
		}
		
		public function get displayView():DisplayObject{
			return this;
		}
		
		override public function closeLoader():void{
			super.closeLoader();
			closeVideo();
		}
	}
}