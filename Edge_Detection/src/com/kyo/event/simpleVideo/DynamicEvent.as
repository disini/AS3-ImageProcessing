package  com.kyo.event.simpleVideo
{
	import flash.events.Event;
	/**
	 * ...
	 * @author lilq
	 */
	public class DynamicEvent extends Event
	{
		public var data:*;
		public function DynamicEvent(type:String,dat:*=null,bubbles:Boolean=false,cancelable:Boolean=false):void{
			super(type,bubbles,cancelable);
			data = dat;
		}
		
	}

}