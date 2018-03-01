package com.kyo.signal
{
	public class SignalManager
	{
		private static var _instance:SignalManager;
		
		private var _signals:Object = {};
		
		public function SignalManager()
		{
			if (_instance != null)
				throw new Error("请使用getInstance()方法获取实例");
		}
		
		public static function getInstance():SignalManager
		{
			if (_instance == null)
				_instance = new SignalManager();
			return _instance;
		}
		
		public function sendSignal(type:String,data:Array):void
		{
			var datas:Vector.<Signal> = getSignalData(type);
			for each (var s:Signal in datas)
			{
				//返回false 强制停止后续监听 
				if (s.func.apply(s.target,data) == false)
					break;
			}
		}
		
		public function registerSignal(type:String,func:Function,target:Object,priority:uint = 0):void
		{
			var data:Vector.<Signal> = getSignalData(type);
			var s:Signal;
			var index:int = search(type,func);
			if (index == -1)
			{
				s = new Signal(type,func,target,priority);				
				data.push(s);
				data.sort(function(a:Signal,b:Signal):int{
					return b.priority - a.priority;
				});
			}
			else
			{
				s = data[index];
				s.target = target;
				s.priority = priority;
			}
			saveSignalData(type,data);
		}
		
		public function unregisterSignal(type:String,func:Function):void
		{
			var data:Vector.<Signal> = getSignalData(type);
			var index:int = search(type,func);
			if (index != -1)
				data.splice(index,1);
			saveSignalData(type,data);
		}
		
		public function isSignalRegister(type:String,func:Function):Boolean
		{
			return search(type,func) == -1? false:true;
		}
		
		private function getSignalData(type:String):Vector.<Signal>
		{
			var data:Vector.<Signal> = _signals[type] as Vector.<Signal>;
			if (data == null)
				data = new Vector.<Signal>();
			return data;
		}
		
		private function saveSignalData(type:String,data:Vector.<Signal>):void
		{
			_signals[type] = data;
		}
		
		private function search(type:String,func:Function):int
		{
			var index:int = -1;
			var data:Vector.<Signal> = getSignalData(type);
			for (var i:int = 0;i<data.length ;i++)
			{
				if (data[i].func == func)
					index = i;
			}
			return index;
		}
	}
}