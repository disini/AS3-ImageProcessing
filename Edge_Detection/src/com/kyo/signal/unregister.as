package com.kyo.signal
{
	/**
	 * 取消信号注册
	 * 
	 * @param type 信号类型
	 * @param func 处理函数
	 */
	public function unregister(type:String,func:Function):void
	{
		SignalManager.getInstance().unregisterSignal(type,func);
	}
}