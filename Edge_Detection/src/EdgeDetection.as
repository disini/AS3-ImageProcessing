package 
{
	import com.adobe.serialization.json.JSON;
	import com.greensock.TweenLite;
	import com.kyo.event.MultiURLsRetryEvent;
	import com.kyo.event.RetryEvent;
	import com.kyo.event.simpleVideo.DynamicEvent;
	import com.kyo.event.simpleVideo.SimpleVideoEvent;
	import com.kyo.media.simpleVideo.SimpleRetryVideo;
	import com.shen100.log.Logger;
	import com.utils.Log;
	import com.view.bar.PlayControlBar;
	import com.vpaid.VPAIDEvent;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import net.hires.debug.Stats;
	
	import utils.VideoGraphicsController;
	
	/**
	 * 影谱播放器
	 * Author: LiuSheng QQ：532230294
	 * Email:  liusheng@zhiruyi.com
	 * */
	[SWF(width="960", height="600", backgroundColor = "0xff6600", frameRate="25")]
//	[SWF(width="800", height="450", backgroundColor = "0xff6600", frameRate="25")]
//	[SWF(width="690", height="500", backgroundColor = "0x2E2E2E", frameRate="60")]
//	[SWF(backgroundColor = "0xff6600", frameRate="25")]
//	[SWF(width="805", height="520", backgroundColor = "0xff0000", frameRate="60")]
	public class EdgeDetection extends Sprite {
		/** 视频容器，拖拽和记录位置的就是这个 */
		private var mainVideoContainer:Sprite;
		private var mainVideo:SimpleRetryVideo;
		private var controlBar:PlayControlBar;
//		private var version:String = "1.8.13";
//		private var version:String = "LSPlayer_LaunchPreview_20170801A";
		private var playerName:String = "MovieBook Video Player";
		private var version:String = "20170804E";
		/** 网页编辑器部分需要的配置文件 */
		private var editorConfig:Object;
		/** 此SWF文件需要嵌入的配置文件 */
		private var acConfig:Object;
		/** 各种资源所在目录的路径 */
		private var assetUrl:String;
//		private var jsContext:String;
		
		private var btnLayer:Sprite;
		private var videoLayer:Sprite;
		private var childVideoLayer:Sprite;
		private var curTimeTxt:TextField;
		
		/** 供点击的图标 */
		private var btn0:Sprite;
		private var btn1:Sprite;
		private var btn2:Sprite;
		private var btn3:Sprite;
		private var btn4:Sprite;
		
		/** 播放按钮 */
		private var playBtn:CenterPlayButton2;
		
		private var closeBtnUrl:String;
		
		private var applicationDmArr:Array = [];
		
		/** 画中画的视频 */
		
		private var video0:SimpleRetryVideo;
		private var video1:SimpleRetryVideo;
		private var video2:SimpleRetryVideo;
		private var video3:SimpleRetryVideo;
		private var video4:SimpleRetryVideo;
		
		private var curShownVideo:SimpleRetryVideo;
		
		public var curLoadingProgress:Number = 0;
		
		private var conn:LocalConnection;
		private var bytes:ByteArray;
		
		private var snapSDKUrl:String = "http://open.videoyi.com/sdk/player/SnapShotter/SnapShotter.swf";
		private var toolContainerUrl:String = "http://open.videoyi.com/sdk/player/container/ToolContainer.swf";
//		private var videoESdkUrl:String = "http://open.videoyi.com/sdk/VideoE/wasu/VideoEOverlayTest.swf";
//		private var videoESdkUrl:String = "http://open.videoyi.com/sdk/VideoE/general/VideoEOverlayTest.swf";
//		private var videoESdkUrl:String = "http://open.videoyi.com/sdk/player/wasu/VideoEOverlay.swf";
		private var videoESdkUrl:String;
		
		private var originWidth:Number;
		private var originHeight:Number;
		
		private var originVideoWidth:Number;
		private var originVideoHeight:Number;
		private var totalVideoDuration:Number;// 视频总时长：单位为秒；
		
		private var snapShotterMC:Sprite;
		private var toolContainerMC:Sprite;
		private var videoEMC:Sprite;
		
		private var videoArea:Shape;
		
		private var selfArea:Shape;
		
		private var videoETimer:Timer;
		
//		private var _isFullScreen:Boolean;
		
		private var mainVideoMetaInfo:Object;
		
		private static const CONTROLBAR_HEIGHT:Number = 52;
		
		private var tip_layer:Sprite;
		private var operateLayer:Sprite;
		private var _highLightLayer:Sprite;
		
		private var setting_layer:Sprite;
		private var graphicsController:VideoGraphicsController;
		
		private var _mainVideoUrl:String;
		private var _urlPrefix:String;
		private var _flashvars:Object;
		private var _needAutoPlay:Boolean;
		private var _showLogo:Boolean;
		private var _showWaterMark:Boolean;
		private var _showtopBanner:Boolean = true;
		private var _showHighLight:Boolean = true;
		private var _topBanner:TopBanner2;
		private var _highLightBg:HighLightBG2;
		private var _waterMarkAd:WaterMarkMC3;
		
		private var stats:Stats;
		
		
		private var _metaInfoGotYet:Boolean = false;
		
		
		public function EdgeDetection() {
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
//			testDispatchEvent();
			Security.loadPolicyFile("http://www.yinyuetai.com/crossdomain.xml");
			Security.loadPolicyFile("http://open.videoyi.com/crossdomain.xml");
			
			Logger.debug("EdgeDetection ： " + version);
//			setData1();
			/*jsContext = loaderInfo.parameters.jsContext;
			if(!jsContext) {
				jsContext = "window.";
			}else {
				jsContext += ".";	
			}*/
			if(ExternalInterface.available)
			{
				try
				{
					//				ExternalInterface.call("alert", "LSPlayer20160802A");
					//				ExternalInterface.call(jsContext + "onReady");
					//				Logger.debug(jsContext + "onReady");
				} 
				catch(error:Error) 
				{
					Log.info("EdgeDetection.EdgeDetection() : " + error.toString());
				}

			}
//			initBaseLayer();
			addContextMenuItem();
//			initLocalConnection();
//			loadSnapShotter();
//			loadImgs();
			tip_layer = new Sprite();
			addChild(tip_layer);
			
			setting_layer = new Sprite();
//			addChild(setting_layer);
			
			initGraphicsController();
			
			videoArea = new Shape();
			selfArea = new Shape();
			
			
			
//			SystemMessage.init(tip_layer, 1280, 720);
			
//			SystemMessage.showOneByOne("editor editor editor editor!");
//			addWaterMark();
		}
		
		/*private function initBaseLayer():void
		{
			// TODO Auto Generated method stub
			_highLightBg = new HighLightBG1();
			addChild(_highLightBg);
			_topBanner = new TopBanner2();
			addChild(_topBanner);
		}*/
		
		private function addWaterMark():void
		{
			// TODO Auto Generated method stub
			_waterMarkAd = new WaterMarkMC3();
			_waterMarkAd.x = stage.stageWidth - _waterMarkAd.width;
			_waterMarkAd.y = stage.stageHeight- _waterMarkAd.height - CONTROLBAR_HEIGHT;
			_waterMarkAd.scaleX = _waterMarkAd.scaleY = 0.6;
			stage.addChild(_waterMarkAd);
			_waterMarkAd.visible = _showWaterMark;
		}
		
		private function testDispatchEvent(evt:Event = null):void
		{
			// TODO Auto Generated method stub
//			addEventListener("onTestDispatchEvent", onTestDispatchEventHandler);// 错误写法，这样捕获不到！
//			stage.addEventListener("onTestDispatchEvent", onTestDispatchEventHandler);// 错误写法，这样捕获不到！除非派发事件时开启冒泡！
//			videoEMC.addEventListener("onTestDispatchEvent", onTestDispatchEventHandler);// 成功捕获！
			var loader:Loader = evt.target.loader;
			var loaderInfo:LoaderInfo = evt.target as LoaderInfo;
			var mc:* = evt.target.content;
			
			loader.contentLoaderInfo.sharedEvents.addEventListener("onTestDispatchEvent", onTestDispatchEventHandler);// 成功捕获！
		}
		
		protected function onTestDispatchEventHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			Log.info("catch dispatchEvent from VideoE SDK successfully！");// 成功捕获！
		}
		
		private function initGraphicsController():void
		{
			graphicsController = new VideoGraphicsController();
			setting_layer.addChild(graphicsController);
			graphicsController.x = 20;
			graphicsController.y = 50;
			graphicsController.visible = false;
		}
		
		protected function onRemovedFromStage(event:Event):void
		{
			ExternalInterface.call("console.log", "EdgeDetection has been removed!");
		}
		
		private function onAddedToStage(event:Event) : void
		{			
			Log.info("EdgeDetection.onAddedToStage() : 播放器初始化完成------------>version: " + version);
			removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
//			ExternalInterface.call("alert", 	         "editor 20160615A");
			//			stage.scaleMode = StageScaleMode.SHOW_ALL;
			Log.info("Player version : " + version);
			stage.scaleMode = StageScaleMode.NO_SCALE;// 保持各元件不被缩放，不失真；默认值为showAll
			trace(stage.align);
			stage.align = StageAlign.TOP_LEFT;// 默认值为空""
			trace(stage.align);
			//			initBg();
			//			initWaterMark();
			//			addEventListener(Event.ADDED_TO_STAGE, initData);
//			setBaseLayer();
			
			
			originWidth = stage.stageWidth;
			originHeight = stage.stageHeight;
			addEventListener(Event.ENTER_FRAME, onEnterFrm);
			stage.addEventListener(Event.RESIZE, onResize);
			_flashvars = this.loaderInfo.parameters;
//			_flashvars = {videoUrl:"http://218.241.154.138/zhuihunji-32-440.mp4", mid:"8357159", autoPlay:"true", showLogo:"true", showWaterMark:"true", cpid:"1", title:"追婚记_第32集", cid:"8", resolution:"440000", videoESdkUrl:"VideoEOverlay.swf", autoPlay:"true"};
			_needAutoPlay = (_flashvars.autoPlay == "true");
//			_needAutoPlay = false;
			_mainVideoUrl = _flashvars.videoUrl;
			videoESdkUrl = _flashvars.videoESdkUrl;
			_showLogo = (_flashvars.showLogo == "true");
			_showWaterMark = (_flashvars.showWaterMark == "true");
//			_showtopBanner = (_flashvars.showtopBanner != null) ? (_flashvars.showtopBanner == "true") : true;
			_showtopBanner = _flashvars.showtopBanner ? (_flashvars.showtopBanner == "true") : true;
//			_showHighLight= (_flashvars.showHighLight != null) ? (_flashvars.showHighLight == "true") : true;
			_showHighLight= _flashvars.showHighLight? (_flashvars.showHighLight == "true") : true;
			setData1();
//			if(_showWaterMark)
//			{
			addWaterMark();
//			}
			//			ExternalInterface.call("alert", "stageWidth = " + stage.stageWidth + " , stageHeight = " + stage.stageHeight);
			initStats();
//			onResize();
		}
		
		private function setBaseLayer():void
		{
			_highLightBg.width = mainVideoContainer.width;
			_highLightBg.height = mainVideoContainer.height;
			_highLightBg.x = mainVideoContainer.x + mainVideoContainer.width / 2;
			_highLightBg.y = mainVideoContainer.y + mainVideoContainer.height / 2;
			
//			_topBanner.bar.width = stage.stageWidth - _topBanner.logo.width;
			_topBanner.bar.width = stage.stageWidth;
//			_topBanner.scaleX = _topBanner.scaleY = stage.stageWidth / 1920;
		}
		
		private function initStats():void
		{
			stats = new Stats();
			stats.x = 50;
			stats.y = 50;
			addChild(stats);
		}
		
		protected function onResize(evt:Event = null):void
		{
			if(!originVideoWidth || !originVideoHeight)
				return;
			//			ExternalInterface.call("eval","console.log(222)");
			
			var _stageScale:Number = Math.min(stage.stageWidth / originWidth, stage.stageHeight / originHeight);
			var _videoScale:Number = Math.min(stage.stageWidth / originVideoWidth, (stage.stageHeight - CONTROLBAR_HEIGHT - _topBanner.height) / originVideoHeight);
			if(controlBar && this.contains(controlBar))
			{
				this.removeChild(controlBar);
			}
			
			if(this.contains(selfArea))
			{
				this.removeChild(selfArea);
			}
			
			if(mainVideoContainer.contains(videoArea))
			{
				mainVideoContainer.removeChild(videoArea);
			}
			
			
			
			if(mainVideoContainer.contains(mainVideo))
			{
				mainVideoContainer.removeChild(mainVideo);
			}
			
			if(videoLayer && videoLayer.contains(mainVideoContainer))
			{
				videoLayer.removeChild(mainVideoContainer);
			}
			
			if(this.contains(curTimeTxt))
			{
				this.removeChild(curTimeTxt);
			}
			
			
			mainVideo.width =  stage.stageWidth;
		
			mainVideo.height = stage.stageHeight;
			
			mainVideoContainer.addChild(mainVideo);
			videoLayer.addChildAt(mainVideoContainer, 0);
//			mainVideoContainer.visible = false;
			
			videoArea.graphics.clear();
			videoArea.graphics.lineStyle(1, 0xff00ff);// 紫色框
			videoArea.graphics.drawRect(0, 1, mainVideoContainer.width - 2, mainVideoContainer.height - 2);
			videoArea.visible = false;
			
			mainVideoContainer.addChild(videoArea);
			
			curTimeTxt.x = stage.stageWidth - 20 - curTimeTxt.width;
			curTimeTxt.y = 20;
			
			curTimeTxt.visible = false;
			addChild(curTimeTxt);
//			videoEMC && videoEMC["resizeAd"]();
			selfArea.graphics.clear();
			selfArea.graphics.lineStyle(1, 0x00ff00);// 绿框
			selfArea.graphics.drawRect(0, 0, this.width - 2, this.height - 2);
			addChild(selfArea);
			selfArea.visible = false;
			trace(this.width, stage.stageWidth);
			videoEMC && videoEMC["resizeAd"](mainVideoContainer.width, mainVideoContainer.height, "normal", mainVideoContainer.x, mainVideoContainer.y);
			controlBar.width = stage.stageWidth;
			controlBar.y = stage.stageHeight - CONTROLBAR_HEIGHT;
			addChild(controlBar);
			_waterMarkAd.x = stage.stageWidth - _waterMarkAd.width;
			_waterMarkAd.y = stage.stageHeight- _waterMarkAd.height - CONTROLBAR_HEIGHT;
			playBtn.x = stage.stageWidth/2;
			playBtn.y = stage.stageHeight/2;
			Log.info("EdgeDetection.onResize() : stage.stageWidth = " + stage.stageWidth + ", stage.stageHeight = " + stage.stageHeight);
			setBaseLayer();
		}
		
		/**
		 *  
		 * 
		 */		
		public function onSeekTo():void
		{
			videoEMC && videoEMC["seekAd"]();
		}
		
		
		
		
		protected function onNeedManualSeek(event:Event):void
		{
			mainVideo.seek(mainVideo.currentTime);
			onSeekTo();
		}
		
		private function onVideoEAdLoaded(evt:Event):void
		{
			
//			videoEMC && videoEMC
			videoEMC && videoEMC["resizeAd"](mainVideoContainer.width, mainVideoContainer.height, "normal", mainVideoContainer.x, mainVideoContainer.y);
//			mainVideo.visible = true;
//			if(_flashvars.autoPlay == "true")
			if(_needAutoPlay)
			{
				mainVideo.replay();// 加载完SDK后再播放
//				onVideoResumed();
			}
			videoEMC.addEventListener("NeedVideoPause", needVideoPause);
			videoEMC.addEventListener("NeedVideoResume", needVideoResume);
		}
		
		public function needVideoPause(e:Event = null):void{
			//收到暂停事件时，将正片暂停
			mainVideo.pauseVideo();
			controlBar.onPauseVideo();
		}
		
		public function needVideoResume(e:Event = null):void{
			//收到恢复事件时，请将主视频恢复播放
			mainVideo.resumeVideo();
			controlBar.onResumeVideo();
		}
		
		protected function onVideoETimer(event:TimerEvent):void
		{
			/*if(mainVideo && mainVideo.visible)
			{
				if(mainVideo.curLoadedVideoTime - mainVideo.currentTime < 20)
				{
					if(mainVideo.isPlaying)
					{
						needVideoPause();
					}
				}
//				else	if(mainVideo.curLoadedVideoTime - mainVideo.currentTime > 40)
//				{
//					needVideoResume();
//				}
			}*/
			if(videoEMC && 1)
			{
				videoEMC["changeVideoTime"](mainVideo.currentTime);
				if(mainVideo.currentTime)
				{
//					trace("mainVideo.currentTime = " + mainVideo.currentTime);
				}
//				trace("mainVideo.curLoadedVideoTime = " + mainVideo.curLoadedVideoTime * 1000 + "ms");
			}
		}
		
		protected function onEnterFrm(evt:Event):void
		{
			controlBar && controlBar.onEnterFrm(evt);
//			return;
//			if(videoEMC && 1)
//			{
////				videoEMC["changeVideoTime"](mainVideo.currentTime);
//			}
		}
		
		protected function onVideoEIOError(event:IOErrorEvent):void
		{
			trace("onIOError");
		}
		
		/*public function initLocalConnection():void {
			conn = new LocalConnection();
			conn.client = this;
			if (loaderInfo.parameters.localName) {
				try {
					conn.connect(loaderInfo.parameters.localName);
				} catch (error:ArgumentError) {
					
				}	
			}
		}*/
		
		private function addContextMenuItem():void {
			var menu:ContextMenu = contextMenu;
			if(!menu) {
				menu = new ContextMenu();
			}
			var nameItem:ContextMenuItem = new ContextMenuItem(playerName, false, false);
			var versionItem:ContextMenuItem = new ContextMenuItem(version, false, false);
			menu.customItems.push(nameItem, versionItem);
			menu.hideBuiltInItems();
			contextMenu = menu;
		}
		
		public function init():void {
			Logger.debug("init();");
			
			if(!mainVideoContainer) {
				mainVideoContainer = new Sprite();
				mainVideoContainer.name = "mainVideoContainer";
				if(!mainVideo)
				{
					mainVideo = new SimpleRetryVideo();
//					mainVideo.autoPlay = false;// 默认是true
//					mainVideo.autoPlay = (_flashvars.autoPlay == "true");// 默认是true
					mainVideo.autoPlay = _needAutoPlay;// 默认是true
					trace("mainVideo.autoPlay = " + mainVideo.autoPlay);
					mainVideo.smoothing = true;
					mainVideo.volume = 0.5;
//					mainVideo.visible = false;
					mainVideoContainer.addChild(mainVideo);
					graphicsController.displayTarget = mainVideo;
					
//					mainVideo.width  = acConfig.mainVideo.width;
//					mainVideo.height = acConfig.mainVideo.height;
					
//					mainVideoContainer.x = acConfig.mainVideo.x;
//					mainVideoContainer.y = acConfig.mainVideo.y;
					
//					mainVideoContainer.y = (stage.stageHeight - mainVideo.height)/2;
					
					mainVideo.addEventListener(SimpleVideoEvent.LOADING_PROGRESS, mainVideoLoading);//视频加载中
					mainVideo.addEventListener(SimpleVideoEvent.PLAYING_PROGRESS, mainVideoPlayingProgress);//视频播放中
					mainVideo.addEventListener(SimpleVideoEvent.PLAY_COMPLETE, mainVideoPlayComplete);//视频播放完成
					mainVideo.addEventListener(SimpleVideoEvent.NS_PLAY_START2, onReadyToPlay);
					mainVideo.addEventListener(SimpleVideoEvent.LOAD_COMPLETE, onLoadComplete);
					mainVideo.addEventListener(SimpleVideoEvent.BUFFER_FULL, onBufferfull);
					mainVideo.addEventListener(MultiURLsRetryEvent.ALL_GSLB_ERROR, onVideoError);//所有调度失败
					mainVideo.addEventListener(RetryEvent.RETRY_FAILED, onVideoError);
					mainVideo.addEventListener(SimpleVideoEvent.NS_PAUSED, onVideoPaused);
					mainVideo.addEventListener(SimpleVideoEvent.NS_RESUMED, onVideoResumed);
					mainVideo.addEventListener(SimpleVideoEvent.GOT_METADATA, onGotMainVideoMetaInfo);
				}
				
				Logger.debug("MainVideoView init();");
//				setMainVideoUrl(_mainVideoUrl);
//				setMainVideoUrl(_urlPrefix + _mainVideoUrl);
//				setMainVideoUrl("http://open.videoyi.com/sdk/videos/ffx14.mp4");
//				setMainVideoUrl("video12-26.mp4");
//				setMainVideoUrl("http://localhost/video/jbx.mp4");
//				setMainVideoUrl("http://localhost/video/wanwushengzhang.mp4");
//				setMainVideoUrl("http://localhost/video/nvhai_weilian720p.mp4");
				setMainVideoUrl("http://testopen.videoyi.com/video/ppq/fzd-vs-lgy.mp4");
				
				mainVideoContainer.addEventListener(MouseEvent.CLICK, onMouseClick);	
				mainVideoContainer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);	
				mainVideoContainer.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);	
			}
			stage.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			
			btnLayer = new Sprite();
			addChild(btnLayer);
			
			videoLayer = new Sprite();
			videoLayer.name = "videoLayer";
			addChild(videoLayer);
			
			childVideoLayer = new Sprite();
			addChild(childVideoLayer);
			
			videoLayer.addChildAt(mainVideoContainer, 0);
			initText();
			initControlBar();
			trace("stage.frameRate = " +  stage.frameRate);
			
			addChild(setting_layer);
			initHighLightLayer();
			initOperateLayer();
			//setMainVideoUrl(_mainVideoUrl);
		}
		
		private function initHighLightLayer():void
		{
			// TODO Auto Generated method stub
			_highLightLayer = new Sprite();
			_highLightLayer.mouseChildren = false;
			_highLightLayer.mouseEnabled = false;
			addChild(_highLightLayer);
			_highLightBg = new HighLightBG2();
			_topBanner = new TopBanner2();
			
			if(_showHighLight)
			{
				_highLightLayer.addChild(_highLightBg);
			}
			if(_showtopBanner)
			{
				_highLightLayer.addChild(_topBanner);
			}
		}
		
		private function initControlBar():void
		{
			controlBar = new PlayControlBar(mainVideo, this, _needAutoPlay, _showLogo, stage.stageWidth);
			controlBar.addEventListener("NeedToHidePlayButton", hidePlayButton);
			controlBar.addEventListener("NeedToShowPlayButton", showPlayButton);
			controlBar.addEventListener("RaiseUpControlBar", onShowTopBanner);
			controlBar.addEventListener("DropDownControlBar", onHideTopBanner);
		}
		
		protected function onHideTopBanner(event:Event):void
		{
			TweenLite.to(_topBanner, 0.5, {y:-_topBanner.height});
		}
		
		protected function onShowTopBanner(event:Event):void
		{
			TweenLite.to(_topBanner, 0.5, {y:0});
		}
		
		private function initOperateLayer():void
		{
			operateLayer = new Sprite();
			addChild(operateLayer);
			
			playBtn = new CenterPlayButton2();
			playBtn.scaleX = playBtn.scaleY = 0.5;
			playBtn.x = stage.stageWidth/2;
			playBtn.y = stage.stageHeight/2;
//			playBtn.x = 480;
//			playBtn.y = 270;
			playBtn.mouseEnabled = false;
			//			playBtn.buttonMode = true;
			//			playButton.mouseChildren = false;
			playBtn.addEventListener(MouseEvent.CLICK, onClickPlayBtn);
			_highLightBg.visible = playBtn.visible = !_needAutoPlay;
			operateLayer.addChild(playBtn);
			
		}
		
		protected function onClickPlayBtn(event:MouseEvent):void
		{
//			controlBar.onReplayVideo();
//			if()
//			{
//			needVideoResume();
//			}
//			else
//			{
//				
//			}
			
//			needVideoResume();
			controlBar.playButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		protected function onGotMainVideoMetaInfo(evt:SimpleVideoEvent):void
		{
			if(!_metaInfoGotYet)
			{
				mainVideoMetaInfo = evt.info;
				originVideoWidth = evt.info.width;
				originVideoHeight = evt.info.height;
				totalVideoDuration = evt.info.duration;
//				onResize();
				if(!videoEMC)
				{
//					loadVideoESDK();
				}
//				initControlBar();
				_metaInfoGotYet = true;
				playBtn.mouseEnabled = true;
				stage.frameRate = evt.info.videoframerate;
				onResize();
			}
		}		
		protected function onLoadComplete(evt:SimpleVideoEvent):void
		{
			trace("onLoadComplete");
		}
		
		protected function onBufferfull(evt:SimpleVideoEvent):void
		{
			trace("onBufferfull");
		}
			
		
		
		
		private function initText():void
		{
			curTimeTxt = new TextField();
			var textFmt:TextFormat = new TextFormat(null, 30, 0xff0000, true);
			curTimeTxt.defaultTextFormat = textFmt;
			curTimeTxt.autoSize = TextFieldAutoSize.CENTER;
			curTimeTxt.text = "00.00";
			addChild(curTimeTxt);
			curTimeTxt.visible = false;
			/*curTimeTxt.x = stage.stageWidth - 20 - curTimeTxt.width;
			curTimeTxt.y = 20;*/
		}
		
		private function mainVideoLoading(e:SimpleVideoEvent): void {
//			trace("mainVideoLoading" + e.toString() + " , " +　e.data);
			curLoadingProgress = e.data / 100;
		}
		
		
		private function mainVideoPlayingProgress(e:SimpleVideoEvent): void {
			//			trace("mainVideoLoading" + e.toString() + " , " +　e.data);
//			curLoadingProgress = e.data / 100;
//			videoEMC && videoEMC["changeVideoTime"](e.data);
//			controlBar.updateBar(e.data);
		}
		
		private function onReadyToPlay(e:SimpleVideoEvent):void
		{
//			originVideoWidth = mainVideo.width;
//			originVideoHeight = mainVideo.height;
//			onResize();
		}	
		
		private function mainVideoPlayComplete(e:SimpleVideoEvent): void {
//			this.stopAd();
//			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdStopped));
//			dispatchEvent(new Event("MainVideoPlayComplete"));
			videoEMC && videoEMC["mainVideoPlayComplete"]();
//			controlBar.playButton.mouseEnabled = false;
			controlBar.onPlayComplete();
		}
		
		private function onVideoPaused(evt:Event):void
		{
			showPlayButton();
			videoEMC && videoEMC["pauseAd"]();
		}
		
		private function onVideoResumed(evt:Event):void
		{
			hidePlayButton();
			videoEMC && videoEMC["resumeAd"]();
		}	
		
		private function onMouseDown(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
		}
		
		private function onMouseClick(evt:MouseEvent = null):void
		{
			evt && evt.stopImmediatePropagation();
			if(mainVideo.isPlaying)
			{
				mainVideo.pauseVideo();
				controlBar.onPauseVideo();
			}
			else
			{
				mainVideo.resumeVideo();
				controlBar.onResumeVideo();
			}
		}
		
		
		public function showPlayButton(e:Event = null):void
		{
			_highLightBg.visible = playBtn.visible = true;
			
		}
		
		public function hidePlayButton(e:Event = null):void
		{
			_highLightBg.visible = playBtn.visible = false;
		}
		
		private function onMouseUp(evt:MouseEvent):void
		{
//			evt.stopImmediatePropagation();
			controlBar && controlBar.forceStopDrag();
		}
		
		private function onMouseMove(evt:MouseEvent):void
		{
//			trace("onMouseMove");
			controlBar.onDragMouseMove();
		}	
		
		private function onRollOut(evt:MouseEvent):void
		{
			if(evt.target == stage)
			{
				controlBar && controlBar.forceStopDrag();
			}
		}
		
		public function updateCurTime(timeStr:String):void
		{
//			curTimeTxt.text = "当前视频播放位置：" + timeStr;
			curTimeTxt.text = timeStr;
		}
		
		
		
		private function setData1():void
		{
			init();
		}
		
		public function setMainVideoUrl(url:String):void {
			//acConfig.mainVideo.url  = url;
			mainVideo.url = url;
			Logger.debug("mainVideo url : " + url);
		}
		
		
		private function onVideoError(evt:DynamicEvent):void
		{
			trace("onVideoError : " + evt.data.requestURL);
		}
		
		
		private function onError(evt:Event):void
		{
			trace("onError:" +  evt.type + " , " + evt.toString());
			Logger.debug("onError:" +  evt.type + " , " + evt.toString());
		}
		
		
		/** 当前是否处于全屏状态 */
		public function get isFullScreen():Boolean
		{
			if(controlBar)
				return false;
			return controlBar.isFullScreen;
		}
		
	}
}
