package com.kyo.media.simpleVideo
{
	import com.kyo.event.simpleVideo.SimpleVideoEvent;
	import com.kyo.media.simpleVideo.loaders.ICommonLoader;
	import com.utils.Log;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	
	
	[Event(name = "playingProgress", type = "com.kyo.event.simpleVideo.SimpleVideoEvent")]
	
	[Event(name = "playComplete", type = "com.kyo.event.simpleVideo.SimpleVideoEvent")]
	
	[Event(name = "loadComplete", type = "com.kyo.event.simpleVideo.SimpleVideoEvent")]
	
	[Event(name = "gotMetadata", type = "com.kyo.event.simpleVideo.SimpleVideoEvent")]
	
	[Event(name = "videoPlayStart", type = "com.kyo.event.simpleVideo.SimpleVideoEvent")]
	
	[Event(name = "nsPlayStart", type = "com.kyo.event.simpleVideo.SimpleVideoEvent")]
	
	[Event(name = "videoPlayStart", type = "com.kyo.event.simpleVideo.SimpleVideoEvent")]
		
	[Event(name = "resumed", type = "com.kyo.event.simpleVideo.SimpleVideoEvent")]
	
	[Event(name = "paused", type = "com.kyo.event.simpleVideo.SimpleVideoEvent")]
	
	[Event(name = "playing", type = "com.kyo.event.simpleVideo.SimpleVideoEvent")]
	
	[Event(name = "bufferFull", type = "com.kyo.event.simpleVideo.SimpleVideoEvent")]
	
	[Event(name = "bufferEmpty", type = "com.kyo.event.simpleVideo.SimpleVideoEvent")]
	
	/**
	 * 简单的视频播放类
	 * @author Lukia Lee
	 * @version 1.0
	 * @created 18-三月-2013 14:43:46
	 */
	public class SimpleVideo extends Video implements ICommonLoader
	{
		public function SimpleVideo(needReloading:Boolean = false){
			super();
			_needReloadingVideoAfterPlayComplete = needReloading;
		}
		
		private var nc:NetConnection;
		protected var ns:NetStream;
		
		private var callbackClient:VideoCallbackClient;
		
		private var playingStatusTimer:Timer;
		
		private var _hasInited:Boolean =  false;
		
		public var loadIdx:int;
		
		/**
		 * 是否在播放完成后停止视频
		 */		
		public var isCloseAfterPlayComplete:Boolean = false;
		
		/**
		 * 是否报告播放状态，默认为true。如果是false，则playingStatusTimer不要初始化，不主动报告播放进度
		 */		
		public var isReportPlayingStatus:Boolean = true;
		
		private var loadingStatusTimer:Timer;
		
		/**
		 * 报告当前时间的间隔值。默认为0.5，单位为秒
		 */		
		public var reportStatusInterval:Number = 0.5;
		
		private var _autoPlay:Boolean = true;
		
		private var _loadComplete:Boolean = false;
		
		private var _url:String;
		
		public var isAutoSize:Boolean = false;
		
		private var _isPlaying:Boolean = false;
		private var _isVideoPlayStarted:Boolean = false;
		public var duration:Number = 0;
		
		public var isStreamStarted:Boolean = false;
		
		public var metaDataInfo:Object;
		private var _curLoadedPercent:int = 0;
		
		private var _curLoadedVideoTime:Number = 0;
		
//		public static const TIME_DELAY_TO_FINISH:Number = 0.2;// 单位：s
		public static const TIME_DELAY_TO_FINISH:Number = 0.1;// 单位：s
		private var _needReloadingVideoAfterPlayComplete:Boolean = false;
		

		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}

		public function set autoPlay(value:Boolean):void// 在 VideoLoadEvent.createVideo()里赋值
		{
			_autoPlay = value;
		}

		private var _loadedFunc:Function;
		
		/**
		 * 一般情况下，发现是同样的url值，就不要加载，在特殊情况下也可以设置为false，免除相同值检测
		 */		
		public var isRefuseSameURL:Boolean = true;
		
		private var _isStreamFound:Boolean = false;
		
		private var _bufferTime:Number = 0.8;
		
		public function get bufferTime():Number
		{
			return _bufferTime;
		}
		
		public function set bufferTime(value:Number):void
		{
			_bufferTime = value;
		}
		
		public function get loadedFunc():Function
		{
			return _loadedFunc;
		}

		public function set loadedFunc(value:Function):void
		{
			_loadedFunc = value;
		}

		
		public function get isPlaying():Boolean
		{
			return _isPlaying && _isVideoPlayStarted;
		}

		public function set isPlaying(value:Boolean):void
		{
			_isPlaying = value;
			
//			initPlayingStatusTimer();
		}

		public function get url():String{
			return _url;
		}
		/** 加载视频素材 */
		public function set url(value:String):void{
			if(!value)return;
			
			if(isRefuseSameURL && value==_url){//如果需要杜绝同样的值，则检查之
				return;
			}
			
			//EIUtil.logTrace(this+" set url "+_url);
				
			if(value && value!="" ){
				_url = value;
				if(_url==""){
					closeVideo();
				}else{
					loadVideo();
				}
			}else{
				closeVideo();
			}
		}
		
		/*public function changeSize(w:Number, h:Number):void{
			width = w;
			height = h;
			dispatchEvent(new CommonControlsEvent(CommonControlsEvent.RESIZE));
		}
		*/
		protected function loadVideo():void{
			_loadComplete = false;
			_isStreamFound = true;
			if(!nc)
				nc = new NetConnection();
				
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			nc.addEventListener(ErrorEvent.ERROR, errorHandler);
			nc.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			nc.connect(null);
			if(!ns){
				ns = new NetStream(nc);
				updateVideoVol();
			}
			ns.bufferTime=_bufferTime;
			ns.checkPolicyFile = true;
			ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			ns.addEventListener(ErrorEvent.ERROR, errorHandler);
			ns.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			ns.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			ns.play(_url);
			
			if(!callbackClient)
				callbackClient = new VideoCallbackClient(this);
			
			ns.client = callbackClient;
			this.attachNetStream(ns);
			initLoadingStatusTimer();
			dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.LOAD_START, { url: _url}));
			CONFIG::debug
			{
				if(!_hasInited)
				{
	//				Log.info("SimpleVideo.loadVideo() : loadVideo Again!"); 
					Log.info("SimpleVideo.loadVideo() : loadVideo " + loadIdx + " first time! url = " + _url); 
				}
				else
				{
					Log.info("SimpleVideo.loadVideo() : loadVideo " + loadIdx + " Again! url = " + _url); 
				}
			}
		}
		
		private function initLoadingStatusTimer():void{
			if(!loadingStatusTimer)
				loadingStatusTimer = new Timer(reportStatusInterval*1000, 0);
			loadingStatusTimer.start();
			loadingStatusTimer.addEventListener(TimerEvent.TIMER, reportLoadingStatus);
		}
		
		private function reportLoadingStatus(e:TimerEvent):void{
			if(!ns){
				return;
			}
//			var pct:int = int(ns.bytesLoaded/ns.bytesTotal * 100);
			_curLoadedPercent = int(ns.bytesLoaded/ns.bytesTotal * 100);
			_curLoadedVideoTime = ns.bytesLoaded/ns.bytesTotal * duration;
			if(_curLoadedPercent ==100){
				_loadComplete = true;
				stopLoadingStatusTimer();
				if(_isStreamFound){//如果视频文件没找到，也就是服务器返回错误信息，则不要派发加载完成的事件
					onLoadComplete();
				}
			}
			
			dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.LOADING_PROGRESS, _curLoadedPercent));
		}
		
		private function stopLoadingStatusTimer():void{
			if(loadingStatusTimer){
				loadingStatusTimer.stop();
				loadingStatusTimer.removeEventListener(TimerEvent.TIMER, reportLoadingStatus);
				loadingStatusTimer = null;
			}
		}
		
		public function resumeVideo():void{
			Log.info("SimpleVideo.resumeVideo() : ns = " + ns);
			if(!ns)
				return;
//			Log.info("SimpleVideo.resumeVideo() : ");
			//ns.seek(ns.time);
			ns.resume();
			initPlayingStatusTimer();
			isPlaying = true;
			dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.VIDEO_RESUMED));
		}
		
		public function pauseVideo():void{
			if(ns){
				
				ns.pause();
			}else{
				
			}
			isPlaying = false;
			dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.VIDEO_PAUSED));
		}
		
		public function closeLoader():void{
			//EIUtil.logTrace(this+"closeLoader()");
			closeVideo();
		}
		
		public function closeVideo():void{
			Log.info("SimpleVideo.closeVideo()"); 
			this.volume = 0;
			closeNCAndNS();
			stopVideo();
			this.clear();
			if(_needReloadingVideoAfterPlayComplete)
			{
				setTimeout(function():void
				{
//					clear();
					loadVideo();
				}, 500);
			}
		}
		
		private function closeNCAndNS():void{
			if(ns){
				//ns.client = this;
//				ns.close();
				ns.dispose();
				ns.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				ns.removeEventListener(ErrorEvent.ERROR, errorHandler);
				ns.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				ns.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
//				ns.dispose();
				ns = null;
				Log.info("SimpleVideo.closeNCAndNS(): now ns == null!"); 
			}
			/*if(callbackClient){
				callbackClient.destroy();
				callbackClient = null;
			}*/
			if(nc){
				nc.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				nc.removeEventListener(ErrorEvent.ERROR, errorHandler);
				nc.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				nc.close();
				nc = null;
			}
		}
		
		public function stopVideo():void{
			//EIUtil.logTrace(this+" stopVideo()");
			isPlaying = false;
			_isVideoPlayStarted = false;
			stopPlayingStatusTimer();
			stopLoadingStatusTimer();
			/*seek(0);
			if(ns){
				ns.pause();
			}*/
//			setTimeout(this.clear, 500);
			
//			this.clear();
//			Log.info("SimpleVideo.stopVideo() : seek(0)"); 
			Log.info("SimpleVideo.stopVideo()"); 
		}
		
		private var _volume:Number;
		
		public function set volume(value:Number):void {
			_volume = value;
			updateVideoVol();
		}
		
		private function updateVideoVol():void {
			if(!ns)return;
			var st:SoundTransform = ns.soundTransform;
			st.volume = _volume;
			ns.soundTransform = st;
		}
		
		public function get volume():Number {
			if(ns)
				_volume = ns.soundTransform.volume;
			
			return _volume;
		}
		
		private function initPlayingStatusTimer():void{
			if(!isReportPlayingStatus) 
				return;
			if(!playingStatusTimer){
				reportPlayingStatus();
				playingStatusTimer = new Timer(reportStatusInterval*1000, 0);
			}
			if(!playingStatusTimer.running){
				playingStatusTimer.start();
				playingStatusTimer.addEventListener(TimerEvent.TIMER, reportPlayingStatus);
			}
		}
		
		private function stopPlayingStatusTimer():void{
			if(playingStatusTimer){
				playingStatusTimer.stop();
				playingStatusTimer.removeEventListener(TimerEvent.TIMER, reportPlayingStatus);
				playingStatusTimer = null;
			}
		}
		
		private function reportPlayingStatus(e:TimerEvent=null):void{
			//if(ns)
				//EIUtil.logTrace(this+" reportPlayingStatus() "+ns.time+" duration:"+duration);
			if(duration==0)return;
			if(ns)
				dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.PLAYING_PROGRESS, ns.time));
		}
		
		private function asyncErrorHandler(event:AsyncErrorEvent):void {
			//ignore metadata error message
			//trace(this + "	asyncErrorHandler->>"+event.text);
		}
		
		public function onLoadComplete():void{
			//EIUtil.logTrace(this + " onLoadComplete")
			CONFIG::debug
			{
				Log.info("SimpleVideo.onLoadComplete() : video loading " + loadIdx + " complete!" + "  _url = " + _url);
			}
			if(!_hasInited)
			{
				dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.LOAD_COMPLETE, ns.time));
				if(_loadedFunc!=null){
					_loadedFunc.apply();
				}
				_hasInited = true;
			}
		}
		/**
		 * 缓冲中
		 * 
		 */	
		public function onBuffering():void{
			//trace(this + " onBuffering");
			dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.BUFFER_EMPTY));
		}
		
		protected function onBufferFull():void{
			//trace(this +" onBufferFull");
			dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.BUFFER_FULL));
		}
		
		protected function onBufferFlush():void{
			//EIUtil.logTrace(this +" onBufferFlush - isPlaying"+isPlaying);
			if(_isPlaying){//如果是正在播放状态，却遇到了Flush的情况，则可能导致异常暂停，所以在此强行继续播放
				//EIUtil.logTrace("如果是正在播放状态，却遇到了Flush的情况，则可能导致异常暂停，所以在此强行继续播放");
				//resumeVideo();
			}
			//var delayResume:DelayFuncionCall = new DelayFuncionCall(resumeAfterFlush, 1000);
		}
		
		private function resumeAfterFlush():void{
			//trace("确保在异常暂停情况下继续播放视频");
		}
		
		protected function onResumed():void{
			//trace(this +" onResumed");
			dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.NS_RESUMED));
			if(isStreamStarted){
				onNSPlayStart();
			}
		}
		
		protected function onPaused():void{
			//trace(this +" onResumed");
			dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.NS_PAUSED));
		}
		
		/**
		 * 播放完成后调度
		 * 
		 */		
		public function onPlayComplete():void{
			//EIUtil.logTrace(this+" onPlayComplete" +this.ns.time);
			dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.PLAY_COMPLETE, this.ns.time));
			if(isCloseAfterPlayComplete){//如果播放完毕，需要自我销毁，就直接关闭视频，否则只是断开连接，但最后一帧画面不消失
				Log.info("SimpleVideo.onPlayComplete() : closeVideo()");
				closeVideo();
			}else{
				Log.info("SimpleVideo.onPlayComplete() : stopVideo()");
				stopVideo();
			}
