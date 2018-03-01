package  com.media.simpleVideo.managers.retry.vo
{
	public class ResultInfoVO
	{
		public function ResultInfoVO()
		{
		}
		/**
		 * 请求结果得到的数据，有可能是文本信息，也可能是视频、图片等
		 */		
		public var resultObj:Object;
		/**
		 * 以毫秒为单位的持续时间
		 */		
		public var loadDuration:uint;
		/**
		 * 重试次数
		 */		
		public var retryCount:int;
		
		/**
		 * 文件尺寸
		 */		
		public var fileSize:uint;
		
		public var errorCode:String="";
		
		public var requestURL:String;
		
//		public var gslbInfo:GSLBNodeVO;
		
		public var serverStatus:int;
		
		
	}
}