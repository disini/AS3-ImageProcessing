package com.kyo.signal
{
	/**
	 *  发出信号通知
	 * 
	 * @param type 信号类型
	 * @param data 信号携带参数
	 */
	public function notify(type:String,...data):void
	{
		SignalManager.getInstance().sendSignal.apply(null,[type,data]);
	}
}