//			dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.PLAY_COMPLETE, this.ns.time));
		}
		
		protected function onNSPlayStart():void{
			dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.NS_PLAY_START));
		}
		

		
		protected function onVideoPlayStart():void{
			if(_isVideoPlayStarted == false){
				dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.VIDEO_PLAY_START));
				_isVideoPlayStarted = true;
//				_isPlaying = true;
			}
		}
		
		/**
		 *  
		 * @param event
		 * 
		 */		
		private function netStatusHandler(event:NetStatusEvent):void {
			//PAPManager.instance().log(this+" netStatusHandler:"+event.info.code)
			//if(ns){
				//trace("已经加载：" + (ns.bytesLoaded/ns.bytesTotal * 100) + "%");
				//trace("bufferLength " + ns.bufferLength +" bufferTime:"+ ns.bufferTime);
			//}
			Log.info("simpleVideo.netStatusHandler() : event.info.code = " + event.info.code);
			// 顺序依次为：Success --> Start --> Notify --> Full
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					//connectStream();
					break;
				case "NetStream.Play.Start":
					dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.NS_PLAY_START2));
					//trace(url+"Start [" + ns.time.toFixed(3) + " seconds] autoPlay"+autoPlay);
					onReadyToPlay();
					if(autoPlay==false ){
						pauseVideo();
					}else{
						isPlaying = true;
						onNSPlayStart();
					}
					isStreamStarted = true;
					break;
				case "NetStream.Play.Stop":
					dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.PLAY_COMPLETE2));
