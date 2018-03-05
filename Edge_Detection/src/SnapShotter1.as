package
{
	import com.kyo.media.simpleVideo.SimpleRetryVideo;
	import com.manager.GlobalManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	import flash.utils.setTimeout;
	
	import utils.Calculation;
	
//	[SWF(width="640", height="360", frameRate="60")]
	public class SnapShotter1 extends Sprite
	{
		private var bgArea:Shape;
		private var snapShotLayer:Sprite;
		
		private var snapBitmap:Bitmap;
		private var curOriginFrameImage:BitmapData;
		private var curFrameImage:BitmapData;
//		private var _mainVideo:Video;
		private var _mainVideo:SimpleRetryVideo;
		
		private var _videoShowWidth:Number;
		private var _videoShowHeight:Number;
		
		private var _videoMetaWidth:Number;
		private var _videoMetaHeight:Number;
		
		private var _videoScale:Number;
		/** 正片播放器实例（video父容器） */
		private var _videoPlayer:DisplayObjectContainer;
		
		
		private var _imageLoadedCount:int = 0;
		private var _switchFuncInited:Boolean = false;
		private var _needUpdateSnap:Boolean = true;
		
		private var _enoughFramesSnapedYet:Boolean = false;
		
		private var overLayLayer:Sprite;

		
		private var _hasInited:Boolean = false;
		
	
		
		private var drawRectColor:uint;
		
		private var _curAccurateFrame:Number;
		private var _curAccurateTime:Number;
		private var _curFrame:int;
		
//		public var updateSnapCallBackFunc:Function;
		
		public function SnapShotter1()
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener("mainVideoPaused", onVideoPauseHandler);
			addEventListener("mainVideoResumed", onVideoResumeHandler);
			
			GlobalManager.snapShotter = this;

			/*updateSnapCallBackFunc = function():void
				{
				if(GlobalManager.needAutoCheckFragment && !GlobalManager.isVideoPaused)
				{
					autoCheckFragment1();
				}
			};*/
		}
		
		
		
		private function initLayer():void
		{
			snapShotLayer = new Sprite();
			addChild(snapShotLayer);
			
//			targetRectLayer = new Sprite();
//			addChild(targetRectLayer);
			

		}
		
		
		protected function onVideoPauseHandler(event:Event):void
		{
			_needUpdateSnap = false;
			GlobalManager.isVideoPaused = true;
			if(_videoPlayer && snapBitmap)
			{
			 	snapBitmap.bitmapData.draw(_videoPlayer);
			}
			//if(snapBitmap)
			//{
				//TweenLite.to(snapBitmap, 0.5, {scaleX:1, scaleY:1, alpha:1});
			//}
			
		}
		
		protected function onVideoResumeHandler(event:Event):void
		{
			_needUpdateSnap = true;
			GlobalManager.isVideoPaused = false;
			//if(snapBitmap)
			//{
				//TweenLite.to(snapBitmap, 0.5, {scaleX:0.1, scaleY:0.1, alpha:0});
			//}
			
		}
		
		
		

		protected function onAddedToStage(event:Event):void
		{
			if(_hasInited)
				return;
			
//			_mainVideo = GlobalManager.findVideoContainer(this.parent.parent) as SimpleRetryVideo;
			_mainVideo = GlobalManager.findVideoContainer(this.root as DisplayObjectContainer) as SimpleRetryVideo;
			_videoShowWidth = _mainVideo.width;
			_videoShowHeight = _mainVideo.height;
			_videoMetaWidth = _mainVideo.metaDataInfo.width;
			_videoMetaHeight = _mainVideo.metaDataInfo.height;
			
			_videoScale = Math.min(_videoShowWidth/_videoMetaWidth, _videoShowHeight/_videoMetaHeight);
			
			_videoPlayer =_mainVideo.parent;
			setTimeout(snapShotRoot, 1000);
			initLayer();
//			initButtons();
//			initSwitchFunc();
			_hasInited = true;
		}
		
		protected function onUpdateSnap(event:Event = null, callBack:Function = null):void
		{
			//if(!_needUpdateSnap || !_mainVideo.isPlaying)
			if(!_needUpdateSnap || GlobalManager.isVideoPaused)
				return;
				
			/*if(GlobalManager._totalTimeDict.length >= GlobalManager.MAX_FRAMES_NUM)
			{
				GlobalManager._totalTimeDict.shift();
				GlobalManager._totalAccurateFrameDict.shift();
				GlobalManager._totalFrameDict.shift();
			}
			
			GlobalManager._totalTimeDict.push(_curAccurateTime);
			GlobalManager._totalAccurateFrameDict.push(_curAccurateFrame);
			GlobalManager._totalFrameDict.push(_curFrame);
			GlobalManager.snappedFramesNum = GlobalManager._totalSnapBmdDict.length;
			GlobalManager.curSelectedIdx = GlobalManager._totalSnapBmdDict.length - 1;*/
			
			if(snapBitmap && snapBitmap.bitmapData)
			{
//				var bmd:BitmapData = new BitmapData(_videoPlayer.width, _videoPlayer.height);
//				bmd.draw(_videoPlayer);
				curOriginFrameImage.lock();
				curOriginFrameImage.draw(_videoPlayer);
				curOriginFrameImage.unlock();
//				Calculation.sobelFilter(curOriginFrameImage);
//				curFrameImage = Calculation.sobelFilter(curOriginFrameImage);
//				snapBitmap.bitmapData = Calculation.grayFilter(curOriginFrameImage);
//				snapBitmap.bitmapData = Calculation.sobelFilter(curOriginFrameImage);
				snapBitmap.bitmapData.lock();
				var bmd:BitmapData = Calculation.sobelFilter(curOriginFrameImage).clone();
				snapBitmap.bitmapData = bmd;
				snapBitmap.bitmapData.unlock();
				
//				snapBitmap.bitmapData.draw(_videoPlayer);
				
				/* if(GlobalManager._totalSnapBmdDict.length >= GlobalManager.MAX_FRAMES_NUM)
				{
					if(!_enoughFramesSnapedYet)
					{
						_enoughFramesSnapedYet = true;
						if(ExternalInterface.available)
						{
							//ExternalInterface.call("onNotifyJsEnoughSnapShotsGotYet");
						}
					}
					GlobalManager._totalSnapBmdDict.shift();
				}
			
				GlobalManager._totalSnapBmdDict.push(bmd);
				GlobalManager.snappedFramesNum = GlobalManager._totalSnapBmdDict.length;
			}*/
			
				if(callBack != null)
				{
					callBack();
				}
			}
		}

		
		public function snapShotRoot():void
		{
//			var curFrameImage:BitmapData;

			curOriginFrameImage = new BitmapData(_videoPlayer.width, _videoPlayer.height);

			curOriginFrameImage.draw(_videoPlayer);
//			curFrameImage = curOriginFrameImage.clone();
			
			snapBitmap = new Bitmap(Calculation.resultBmd);
			//snapBitmap.alpha = 0.3;
			snapBitmap.scaleX = snapBitmap.scaleY = 0.6;
			snapShotLayer.addChild(snapBitmap);
		}
		
		
		
		
		private function initBgArea():void
		{
			bgArea = new Shape();
			bgArea.graphics.clear();
			bgArea.graphics.beginFill(0x0000ff, 0.3);
//			bgArea.graphics.drawRect(0, 0, 640, 360);
//			bgArea.graphics.drawRect(0, 0, _videoShowWidth, _videoShowHeight);
			bgArea.graphics.drawRect(0, 0, GlobalManager.MAINVIDEO_WIDTH, GlobalManager.MAINVIDEO_HEIGHT);
			bgArea.graphics.endFill();
			addChild(bgArea);
//			bgArea.visible = false;
		}

		public function onFrameUpdate():void
		{
			if (_mainVideo && _mainVideo["currentTime"] && !GlobalManager.isVideoPaused)
			{
				_curAccurateTime= _mainVideo["currentTime"];
				_curAccurateFrame = _mainVideo["currentTime"] * GlobalManager.curVideoFrameRate;
				//curFrame = Math.round(curAccurateFrame);
				_curFrame = int(_curAccurateFrame);
				
				onUpdateSnap();
			}
			
		}
		
		
	}
}