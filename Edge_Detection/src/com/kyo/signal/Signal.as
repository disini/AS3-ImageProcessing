package com.kyo.signal
{
	public class Signal
	{
		/** 优先级  **/
		public var priority:uint;
		
		/** 信号类型 **/
		public var type:String;
		
		/** 处理函数 **/
		public var func:Function;
		
		/** 发出信号的对象 **/
		public var target:Object;
		
		public function Signal(type:String,func:Function,target:Object,priority:int = 0)
		{
			this.type = type;
			this.func = func;
			this.target = target;		
			this.priority = priority;
		}
	}
}