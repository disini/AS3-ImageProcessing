/** 
 * FileName.java(FileName.as) 
 * foolball game flash client
 * Copyright (c) 2012, 海盗. All rights reserved. 
 * pirates.hoolai.com 
 * 
 */
package ui.tip.message
{
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	import tween.Tween;
	
	/**系统提示
	 * @author 张磊<zhanglei1@hoolai.com>
	 * date Jun 14, 2012 12:01:11 PM
	 * @version 1.0
	 */
	public class SystemMessage extends Sprite
	{
		/**
		 *当前显示文本列表 - 默认
		 */		
		private static var systemTxt_list:Vector.<SystemMessageItem> = new Vector.<SystemMessageItem>();
		/**
		 *文本池
		 */		
		private static var contentTxt_pool:Vector.<SystemMessageItem> = new Vector.<SystemMessageItem>();
		/**
		 * 当前正在显示的条目
		 */		
		private static var curTxt_pool:Vector.<SystemMessageItem> = new Vector.<SystemMessageItem>();
		/**
		 *屏幕中最大显示数量 
		 */		
		private static const MAX_COUNT:int = 1;
		/**
		 *显示父容器 
		 */		
		private static var txt_container:Sprite;
		/**
		 *开始计时 
		 */		
		private static var start_time:int;
		/**
		 *消失间隔时间 - 默认
		 */		
		private static const DEFAULT_INTERVAL:int = 2000;
		
		private static var curGlobal_txt:SystemMessageItem;
		
		private static var _parentWidth:Number;
		private static var _parentHeight:Number;
		
		public function SystemMessage()
		{
			super();
		}
		
		public static function init(_parent:Sprite, _width:Number, _height:Number):void{
			txt_container = _parent;
			_parentWidth = _width;
			_parentHeight = _height;
			start_time = getTimer();
		}
		
		/**逐条显示队列中的message*/
		public static function showOneByOne(_content:String):void{
			if(txt_container == null)
				return;
			if(txt_container.numChildren >= 1)
			{
				var nextTxt:SystemMessageItem = new SystemMessageItem();
				nextTxt.content = _content;
				systemTxt_list.push(nextTxt);
				return;
			}
			
			var curtext:SystemMessageItem = new SystemMessageItem();
			curtext.content = _content;
			if(systemTxt_list.indexOf(curtext) == -1)
			{
				systemTxt_list.push(curtext);
			}
		
			/*if(contentTxt_pool.length > 0)
			{
				cur_txt = contentTxt_pool.pop();
			}*/
		}
		
		/**
		 *显示内容 
		 * @param _content
		 * 
		 */		
		public static function showMsg():void{
			if(curTxt_pool.length >= 1)
				return;
			if(txt_container.numChildren > 0)
				return;
			if(curGlobal_txt == null)
			{
				if(systemTxt_list.length <= 0)
				{
					return;
				}
				else
				{
					curGlobal_txt = systemTxt_list.shift();
				}
			}
			
			curTxt_pool.push(curGlobal_txt);
			curGlobal_txt.y = 300;
			curGlobal_txt.alpha = 0;
			txt_container.addChild(curGlobal_txt);

			Tween.easing({property:"y",value:180},curGlobal_txt,180);
			Tween.easing({property:"alpha",value:1},curGlobal_txt,120,
				function():void{
				curTxt_pool.shift();	
				}
			);
			
			curGlobal_txt.x = (_parentWidth - curGlobal_txt.txt.textWidth) * .5;
			for(var i:int = 0;i < systemTxt_list.length;i++)
			{
				systemTxt_list[i].y = _parentHeight / 3 - i * 25;
			}
			start_time = getTimer();
		}
		
		public static function update():void{
			showMsg();
			showOut();
		}
		
		public static function showOut():void
		{
			if(curTxt_pool.length > 0)
				return;
			/*if(systemTxt_list.length <= 0)
				return;*/
			if(curGlobal_txt == null)
				return;
			if(txt_container.numChildren <= 0)
				return;
			var time:int = getTimer() - start_time;
			if(time < DEFAULT_INTERVAL)
				return;
			
			start_time = getTimer();
//			var cur_txt:SystemMessageItem = systemTxt_list.shift();
//			contentTxt_pool.push(cur_txt);
			curGlobal_txt.alpha = 1;
			Tween.easing({property:"y",value:100},curGlobal_txt,180);
			Tween.easing({property:"alpha",value:0},curGlobal_txt,120,function():void{
				txt_container.removeChild(curGlobal_txt);
				curGlobal_txt = null;
			});
			for(var i:int = 0;i < systemTxt_list.length;i++){
				systemTxt_list[i].y = _parentHeight / 3 - i * 25;
			}
		}
	}
}