//					//EIUtil.logTrace("Stop [" + ns.time.toFixed(3) + " seconds]");
//					//isPlaying = false;
					onPlayComplete();
					if(ExternalInterface.available)
					{
						try
						{
							ExternalInterface.call("console.log", "SimpleVideo.netStatusHandler(): NetStream.Play.Stop!");
						} 
						catch(error:Error) 
						{
							
						}
						
					}
					/*setTimeout(function():void{
						dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.PLAY_COMPLETE2));
						onPlayComplete();
					}, TIME_DELAY_TO_FINISH * 1000);*/
					break;
				case "NetStream.Play.Complete":
					isPlaying = false;
					_isVideoPlayStarted = false;
					break;
				case "NetStream.Pause.Notify":
					onPaused();
					break;
				case "NetStream.Unpause.Notify":
					onResumed();
					break;
				case "NetStream.Seek.Notify":
					_isVideoPlayStarted = false;
					break;
				case "NetStream.SeekStart.Notify":
					
					break;
				case "NetStream.Buffer.Flush":
//					onVideoPlayStart();
					//数据已完成流式加载，并且剩余缓冲区被清空。
					//onBufferFlush();
					break;
				case "NetStream.Buffer.Empty":
					onBuffering();//缓冲状态
//					onPlayComplete();
//					setupNS();
					break;
				case "NetStream.Buffer.Full":
					dispatchEvent(new SimpleVideoEvent(SimpleVideoEvent.BUFFER_FULL2));
					if(_isPlaying)
						onVideoPlayStart();
					
					//缓冲区已满，流开始播放。
					onBufferFull();
					break;
				case "NetStream.Video.DimensionChange":
					Log.info("SimpleVideo.netStatusHandler():NetStream.Video.DimensionChange");
					break;
				case "NetStream.Play.StreamNotFound":
					if(ExternalInterface.available)
					{
						try
						{
							ExternalInterface.call("console.log", "SimpleVideo.netStatusHandler(): NetStream.Play.StreamNotFound!");
						} 
						catch(error:Error) 
						{
							
						}
					}
					
					ioErrorHandler();
					break;
			}
		}
		
		protected function errorHandler(event:ErrorEvent = null):void
		{
			// TODO Auto-generated method stub
			Log.info("SimpleVideo.onErrorHandler() : " + event);
		}
		
		protected function ioErrorHandler(event:IOErrorEvent = null):void {
			_isStreamFound = false;
			//trace("Unable to locate video: " + _url);
			Log.info("SimpleVideo.ioErrorHandler() : Unable to locate video: " + _url);
		}
		
		protected function securityErrorHandler(event:SecurityErrorEvent = null):void {
			//trace("securityErrorHandler: " + event);
			Log.info("SimpleVideo.securityErrorHandler() : Unable to locate video: " + _url);
		}
		
		public function get currentTime():Number{
			if(ns)
				return ns.time;
			else
				return 0;
		}
	
		protected function onReadyToPlay():void{
			
		}
		
		public function replay():void{
//			seek(0);
			if(!ns)
				return;
			Log.info("SimpleVideo.replay() :  ns.time = " + ns.time);
			resumeVideo();
//			playVideo();
		}
		
		public function seek(offset:Number, needPlay:Boolean = true):void{
			trace(this+" seek()"+offset);
			if(ns)
			{
				ns.seek(offset);
//				ns.play2();
				if(needPlay)
				{
					ns.resume();
				}
			}
		}

		/** 当前已经加载到的视频流的时长 */
		public function get curLoadedVideoTime():Number
		{
			return _curLoadedVideoTime;
		}

		/** 当前已经加载的视频流的百分比 */
		public function get curLoadedPercent():int
		{
			return _curLoadedPercent;
		}

		public function get loadComplete():Boolean
		{
			return _loadComplete;
		}

		public function get hasInited():Boolean
		{
			return _hasInited;
		}
		
		public function removeNetStream():void
		{
			if(ns)
			{
//				ns.pause();
				ns.dispose();
				ns = null;
			}
		}
		
	}

}