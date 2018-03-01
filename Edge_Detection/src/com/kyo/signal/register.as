package  com.kyo.signal
{
	/**
	 * 注册信号处理函数
	 * 
	 * @param type 信号类型
	 * @param func 处理函数
	 * @param target 注册该信号的对象
	 * @param priortity 信号优先级（数字越大优先级越高） 
	 */
	public function register(type:String,func:Function,target:Object = null,priority:uint = 0):void
	{
		SignalManager.getInstance().registerSignal(type,func,target,priority);
	}	
}