package  com.media.simpleVideo.managers.retry
{
	import com.kyo.media.simpleVideo.loaders.ICommonLoader;
	
	
	public interface IRetryLoader extends ICommonLoader
	{
		function get loadDuration():uint;
		function set loadDuration(value:uint):void;
		function startLoad():void;
		function get fileSize():uint;
	}
}