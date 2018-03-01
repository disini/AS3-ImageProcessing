package com.view.bar
{
	import com.greensock.TweenLite;
	import com.kyo.event.ControlBarEvent;
	import com.kyo.media.simpleVideo.SimpleRetryVideo;
	import com.utils.Log;
	import com.view.tip.MouseTip1;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	import ui.volume.VolumeUI;
	
	import utils.Utils;

/**
 * 主视频的播放控件 
	 * @author LiuSheng  QQ:532230294
	 * 创建时间 : 2016-12-22 上午11:03:31
 * 
 */
	public class PlayControlBar extends PlayControlBar_Clip2
	{
		private var _video:SimpleRetryVideo;
		private var _container:Sprite;
		private var _barWidth:Number;
		private  var _isDragging:Boolean = false;
		private  var _onVideoEnd:Boolean = false;
		/** 当前拖动滚动条的位置占整个视频长度的百分比 */
		private var curMousePercent:Number = 0;
		/** 当前拖动滚动条的位置所在的视频的时刻 */
		private var curMouseTime:Number = 0;
		/** 当前已经加载的视频的长度 */
//		public var curLoadedVideoTime:Number = 0;
		
		private var _bgLayer:Sprite;
		
		public static const CONTROLBAR_HEIGHT:Number = 52;
		
		private static const HORIZON_MARGIN:Number = 60;
//		private static const HORIZON_MARGIN:Number = 0;
		
//		private var _totalVideoTime:Number;
		
		private var originalBarMcWidth : Number;
		private var originalBarMcHeight : Number;
		private var originalSeekHotAreaWidth : Number;
		private var widthScale:Number;
		
		private var volumeMC:VolumeUI;
		
		private var _isFullScreen:Boolean;
		
		private var updateUITimer:Timer;
		/** 上一次移动鼠标的时刻（单位毫秒） */
		private var _lastMouseMoveTimePoint:Number;
		private var _isControlBarDropped:Boolean = false;
		
		private var _needAutoPlay:Boolean;
		private var _showLogo:Boolean;
		private var _mouseTip:MouseTip1 = MouseTip1.instance;
		private static var TIP_LOCY_1:Number = -20;
		private static var TIP_LOCY_2:Number = 0;
		private static var _isClickBtnToSwitchFullScreen:Boolean = false;
		
		
		public function PlayControlBar(video:SimpleRetryVideo, container:Sprite, autoPlay:Boolean = true, showLogo:Boolean = true, barWidth:Number = 0)
		{
			_video = video;
			_needAutoPlay = autoPlay;
			_showLogo = showLogo;
//			_totalVideoTime = video.duration;
			_container = container;
//			_barWidth = barWidth ? barWidth : video.width;
			_barWidth = barWidth ? barWidth : stage.stageWidth;
			initPlayControlBar();
			setupSize();
			initTimer();
		}
		
		private function initTimer():void
		{
			updateUITimer = new Timer(500);
			updateUITimer.addEventListener(TimerEvent.TIMER, onTimerHandler);
			updateUITimer.start();
		}
		
		protected function onTimerHandler(evt:TimerEvent):void
		{
//			updateBar();
			checkIsMouseMoving();
		}
		
		private function checkIsMouseMoving():void
		{
			var _timeNow:Number = new Date().time;
			
				if(_timeNow - _lastMouseMoveTimePoint > 2000)
				{
					if(!_isControlBarDropped)
					{
						dropDownControlBar();
					}
				}
		}
		
		/**
		 * 将播放控制条向下隐藏 
		 * 
		 */		
		private function dropDownControlBar():void
		{
//			this.y = stage.stageHeight;
			TweenLite.to(this, 0.5, {y:stage.stageHeight});
			_isControlBarDropped = true;
			dispatchEvent(new Event("DropDownControlBar"));
		}
		
		/**
		 * 将播放控制条向上升起 
		 * 
		 */		
		private function raiseUpControlBar():void
		{
//			this.y = stage.stageHeight - CONTROLBAR_HEIGHT;
			if(stage && _isControlBarDropped)
			{
				TweenLite.to(this, 0.5 ,{y:stage.stageHeight - CONTROLBAR_HEIGHT});
				_isControlBarDropped = false;
				dispatchEvent(new Event("RaiseUpControlBar"));
			}
		}
		
		public function get isDragging():Boolean
		{
			return _isDragging;
		}
	
		private function initPlayControlBar():void
		{
//			bg.mouseEnabled = _curTimeTxt.mouseEnabled = videoELogoMC.mouseEnabled = false;
			_curTimeTxt.mouseEnabled = videoELogoMC.mouseEnabled = false;
			originalSeekHotAreaWidth = barMc.seekHotArea.width;
			originalBarMcWidth = barMc.width;
			originalBarMcHeight = barMc.height;
			barMc.barBG_PlayedYet.width = barMc.barBG_White.width = 0;
			_bgLayer = new Sprite();
			_bgLayer.graphics.beginFill(0, 0.5);
			_bgLayer.graphics.drawRect(0, 0, originalBarMcWidth, CONTROLBAR_HEIGHT);
			_bgLayer.graphics.endFill();
//			_bgLayer.x = - HORIZON_MARGIN / 2;
			addChildAt(_bgLayer, 0);
			barMc.btnClickAndDrag.buttonMode = true;
			barMc.btnClickAndDrag.mouseChildren = false;
//			barMc.timeTxt.visible = false;
//			barMc.timeTxt.mouseEnabled = false;
//			(barMc.timeTxt as TextField).selectable = true;
			barMc.seekHotArea.buttonMode = true;
			barMc.btnClickAndDrag.addEventListener(MouseEvent.MOUSE_DOWN, onDragMouseDown);
//			barMc.seekHotArea.addEventListener(MouseEvent.MOUSE_MOVE, onSeekMouseMove);
//			barMc.seekHotArea.addEventListener(MouseEvent.MOUSE_OVER, onSeekMouseOver);
//			barMc.seekHotArea.addEventListener(MouseEvent.MOUSE_OUT, onSeekMouseOut);
//			barMc.seekHotArea.addEventListener(MouseEvent.CLICK, onSeekMouseClick);
//			barMc.btnClickAndDrag.addEventListener(MouseEvent.MOUSE_MOVE, onDragMouseMove);
//			barMc.barBG_ClickArea.addEventListener(MouseEvent.CLICK, onClickToSeek);
			barMc.seekHotArea.addEventListener(MouseEvent.CLICK, onClickToSeek);
//			VolumeUI.initUI(volumeMC);
			volumeMC = new VolumeUI(_video.volume);
//			volumeMC.volumeValue = _video.volume;
			addChild(volumeMC);
			volumeMC.addEventListener(ControlBarEvent.SET_VOLUME, onSetVolume);
			volumeMC.y = 35;
//			volumeMC.panel.visible = false;
//			volumeMC.tip.visible = false;
			scaleMC.panel.visible = false;
//			scaleMC.visible = false;
//			scaleMC.fscreenIcon.mouseChildren = false;
			scaleMC.fscreenIcon.addEventListener(MouseEvent.CLICK, SwitchFullScreen);
			videoELogoMC.visible = _showLogo;
			// 播放按钮
			playButton.buttonMode = true;
			playButton.x = HORIZON_MARGIN / 2;
//			playButton.x = (HORIZON_MARGIN + playButton.width)/ 2;
			var targetFrame:int = _needAutoPlay?1:2;
			playButton.gotoAndStop(targetFrame);
//			playButton.mouseChildren = false;
			playButton.addEventListener(MouseEvent.CLICK, onClickBtn);
			
			videoELogoMC.addEventListener(MouseEvent.CLICK, onClickVideoyiLogo);
			videoELogoMC.buttonMode = true;
//			playButton.addEventListener(MouseEvent.CLICK, onClickBtn);
//			btnReplay.visible = false;
			btnReplay.addEventListener(MouseEvent.CLICK, onClickBtn);
//			addEventListener(Event.ENTER_FRAME, onEnterFrm);
			_container.addChild(this);
//			this.x = HORIZON_MARGIN / 2;
			barMc.x = HORIZON_MARGIN / 2;
			_mouseTip.visible = false;
			_mouseTip.y = TIP_LOCY_1;
			addChild(_mouseTip);
			
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			//			this.x = stage.stageWidth;
			//			this.y = video.height - 60;
			this.y = stage.stageHeight - CONTROLBAR_HEIGHT;
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onSwitchFullScreenHandler);
		}
		
		
		
		protected function onMouseMove(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			switch(evt.target.name)
			{
//				case "btnClickAndDrag":// 拖拽按钮
//				{
//					_mouseTip.visible = true;
//					_mouseTip.x = this.mouseX;
//					break;
//				}
				case "seekHotArea":
				{
					_mouseTip.visible = true;
					_mouseTip.x = this.mouseX;
					_mouseTip.y = TIP_LOCY_1;
					var mousePct:Number = evt.localX / originalSeekHotAreaWidth;
					var curMouseTime:Number = _video.duration * mousePct;
					_mouseTip.content = Utils.getTimeStr1(Number(curMouseTime.toFixed(3)) * 1000, false);
					break;
				}
				
				default:
				{
//					_mouseTip.visible = false;
					onDragMouseMove();
					break;
				}
			}
		}
		
		protected function onMouseOver(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			var mousePct:Number;
			var curMouseTime:Number;
//			_mouseTip.x = evt.target.x;
			_mouseTip.y = TIP_LOCY_2;
			switch(evt.target.name)
			{
				case "playButton_frame1"://控制条上暂停按钮
				{
					_mouseTip.visible = true;
					_mouseTip.content = "点击暂停";
					_mouseTip.x = playButton.x;
//					_mouseTip.y = TIP_LOCY_2;
					break;
				}
				case "playButton_frame2":// 控制条上播放按钮
				{
					_mouseTip.visible = true;
					_mouseTip.content = "点击播放";
					_mouseTip.x = playButton.x;
//					_mouseTip.y = TIP_LOCY_2;
					break;
				}
				case "btnReplay":// 重放
				{
					_mouseTip.visible = true;
					_mouseTip.content = "点击重头播放";
					_mouseTip.x = btnReplay.x;
//					_mouseTip.y = TIP_LOCY_2;
					break;
				}
//				case "fscreenIcon":// 全屏
				case "enterFullScreen":// 进入全屏
				case "exitFullScreen":// 退出全屏
				{
					_mouseTip.visible = true;
					_mouseTip.content = isFullScreen ? "退出全屏":"点击全屏";
					_mouseTip.x = scaleMC.x;
//					_mouseTip.y = TIP_LOCY_2;
					break;
				}
//				case "speakerIcon":// 静音
				case "muteIconFrame1":// 静音
				case "muteIconFrame2":// 静音
				case "muteIconFrame3":// 静音
				case "muteIconFrame4":// 静音
				{
					_mouseTip.visible = true;
					_mouseTip.content = (evt.target.parent as MovieClip).currentFrame == 1 ? "取消静音":"点击静音";
					_mouseTip.x = volumeMC.x;
//					_mouseTip.y = TIP_LOCY_2;
					break;
				}
				case "btnClickAndDrag":// 拖拽按钮
				{
					_mouseTip.visible = true;
					//					_mouseTip.x = this.mouseX;
//					_mouseTip.x = evt.target.x;
					_mouseTip.x = barMc.btnClickAndDrag.x + barMc.x;
					_mouseTip.y = TIP_LOCY_1;
					mousePct = evt.target.x / originalSeekHotAreaWidth;
					curMouseTime = _video.duration * mousePct;
					_mouseTip.content = Utils.getTimeStr1(Number(curMouseTime.toFixed(3)) * 1000, false);
					break;
				}
				case "seekHotArea":// 播放时间轴
				{
					_mouseTip.visible = true;
//					_mouseTip.x = this.mouseX;
					_mouseTip.x = evt.target.mouseX + barMc.x;
					_mouseTip.y = TIP_LOCY_1;
					mousePct = evt.localX / originalSeekHotAreaWidth;
					curMouseTime= _video.duration * mousePct;
					_mouseTip.content = Utils.getTimeStr1(Number(curMouseTime.toFixed(3)) * 1000, false);
					break;
				}
				default:
				{
					_mouseTip.visible = false;
					break;
				}
			}
			
		}
		
		protected function onMouseOut(evt:MouseEvent):void
		{
//			evt.stopImmediatePropagation();
//			if(evt.target is MovieClip)
//			{
//				evt.target.gotoAndStop(1);
//			}
			
		}
		
		protected function onClickVideoyiLogo(event:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://www.moviebook.tv/"));
		}
		
		private function onSetVolume(e:ControlBarEvent):void
		{
			_video.volume = e.dataProvider.value;
		}
		
		private function setupSize():void
		{
//			barMc.seekHotArea.width = barMc.barBG_ClickArea.width = barMc.barBG_Black.width = _barWidth - HORIZON_MARGIN;
			barMc.seekHotArea.width = barMc.barBG_Black.width = _barWidth - HORIZON_MARGIN;
			widthScale = barMc.seekHotArea.width / originalSeekHotAreaWidth;
			_bgLayer.width = _barWidth;
//			bg.width = _barWidth;
//			_bgLayer.x = 0;
			/*if(_video)
			{
				barMc.barBG_PlayedYet.width = 0;
			}
			else
			{
				barMc.barBG_PlayedYet.width = barMc.btnClickAndDrag.x = barMc.barBG_Black.width * (_video.currentTime / _video.duration);
			}*/
			barMc.barBG_PlayedYet.x = 0;
			scaleMC.x = barMc.barBG_Black.width + 30;
			btnReplay.x = barMc.barBG_Black.width - 10;
			volumeMC.x = barMc.barBG_Black.width - 250;
			videoELogoMC.x = barMc.barBG_Black.width - 380;
			Log.info("setupSize() : videoELogoMC.x = " + videoELogoMC.x + ", videoELogoMC.y = " + videoELogoMC.y);
		}
		
		override public function set width(value:Number):void
		{
			_barWidth = value;
			setupSize();
		}
		
		private function onClickToSeek(evt:MouseEvent):void
		{
			curMousePercent = evt.target.mouseX / 600;
//			trace("onClickToSeek : curMousePercent = " + curMousePercent);
//			barMc.timeTxt.visible = true;
			curMouseTime = _video.duration * curMousePercent;
//			curLoadedVideoTime = this.root["curLoadingProgress"] * _video.duration;
//			_video.seek(Math.min(curMouseTime, curLoadedVideoTime));
			_video.seek(curMouseTime);
			this.root["onSeekTo"]();
//			_video.resumeVideo();
			if(curMousePercent < 1)
			{
				//				playButton.mouseEnabled = true;
				_video.isPlaying = true;
				_onVideoEnd = false;
				playButton.gotoAndStop(1);
			}
		}
		
		public function onEnterFrm(evt:Event):void
		{
//			SystemMessage.update();
//			Tween.update();
//			if((!_video) || (!_video.isPlaying) || _isDragging)
			if((!_video) || _isDragging)
				return;
//			curLoadedVideoTime = this.root["curLoadingProgress"] * _video.duration;
//			trace("_video.currentTime = " + _video.currentTime + " , stage.frameRate = " +  stage.frameRate);
			barMc.barBG_PlayedYet.width = barMc.btnClickAndDrag.x = barMc.barBG_Black.width * (_video.currentTime / _video.duration);
			barMc.barBG_White.width = barMc.barBG_Black.width * (_video.curLoadedPercent / 100);
//			barMc.btnClickAndDrag.timeTxt.text = _video.currentTime.toFixed(2);
//			barMc.timeTxt.text = _video.currentTime;
			
			var curTimeStr:String = Utils.getTimeStr1(_video.currentTime * 1000);
			var totalTimeStr:String = Utils.getTimeStr1(_video.duration * 1000);
			
			_curTimeTxt.text = curTimeStr + " / " + totalTimeStr;
			if(this.parent)
			{
//				this.parent["updateCurTime"](_video.currentTime.toFixed(2));
				this.parent["updateCurTime"](_video.currentTime);
			}
		}
		
		private function onClickBtn(evt:MouseEvent = null):void
		{
//			evt.stopImmediatePropagation();
			switch(evt.target.name)
			{
				case "playButton":
				case "playButton_frame1":
				case "playButton_frame2":
				{
					if(_onVideoEnd)
					{
						onReplayVideo();
					}
					else
					{
						if(_video.isPlaying)
						{
							_video.pauseVideo();
						}
						else
						{
							_video.resumeVideo();
						}
						var targetFrame:int = playButton.currentFrame == 1 ? 2 : 1;
						playButton.gotoAndStop(targetFrame);
					}
					break;
				}
					
				case "btnReplay":
				{
					onReplayVideo();
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
	
		public function onReplayVideo():void
		{
			_video.seek(0);
			_video.replay();
			_onVideoEnd = false;
			playButton.gotoAndStop(1);
//			_container.hidePlayButton();
			dispatchEvent(new Event("NeedToHidePlayButton"));
		}
	
		public function onPlayComplete():void
		{
			_onVideoEnd = true;
			playButton.gotoAndStop(2);
			dispatchEvent(new Event("NeedToShowPlayButton"));
		}
	
		private function onSeekMouseOver(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			_mouseTip.visible = true;
			_mouseTip.x = this.mouseX;
//			barMc.timeTxt.visible = true;
//			barMc.timeTxt.x = evt.localX;
		}
		
		private function onSeekMouseOut(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			_mouseTip.visible = false;
//			barMc.timeTxt.visible = false;
//			barMc.timeTxt.x = evt.localX;
		}
		
		private function onSeekMouseMove(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
//			barMc.timeTxt.visible
//			barMc.timeTxt.x = evt.localX * widthScale - barMc.timeTxt.width/2;
			var mousePct:Number = evt.localX / originalSeekHotAreaWidth;
			var curMouseTime:Number = _video.duration * mousePct;
//			barMc.timeTxt.text = Utils.getTimeStr1(Number(curMouseTime.toFixed(3)) * 1000, false);
			_mouseTip.x = this.mouseX;
			_mouseTip.content = Utils.getTimeStr1(Number(curMouseTime.toFixed(3)) * 1000, false);
		}
		
		private function onDragMouseDown(evt:MouseEvent):void {
			evt.stopImmediatePropagation();
//			barMc.timeTxt.visible = true;
			var rect:Rectangle = new Rectangle(0, 0, barMc.barBG_Black.width, 0);
			barMc.btnClickAndDrag.startDrag(false, rect);
			barMc.btnClickAndDrag.addEventListener(MouseEvent.MOUSE_UP, onDragMouseUp);
			_isDragging = true;
			Log.info("_isDragging = true;");
		}
		
		private function onDragMouseUp(evt:MouseEvent = null):void {
			evt && evt.stopImmediatePropagation();
			_mouseTip.visible = false;
//			barMc.timeTxt.visible = false;
			barMc.btnClickAndDrag.removeEventListener(MouseEvent.MOUSE_UP, onDragMouseUp);
			barMc.btnClickAndDrag.stopDrag();
			_isDragging = false;
			Log.info("_isDragging = false;");
//			curLoadedVideoTime = this.root["curLoadingProgress"] * _video.duration;
//			_video.seek(Math.min(curMouseTime, curLoadedVideoTime));
			_video.seek(curMouseTime);
			this.root["onSeekTo"]();
			_video.resumeVideo();
		}
		
		public function onDragMouseMove(evt:MouseEvent = null):void
		{
			if(!_isDragging)
			{
				raiseUpControlBar();
				if(_video)
				{
					_lastMouseMoveTimePoint = new Date().time;
				}
				return;
			}
//			trace("onDragMouseMove");
			if(_video.isPlaying)
			{
				_video.pauseVideo();
			}
			curMousePercent = barMc.btnClickAndDrag.x / barMc.barBG_Black.width;
			curMouseTime = _video.duration * curMousePercent;
			_mouseTip.x = barMc.btnClickAndDrag.x + barMc.x;
			_mouseTip.y = TIP_LOCY_1;
//			barMc.timeTxt.text = Utils.getTimeStr1(Number(curMouseTime.toFixed(3)) * 1000, false);
			_mouseTip.content = Utils.getTimeStr1(Number(curMouseTime.toFixed(3)) * 1000, false);
			if(this.parent)
			{
				this.parent["updateCurTime"](curMouseTime.toFixed(3));
			}
			barMc.barBG_PlayedYet.width = barMc.btnClickAndDrag.x;
//			barMc.timeTxt.x = barMc.btnClickAndDrag.x - barMc.timeTxt.width/2;
//			_mouseTip.x = barMc.btnClickAndDrag.x - barMc.timeTxt.width/2;
			if(curMousePercent < 1)
			{
//				playButton.mouseEnabled = true;
				_video.isPlaying = true;
				_onVideoEnd = false;
				playButton.gotoAndStop(1);
			}
		}
		
		public function onPauseVideo():void{
			playButton.gotoAndStop(2);
		}
		
		public function onResumeVideo():void{
			playButton.gotoAndStop(1);
		}
		
		private function SwitchFullScreen(evt:MouseEvent):void
		{
			_isClickBtnToSwitchFullScreen = true;
			if(!stage)
				return;
			_mouseTip.visible = false;
			if(!_isFullScreen)
			{
				stage.displayState = StageDisplayState.FULL_SCREEN;
				_isFullScreen = true;
				scaleMC.fscreenIcon.gotoAndStop(2);
			}
			else
			{
				stage.displayState = StageDisplayState.NORMAL;
				_isFullScreen = false;
				scaleMC.fscreenIcon.gotoAndStop(1);
			}
			Log.info("PlayControlBar.SwitchFullScreen() : _isFullScreen == " + _isFullScreen);
				
		}
		
		protected function onSwitchFullScreenHandler(event:FullScreenEvent):void
		{
			// TODO Auto-generated method stub
			if(!_isClickBtnToSwitchFullScreen)
			{
				Log.info("PlayControlBar.onSwitchFullScreenHandler() : Exit FullScreen by press keyboard！"); 
				var jumpToFrame:int = (scaleMC.fscreenIcon as MovieClip).currentFrame == 1 ? 2 : 1;
				scaleMC.fscreenIcon.gotoAndStop(jumpToFrame);
				_isFullScreen = !_isFullScreen;
			}
			_isClickBtnToSwitchFullScreen = false;
		}
		
		public function forceStopDrag():void
		{
			if(_isDragging)
			{
				onDragMouseUp();
			}
		}

		/** 当前是否处于全屏状态 */
		public function get isFullScreen():Boolean
		{
			return _isFullScreen;
		}
		
		/**
		 * 更新各个显示条 
		 * @param data
		 * 
		 */		
		public function updateBar(curTime:Number = -1):void
		{
			barMc.barBG_PlayedYet.width = barMc.btnClickAndDrag.x = barMc.barBG_Black.width * (_video.currentTime / _video.duration);
			barMc.barBG_White.width = barMc.barBG_Black.width * (_video.curLoadedPercent / 100);
		}

		/** 当前控制条是否沉下去了 */
		public function get isControlBarDropped():Boolean
		{
			return _isControlBarDropped;
		}

	}
}