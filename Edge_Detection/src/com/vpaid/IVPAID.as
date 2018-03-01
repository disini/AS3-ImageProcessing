/**
 * @Video Player-Ad Interface Definition (VPAID) 2.0 
 * @URL:http://www.iab.net/vpaid
 * @Document:http://www.iab.net/media/file/VPAID_2.0_Final_04-10-2012.pdf
 */
package  com.vpaid
{
	public interface IVPAID
	{
		/**
		 * 设置广告声音 0-1 (0为静音)
		 * @param value
		 * 
		 */		
		function set adVolume(value:Number):void;
		
		/**
		 * 获取广告线性属性 
		 * @return 
		 * true:线性广告;false:非线性广告
		 */		
		function get adLinear():Boolean;
		
		/**
		 * 获取广告宽 
		 * @return 
		 * 
		 */		
		function get adWidth():Number;
			
		/**
		 * 获取广告高 
		 * @return 
		 * 
		 */		
		function get adHeight():Number;
		
		/**
		 * 获取广告是否可扩展 
		 * @return 
		 * 
		 */		
		function get adExpanded():Boolean;
		
		/**
		 * 获取广告是否可跳过 
		 * @return 
		 * 
		 */		
		function get adSkippableState():Boolean;
		
		/**
		 * 获取广告剩余时间 
		 * @return 
		 * 
		 */		
		function get adRemainingTime():Number;
		
		/**
		 * 获取广告总时长 
		 * @return 
		 * 
		 */		
		function get adDuration():Number;
		
		/**
		 * 获取当前广告声音 
		 * @return 
		 * 0-1
		 */		
		function get adVolume():Number;
		
		/**
		 * 获取伴随广告 
		 * @return 
		 * 
		 */		
		function get adCompanions():String;
		
		/**
		 *  广告Icons
		 * @return 
		 * 
		 */		
		function get adIcons():Boolean;

		/**
		 * 获取vpiad版本 
		 * @param playerVPAIDVersion
		 * @return 
		 * 
		 */		
		function handshakeVersion(playerVPAIDVersion:String):String;
		
		/**
		 * 初始化广告 
		 * @param width 广告宽
		 * @param height 广告高
		 * @param viewMode 广告显示模式，有normal, thumbnail 或 fullscreen的取值
		 * @param desiredBitrate 广告码率
		 * @param creativeData 创意数据
		 * @param environmentVars 
		 * 
		 */		
		function initAd(width:Number, height:Number, viewMode:String, desiredBitrate:Number, creativeData:String="", environmentVars:String=""):void;
		
		/**
		 * 改变广告尺寸 
		 * @param width 广告宽
		 * @param height 广告高
		 * @param viewMode 广告显示模式，有normal, thumbnail 或 fullscreen的取值
		 * 
		 */		
		function resizeAd(width:Number, height:Number, viewMode:String):void;
		
		/**
		 *开始广告播放 
		 * 
		 */		
		function startAd():void;
		
		/**
		 *终止广告播放 
		 * 
		 */		
		function stopAd():void;
		
		/**
		 *广告暂停 
		 * 
		 */		
		function pauseAd():void;
		
		/**
		 *广告从暂停状态恢复播放 
		 * 
		 */		
		function resumeAd():void;
		
		/**
		 *广告扩展 
		 * 
		 */		
		function expandAd():void;
		
		/**
		 *广告反扩展 
		 * 
		 */		
		function collapseAd():void;
		
		/**
		 *跳过广告 
		 * 
		 */		
		function skipAd():void;
	}
}