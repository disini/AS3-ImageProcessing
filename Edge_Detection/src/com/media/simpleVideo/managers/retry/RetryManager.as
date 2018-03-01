package com.media.simpleVideo.managers.retry
{
	import com.kyo.event.RetryEvent;
	import com.kyo.media.simpleVideo.utils.MissionTimer;
	import com.media.simpleVideo.managers.retry.vo.ResultInfoVO;
	
	import flash.events.EventDispatcher;
	
	/**
	 * 获取任何远程文件的重试管理器
	 * @author Lukia Lee
	 * @version 1.0
	 * @created 2013-5-8 15:20:40
	 */
	public class RetryManager extends EventDispatcher{
		
		public function RetryManager(_loader:IRetryLoader){
			super();
			loader = _loader;
			addEventListener(RetryEvent.LOADER_LOADED, gotResult);
			addEventListener(RetryEvent.LOADER_IO_ERROR, onIOError);
			addEventListener(RetryEvent.LOADER_SECURITY_ERROR, onSecurityError);
			addEventListener(RetryEvent.READY_TO_PLAY, onReadyToPlay);
			addEventListener(RetryEvent.LOAD_STARTED, initLoadWaitingCall);
		}
		protected var loader:IRetryLoader;
		
		private var _retryGapTime:uint = 1;
		private var _retryGapOffset:uint = 1;
		private var _retryMaxCount:uint = 2;
		protected var _retryIndex:uint = 0;
		
		private var retryDelayCall:MissionTimer;
		
		/**
		 * 加载超时时间值，以秒为单位
		 */		
		public var loadWaitingTime:Number = 0;
		private var loadWaitingCall:MissionTimer;
		
		public var duration:uint;
		
		/*private function onLoaded(e:TextDataLoaderEvent):void{
			recodeRetryDuration();
			var resultEvent:TextDataLoaderEvent = e.clone() as TextDataLoaderEvent;
			resultEvent.fetchDataDuration = duration;
			loader.dispatchEvent(resultEvent);
		}
		*/
		public function set retryIndex(value:uint):void{
			_retryIndex = value;
		}
		
		public function get retryIndex():uint{
			return _retryIndex;
		}
		
		private function onTimeoutError():void{
			//trace("加载超时" + loader.url);
			recodeRetryDuration();
			onFailed(CommonErrorCode.TIME_OUT_ERROR);
			cancelLoadWaiting();
			loader.closeLoader();//让连接断开
		}
		
		private function onIOError(e:RetryEvent):void{
			recodeRetryDuration();
			onFailed(CommonErrorCode.IO_ERROR);
		}
		
		private function onSecurityError(e:RetryEvent):void{
			recodeRetryDuration();
			onFailed(CommonErrorCode.SECURITY_ERROR);
		}
		
		private function recodeRetryDuration():void{
			var gapTime:uint;
			if(_retryIndex > 0){
				gapTime = retryGapTime + _retryGapOffset * (_retryIndex - 1);
			}else{
				gapTime = 0;
			}
			if(loader)
				duration = loader.loadDuration;//duration + loader.duration + gapTime*1000;
			//trace(this + "recodeRetryDuration::"+duration);
		}
		
		private function retry():void{
			//trace("开始重试" + loader.url);
			loaderReload();
			initLoadWaitingCall();
			cancelRetryDelay();
		}
		
		protected function loaderReload():void{
			loader.startLoad();
		}
		
		protected function gotResult(e:RetryEvent):void{
			if(_retryIndex>0){
				retrySuccess();
			}
			sendResultInfo(e.data);//事件中携带的数据，是加载器所加载的数据/图片本身
			//trace("得到了数据，取消加载等待，取消重试等待");
			cancelLoadWaiting();
			cancelRetryDelay();
		}
		
		public function set retryGapTime(value:uint):void{
			_retryGapTime = value;
		}
		
		public function get retryGapTime():uint{
			return _retryGapTime;
		}
		
		protected function updateRetryIndex():void{
			_retryIndex++;
		}
		
		//public var resultInfo:ResultInfoVO = new ResultInfoVO();
		
		public var currentResultInfo:ResultInfoVO;
		public var currentResultStatus:int;
		protected function onFailed(errCode:String):void{
			currentResultInfo = new ResultInfoVO();
			prepareResultInfo(currentResultInfo);
			currentResultInfo.errorCode = errCode;
			updateRetryIndex();
			if(_retryIndex <= retryMaxCount){
				var gapTime:uint = retryGapTime + _retryGapOffset * (_retryIndex - 1);
				//ArkDebugManager.showDebugInfo("等待 " + gapTime + " 秒后重试" + loader.url);
				
				trace(_retryIndex+" "+loader+loader.url+"加载失败 等待 " + gapTime + " 秒后重试" );
				//trace("等待 " + gapTime + " 秒后重试" + loader.url);	
				retryDelayCall = new MissionTimer(retry, gapTime*1000);
			}else{
				//ArkDebugManager.showDebugInfo("重试"+(_retryIndex-1)+"次后失败" + loader.url);
				trace("重试"+(_retryIndex-1)+"次后失败" + loader.url);
				//trace("重试"+(_retryIndex-1)+"次后失败" + loader.url);
				_retryIndex = retryMaxCount;
				//dispatchEvent(new TextDataLoaderEvent(TextDataLoaderEvent.TEXT_DATA_IO_ERROR));
				loader.dispatchEvent(new RetryEvent(RetryEvent.RETRY_FAILED, currentResultInfo));
				cancelLoadWaiting();
			}
			//trace("每一次失败都要派发失败事件");
			loader.dispatchEvent(new RetryEvent(RetryEvent.SINGLE_RETRY_FAILED, currentResultInfo));
		}
		
		protected function prepareResultInfo(resultInfo:ResultInfoVO):void{
			resultInfo.loadDuration = loader.loadDuration;
			resultInfo.retryCount = _retryIndex;
			resultInfo.fileSize = loader.fileSize;
			resultInfo.requestURL = loader.url;
			resultInfo.serverStatus = currentResultStatus;
		}
		
		public function set retryMaxCount(value:uint):void{
			_retryMaxCount = value;
		}
		
		public function get retryMaxCount():uint{
			return _retryMaxCount;
		}
		
		public function retrySuccess():void{
			//trace("重试加载成功 "+loader.url);
		}
		
		private function onReadyToPlay(e:RetryEvent):void{
			sendResultInfo();
		}
		
		private function sendResultInfo(resultData:Object = null):void{
			var resultInfo:ResultInfoVO = new ResultInfoVO();
			prepareResultInfo(resultInfo);
			resultInfo.resultObj = resultData;
			loader.dispatchEvent(new RetryEvent(RetryEvent.GOT_LOAD_RESULT_INFO, resultInfo));
		}
		
		/**
		 * 为了防止加载时间过长，制定了超时策略，一旦发现加载开始，则开始发挥作用
		 * @param e
		 * 
		 */		
		private function initLoadWaitingCall(e:RetryEvent=null):void{
			cancelLoadWaiting();
			if(loadWaitingTime!=0){
				//trace("启用数据加载超时控制"+loadWaitingTime+"秒" + loader.url);
				loadWaitingCall = new MissionTimer(onTimeoutError, loadWaitingTime*1000);
				loadWaitingTime += _retryGapOffset;//下次加载再多给一秒
			}
		}
		
		private function cancelLoadWaiting():void{
			if(loadWaitingCall){
				loadWaitingCall.stop();
				loadWaitingCall = null;
			}
		}
		
		private function cancelRetryDelay():void{
			if(retryDelayCall){
				retryDelayCall.stop();
				retryDelayCall = null;
			}
		}
		
		public function destroy():void{
			//loader = null;
			removeEventListener(RetryEvent.LOADER_LOADED, gotResult);
			removeEventListener(RetryEvent.LOADER_IO_ERROR, onIOError);
			removeEventListener(RetryEvent.LOADER_SECURITY_ERROR, onSecurityError);
			removeEventListener(RetryEvent.READY_TO_PLAY, onReadyToPlay);
			removeEventListener(RetryEvent.LOAD_STARTED, initLoadWaitingCall);
			cancelLoadWaiting();
			cancelRetryDelay();
		}
		
	}
}