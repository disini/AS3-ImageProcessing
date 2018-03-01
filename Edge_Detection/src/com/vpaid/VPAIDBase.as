package  com.vpaid
{
	
	import flash.display.MovieClip;
	import flash.system.Security;
	
	/**
	 * 实现VPAID功能的基础类，广告创意可以继承此类
	 * @author Lukia Lee
	 */
	public class VPAIDBase extends MovieClip implements IVPAID 
	{
		
		public function VPAIDBase() {
			super();
			Security.allowDomain("*");
		}
		
		protected var _adRemainingTime:Number = 0;
		protected var _adDuration:Number = 0;
		protected var _adLinear:Boolean = false;
		protected var _adWidth:Number = 0;
		protected var _adHeight:Number = 0;
		protected var _adVolume:Number = 0;
		protected var _adExpanded:Boolean = false;
		protected var _adSkippableState:Boolean = false;
		protected var _adCompanions:String;
		protected var _adIcons:Boolean;
		
		protected static var SUPPORTED_VPAID_VERSION:String = "2.0";
		
		/* INTERFACE com.letv.as3lib.ad.IVPAID */
		public function set adVolume(value:Number):void {
			_adVolume = value;
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVolumeChange, value));
		}
		
		public function get adLinear():Boolean {
			return _adLinear;
		}
		
		public function get adWidth():Number {
			return _adWidth;
		}
		
		public function get adHeight():Number{
			return _adHeight;
		}
		
		public function get adExpanded():Boolean {
			return _adExpanded;
		}
		
		public function get adSkippableState():Boolean {
			return _adSkippableState;
		}
		
		public function get adRemainingTime():Number 
		{
			return _adRemainingTime;
		}
		
		public function get adDuration():Number 
		{
			return _adDuration;
		}
		
		public function get adVolume():Number 
		{
			return _adVolume;
		}
		
		public function get adCompanions():String 
		{
			return _adCompanions;
		}
		
		public function get adIcons():Boolean {
			return _adIcons;
		}
		
		public function handshakeVersion(playerVPAIDVersion:String):String {
			return SUPPORTED_VPAID_VERSION;
		}
		
		public function initAd(width:Number, height:Number, viewMode:String, desiredBitrate:Number, creativeData:String = "", environmentVars:String = ""):void {
			logAd("VPAID.initAd(" + width + "," + height + ",'" + viewMode + "'," + desiredBitrate + ",'" + creativeData + "','" + environmentVars + "') triggered");
			_adWidth = width;
        	_adHeight = height;
			//onAdLoaded();
		}
		
		protected function onAdLoaded():void{
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLoaded));
		}
		
		public function resizeAd(width:Number, height:Number, viewMode:String):void {
			_adWidth = width;
			_adHeight = height;
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdSizeChange));
		}
		
		public function startAd():void {
			renderAd();
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdImpression));
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdStarted));
		}
		
		public function stopAd():void {
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdStopped));
		}
		
		public function pauseAd():void {
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdPaused));
		}
		
		public function resumeAd():void {
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdPlaying));
		}
		
		public function expandAd():void {
			_adExpanded = true;
            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdExpandedChange));
		}
		
		public function collapseAd():void {
			_adExpanded = false;    	
            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdExpandedChange));
		}
		
		public function skipAd():void {
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdSkipped));
		}
		
		public function logAd(data:String):void {
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLog, data));
		}
		
		protected function renderAd():void {
			
        }
		
	}

}