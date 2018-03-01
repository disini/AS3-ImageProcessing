package com.kyo.media.simpleVideo.utils
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class MissionTimer extends EventDispatcher
	{
		/**
		 * 函数延时调用
		 * @param whatFunctionToDelay 希望延时的函数
		 * @param delayInMilliseconds 延长时间，以微秒为单位
		 * @param params 函数被调用时要传入的参数
		 * 
		 */	
		public function MissionTimer(whatFunctionToDelay:Function, delayInMilliseconds:Number, params:Array=null)
		{
			super();
			
			delayedFunction = whatFunctionToDelay;
			funcParams = params;
			
			if(delayInMilliseconds == 0){
				doMission();
				return;
			}
			
			myTimer = new Timer(delayInMilliseconds, 1);
			myTimer.addEventListener(TimerEvent.TIMER, doMission);
			myTimer.start();
		}
		
		
		private var myTimer:Timer;
		private var delayedFunction:Function;
		public var funcParams:Array;
		
		public function pause():void{
			
		}
		
		public function resume():void{
			
		}
		
		private function doMission(...args):void {
			if(myTimer){
				myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, doMission);
				myTimer.stop();
			}
			//trace("delayyedFunction: " + this.delayedFunction);
			delayedFunction.apply(null, funcParams);
		}
		
		/**
		 * 取消延时调用
		 * 
		 */		
		public function stop():void {
			if(myTimer){
				myTimer.stop();
				myTimer.reset();
				myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, doMission);
				myTimer = null;
			}
			delayedFunction = null;
			funcParams = null;
		}
		
	}
}