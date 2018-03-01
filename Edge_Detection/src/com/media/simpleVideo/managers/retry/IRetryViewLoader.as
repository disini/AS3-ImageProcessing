package  com.media.simpleVideo.managers.retry
{	
	import flash.display.DisplayObject;

	public interface IRetryViewLoader extends IRetryLoader
	{
		
		function get displayView():DisplayObject;
	}
}