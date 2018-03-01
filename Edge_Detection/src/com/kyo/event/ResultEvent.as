package com.kyo.event
{
	import flash.events.Event;
	
	public class ResultEvent extends Event
	{
		public static const resultStates:String = 'resultStates';
		public var _states:String;
		public var _data:Object;
		public function ResultEvent(type:String,states:String=null,data:Object=null)
		{
			super(type);
			_states=states;
			_data=data;
		}
	}
}