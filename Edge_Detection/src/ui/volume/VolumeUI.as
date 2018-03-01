package ui.volume
{
	import com.greensock.TweenLite;
	import com.kyo.event.ControlBarEvent;
	import com.uiConfig.Config;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * 音控组件管理器.
	 * author linyang created on 2012-2013
	 */
	public class VolumeUI extends VolumeUI_Clip2
	{		
		
		private var _enabled:Boolean;
		
		//一次显示面板操作开始的时候的音量值
		private var _startVolume:Number;
		//一次显示面板操作过程中是否用过键盘操作
		private var _useKey:Boolean;
		//是否开启.
		private var _opening:Boolean;
		//拖动条控制器.
		//		private var drag:ConfigVDragbar;
		//当前音量(默认为配置的最大倍数).
		private var _volumeValue:Number = Config.VOLUME_MAX;
//		public var volumeValue:Number = 0.1;
		//上一次音量cookie值.
		private var upVolumeValue:Number = 0.5;
		private var _functionId:uint;
		//是否为刚初始化
		private var _isFirst:Boolean = true;
		
		private var timeout:int;
		
		private static var _instance:*;
		
		private var _skin:MovieClip;
		
		private  var _isDragging:Boolean = false;
		
		/**
		 * @param instance 音控实例.
		 */
//		public function VolumeUI(instance:Object)
		public function VolumeUI(volume:Number)
		{
//			super(instance);			
			if(_instance)
			{
				throw new Error("VolumeUI can't be initialized twice!");
			}
			_instance = this;
			_volumeValue = volume;
			this.scaleX = this.scaleY = 0.8;
			initialize();
		}
		
		
		/*public static function get instance():VolumeUI
		{
			return _instance ? _instance : new VolumeUI();
		}*/
		
		/*public static function initUI(mc:VolumeUI_Clip):void
		{
			_instance = (mc as VolumeUI);
			_instance.initialize();
		}*/
		/*override public function get width():Number
		{
			if(select != null){
				return select.width - 3;
			}
			return super.width;
		}*/
		
		public function get opening():Boolean
		{
			return _opening;
		}
		
		/*override public function set enabled(flag:Boolean):void
		{
			_enabled = flag;
			if(flag){
				addEventListener(MouseEvent.ROLL_OVER,onMouse);
			}else{
				if(panel != null)panel.visible = false;
				removeEventListener(MouseEvent.ROLL_OVER,onMouse);
			}
		}*/
		
		/**
		 * 设置cookie volume.
		 * @param info 鉴权成功的数据信息
		 */
		public function set initvolume(info:Object):void
		{
			try
			{
				var value:Number = info.volume; 
				if(info.hasOwnProperty("upVolume")){
					upVolumeValue = info.upVolume;
				}			
				if(upVolumeValue == 0){
					upVolumeValue = 0.5;
				}
				if(!isNaN(value) && value >= 0)
				{			
					_volumeValue = value;
					dragPercent = (1-_volumeValue)/Config.VOLUME_MAX;		
					rendererIcon(_volumeValue);
				}
			}catch(e:Error){}
		}
		
		/**
		 * 外部动态干预音量(如：键盘）.
		 * @param value 如果值大于0则增加音量，如果小于0则减少音量
		 */
		public function set toggleVolume(value:int):void
		{
			var lastValue:Number = _volumeValue;
			if(value > 0){
				_volumeValue += Config.VOLUME_MAX*0.1;			
			}else{
				_volumeValue -= Config.VOLUME_MAX*0.1;
			}	
			_volumeValue = Number(_volumeValue.toFixed(2));
			if((lastValue < 1 && _volumeValue > 1) || (lastValue > 1 && _volumeValue < 1))
			{
				_volumeValue = 1;
			}			
			if(_volumeValue > Config.VOLUME_TOTAL)
			{
				_volumeValue = Config.VOLUME_TOTAL;
			}				
			if(_volumeValue < 0)
			{
				_volumeValue = 0;
				dragPercent = 1;
			}			
			dragPercent = (Config.VOLUME_MAX - _volumeValue)/Config.VOLUME_MAX;			
			rendererIcon(_volumeValue);			
			sendVolume(_volumeValue);
			_useKey = true;
		}
		
		public function set scriptVolume(value:Object):void
		{
			_volumeValue = Number(value.toFixed(2));		
			if(_volumeValue > Config.VOLUME_TOTAL)
			{
				_volumeValue = Config.VOLUME_TOTAL;
			}				
			if(_volumeValue < 0)
			{
				_volumeValue = 0;
				dragPercent = 1;
			}			
			dragPercent = (1-_volumeValue)/Config.VOLUME_MAX;			
			rendererIcon(_volumeValue);		
		}
		
		public function initialize():void
		{
//			super.initialize();
//			panel.visible = false;
//			panel.drag.slider.buttonMode = true;
//			panel.drag.maskTrack.mouseEnabled = false;
//			tip.visible = false;
//			speakerIcon.mouseChildren = false;
			try{
//				drag = new ConfigVDragbar(panel.drag,true);				
				if(panel.txt != null){
					panel.txt.mouseEnabled = false;
					panel.txt.mouseWheelEnabled = false;
				}
				try{
//					dragPercent = (1 - volumeValue)/Config.VOLUME_MAX;		
					dragPercent = _volumeValue/Config.VOLUME_MAX;		
				}catch(e:Error)
				{
				
				};
				try{
					rendererIcon(_volumeValue);
				}catch(e:Error)
				{
				
				};
				try
				{
					sendVolume(_volumeValue);
				} 
				catch(e:Error) 
				{
					
				}
				try{
//					tip.visible = false;
//					tip.mouseEnabled = false;
//					tip.mouseChildren = false;
				}
				catch(e:Error)
				{
					
				}
				
//				onMouseRollOut();
				addListener();
			}catch(e:Error)
			{
			
			};
			
//			addAppResize(onStageResize);
		}	
		
		public function set dragPercent(value:Number):void
		{
//			panel.drag.slider.y = panel.drag.maskTrack.height * value;
			panel.drag.slider.x = panel.drag.maskTrack.width * value;
//			dispatchEvent(new Event("OnVolumeUI")
//			panel.drag.masker.scaleY = 1 - value;
			panel.drag.masker.scaleX = value;
		}
		
		public function get dragPercent():Number
		{
//			return panel.drag.slider.y / panel.drag.maskTrack.height;
			return panel.drag.slider.x / panel.drag.maskTrack.width;
		}
		
		protected function onStageResize(value:Object = null):void
		{
			if(_enabled)
			{
//				onMouseRollOut();
			}
		}
		
		private function addListener():void
		{
//			drag.addEventListener(Event.CHANGE,onDragBarChange);
			panel.drag.maskTrack.addEventListener(MouseEvent.CLICK, onClickVolumeBar);
			panel.drag.slider.addEventListener(MouseEvent.MOUSE_DOWN, onSliderMouseDown);
			if(speakerIcon != null)
				speakerIcon.addEventListener(MouseEvent.CLICK,onMute);
			addEventListener(MouseEvent.ROLL_OVER, onMouse);
			addEventListener(MouseEvent.MOUSE_MOVE, onDragMouseMove);
		}
		
		public function onDragMouseMove(evt:MouseEvent = null):void
		{
			if(!_isDragging)
				return;
			//			trace("onDragMouseMove");
//			dragPercent = panel.drag.slider.y / panel.drag.maskTrack.height;
			dragPercent = panel.drag.slider.x / panel.drag.maskTrack.width;
//			volumeValue = 1 - dragPercent;
			_volumeValue = dragPercent;
//			panel.drag.masker.scaleY = volumeValue;
			panel.drag.masker.scaleX = _volumeValue;
			rendererIcon(_volumeValue);
			sendVolume(_volumeValue);
		}
		
		private function onClickVolumeBar(e:MouseEvent):void
		{
//			dragPercent = e.target.mouseY / e.target.height;
			dragPercent = e.target.mouseX / e.target.width;
//			volumeValue = 1 - dragPercent;
			_volumeValue = dragPercent;
			rendererIcon(_volumeValue);
			sendVolume(_volumeValue);
		}
		
		private function onSliderMouseDown(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
//			var rect:Rectangle = new Rectangle(0, 0, 0, panel.drag.maskTrack.height);
			var rect:Rectangle = new Rectangle(0, 0, panel.drag.maskTrack.width, 0);
			panel.drag.slider.startDrag(false, rect);
			panel.drag.slider.addEventListener(MouseEvent.MOUSE_UP, onSliderDragFinished);
			panel.drag.slider.addEventListener(MouseEvent.ROLL_OUT, onSliderDragFinished);
			_isDragging = true;
		}
		
		private function onSliderDragFinished(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			panel.drag.slider.removeEventListener(MouseEvent.MOUSE_UP, onSliderDragFinished);
			panel.drag.slider.removeEventListener(MouseEvent.ROLL_OUT, onSliderDragFinished);
			panel.drag.slider.stopDrag();
			_isDragging = false;
//			dragPercent = panel.drag.slider.y / panel.drag.maskTrack.height;
			dragPercent = panel.drag.slider.x / panel.drag.maskTrack.width;
//			volumeValue = 1 - dragPercent;
			_volumeValue = dragPercent;
//			panel.drag.masker.scaleY = volumeValue;
			panel.drag.masker.scaleX = _volumeValue;
			rendererIcon(_volumeValue);
			sendVolume(_volumeValue);
		}
		
		public function get isDragging():Boolean
		{
			return _isDragging;
		}
		
		
		/**
		 * 音量条拖拽完毕
		 */
		/*private function onDragComplete(e:Event):void{
//			drag.removeEventListener(ConfigVDragbar.DragComplete , onDragComplete);
			var evt:MouseEvent = new MouseEvent(MouseEvent.ROLL_OUT);
			onMouse(evt);
		}*/
		
		protected function onMouse(e:MouseEvent):void{
			clearTimeout(_functionId);
			switch(e.type){
				case MouseEvent.ROLL_OVER:
					_functionId = setTimeout(onMouseRollOver , 100);
					removeEventListener(MouseEvent.ROLL_OVER,onMouse);
					addEventListener(MouseEvent.ROLL_OUT,onMouse);
					break
				case MouseEvent.ROLL_OUT:
//					if(drag.isMoveing){
//						drag.addEventListener(ConfigVDragbar.DragComplete , onDragComplete);
//						return
//					}
//					onMouseRollOut();
					addEventListener(MouseEvent.ROLL_OVER,onMouse);
					removeEventListener(MouseEvent.ROLL_OUT,onMouse);
					break;
			}
		}
		
		private function onMouseRollOver(event:MouseEvent = null):void
		{
			if(panel != null){
//				setOpen(true,event!=null);
			}
//			if(select != null){
//				select.visible = true;
//			}
//			if(visualBack != null){
//				visualBack.visible = true;
//			}
			if(_isFirst){
				_isFirst = false;
				if(_volumeValue==Config.VOLUME_MAX){
//					setDelay();
					return;
				}
			}
//			R.stat.sendDocDebug(LetvStatistics.DUBI_SHOW);
			_startVolume = _volumeValue;
			_useKey = false;
		}
		
		private function onMouseRollOut(event:MouseEvent = null):void
		{
			if(panel != null){
//				setOpen(false,event!=null);
			}
//			if(select != null){
//				select.visible = false;
//			}
//			if(visualBack != null){
//				visualBack.visible = false;
//			}
//			onDelay();
		}
		
		
		
		private function rendererIcon(value:Number):void
		{
			var frames:int;
			try{frames = speakerIcon.totalFrames;}catch(e:Error){}
			if(frames >= 1)
			{
				if(dragPercent <= 0){
//					speakerIcon.gotoAndStop(frames*1);
					speakerIcon.gotoAndStop(1);
				}else if(dragPercent > 0 && dragPercent <= 0.5){
//					speakerIcon.gotoAndStop(Math.ceil(frames*0.75));
					speakerIcon.gotoAndStop(Math.ceil(frames*0.5));
				}else if(dragPercent > 0.5 && dragPercent < 1){
//					speakerIcon.gotoAndStop(Math.ceil(frames*0.5));
					speakerIcon.gotoAndStop(Math.ceil(frames*0.75));
				}else{
//					speakerIcon.gotoAndStop(1);
					speakerIcon.gotoAndStop(frames*1);
				}		
			}
			if(panel.txt != null){
				panel.txt.text = int(value*100/Config.VOLUME_MAX)+"%";				
			}
		}
		
		private function onMute(event:MouseEvent):void
		{
			if(speakerIcon.currentFrame == 1)// Mute ing...
			{
				if(_volumeValue == 0) _volumeValue = upVolumeValue;
//				dragPercent = (1 - volumeValue)/Config.VOLUME_MAX;
				dragPercent = _volumeValue/Config.VOLUME_MAX;
				sendVolume(_volumeValue);
				rendererIcon(_volumeValue);
			}
			else
			{
//				dragPercent = 1;
				dragPercent = 0;
				sendVolume(0);
				rendererIcon(0);
			}
		}
		
		/*private function onDragBarChange(event:Event):void
		{
			var lastValue:Number = volumeValue;
			var value:Number = Config.VOLUME_MAX*(1 - dragPercent);
			volumeValue = Number(value.toFixed(2));
			
			rendererIcon(volumeValue);
			sendVolume(volumeValue);
			if(lastValue<Config.VOLUME_MAX && volumeValue==Config.VOLUME_MAX){
				setDelay();
			}
		}*/
		
		private function sendVolume(value:Number):void
		{
			var e:ControlBarEvent = new ControlBarEvent(ControlBarEvent.SET_VOLUME);
			e.dataProvider.value = value;
			dispatchEvent(e);
		}
		
		private function setOpen(value:Boolean,action:Boolean = true):void
		{
			_opening = value;
			if(value){
				panel.visible = true;
				if(action){
					panel.alpha = 0;
					TweenLite.to(panel,0.2,{alpha:1});
				}
				
			}else{
				if(action){
					TweenLite.to(panel,0.2,{alpha:0,onComplete:onHideComplete});
				}else{
					onHideComplete();
				}
			}
		}
		
		private function onHideComplete():void
		{
			if(panel != null)
				panel.visible = false;
		}

		public function get volumeValue():Number
		{
			return _volumeValue;
		}

		public function set volumeValue(value:Number):void
		{
			_volumeValue = value;
		}
		
		
		
		
		/*private function setDelay():void
		{
			if(tip != null)
			{
				if(dragPercent==0){
					tip.visible = true;
					clearTimeout(timeout);
					timeout = setTimeout(onDelay,1500);
				}
			}
		}
		
		private function onDelay():void
		{
			try{tip.visible = false;}catch(e:Error){}
		}*/
		
		
	}
}