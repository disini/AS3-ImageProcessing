package com.kyo.event
{
	import flash.events.Event;
	
	public class DataEvent extends Event
	{
		public static const dataStates:String = 'dataStates';
		public var _states:String;
		public var _tip:String;
		public var _data:*;
		public function DataEvent(type:String,states:String=null,tip:String=null,data:*=null)
		{
			super(type);
			_states = states;
			_tip = tip;
			_data=data;
		}
	}
}