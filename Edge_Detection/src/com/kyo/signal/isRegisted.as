package com.kyo.signal
{
	/**
	 *  判断是否已经注册
	 * 
	 * @param type 信号类型
	 * @param func 注册函数
	 * 
	 * @return 已注册:true <br>未注册:false
	 */
	public function isRegisted(type:String,func:Function):Boolean
	{
		return SignalManager.getInstance().isSignalRegister(type,func);
	}
}
