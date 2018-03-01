/** 
 * FileName.java(FileName.as) 
 * foolball game flash client
 * Copyright (c) 2012, 海盗. All rights reserved. 
 * pirates.hoolai.com 
 * 
 */
package tween
{
	import flash.geom.Matrix;
	import flash.utils.getTimer;
	
//	import core.Global;

	/**动画
	 * @author 张磊<zhanglei1@hoolai.com>
	 * date Jul 17, 2012 10:16:07 AM
	 * @version 1.0
	 */
	public class Tween
	{
		private static const EASING:int = 1;
		
		private static const TURNING:int = 2;
		
		private static const EASINGS:int = 3;
		/**
		 *当前动画列表 
		 */		
		private static var tween_list:Array = [];
		
		/**
		 *缓动 
		 * @param _targetProperty
		 * @param _target
		 * @param _speed
		 * @param _completeHandler
		 * @param _tweenHandler
		 * 
		 */		
		public static function easing(_targetProperty:Object,_target:Object,_duration:int,_completeHandler:Function = null,
									  _tweenHandler:Function = null):void{
			var tweenItem:TweenItem = new TweenItem();
			tweenItem.type = EASING;
			tweenItem.start_time = getTimer();
			tweenItem.duration = _duration;
			tweenItem.target = _targetProperty.value;
			tweenItem.property = _targetProperty.property;
			tweenItem.curObject = _target;
			tweenItem.start_property = _target[_targetProperty.property];
			tweenItem.end = false;
			tweenItem.complete_callback = _completeHandler;
			tweenItem.tween_callback = _tweenHandler;
			deleteOld(tweenItem);
			tween_list.push(tweenItem);
		}
		
		/**
		 *缓动,同时更改两个属性，由于用处较少，没有扩展，偷个懒，哇咔咔
		 * @param _targetProperty
		 * @param _target
		 * @param _speed
		 * @param _completeHandler
		 * @param _tweenHandler
		 * 
		 */		
		public static function easings(_targetProperty:Object,_target:Object,_duration:int,_completeHandler:Function = null,
									  _tweenHandler:Function = null):void{
			var tweenItem:TweenItem = new TweenItem();
			tweenItem.type = EASINGS;
			tweenItem.start_time = getTimer();
			tweenItem.duration = _duration;
			tweenItem.target = _targetProperty.value;
			tweenItem.target_2 = _targetProperty.value_2;
			tweenItem.property = _targetProperty.property;
			tweenItem.property_2 = _targetProperty.property_2;
			tweenItem.curObject = _target;
			tweenItem.start_property = _target[_targetProperty.property];
			tweenItem.start_property_2 = _target[_targetProperty.property_2];
			tweenItem.end = false;
			tweenItem.complete_callback = _completeHandler;
			tweenItem.tween_callback = _tweenHandler;
			deleteOld(tweenItem);
			tween_list.push(tweenItem);
		}
		
		/**
		 *翻转 
		 * @param _property
		 * @param _target
		 * @param _loop
		 * @param _completeHandler
		 * 
		 */		
		public static function turning(_property:String,_target:Object,_loop:int,_completeHandler:Function = null):void{
			var tweenItem:TweenItem = new TweenItem();
			tweenItem.type = TURNING;
			tweenItem.matrix = new Matrix(-1);
			tweenItem.curObject = _target;
			tweenItem.matrix.tx = tweenItem.curObject.x;
			tweenItem.matrix.ty = tweenItem.curObject.y;
			tweenItem.curObject.transform.matrix = tweenItem.matrix;
			tweenItem.property = _property;
			tweenItem.target = _loop;
			tweenItem.duration = 0;
			tweenItem.end = false;
			tweenItem.complete_callback = _completeHandler;
			deleteOld(tweenItem);
			tween_list.push(tweenItem);
		}
		
		private static function deleteOld(_tweenItem:TweenItem):void{
			var len:int = tween_list.length;
			for(var i:int = 0;i < len;i++){
				var tweenItem:TweenItem = tween_list[i];
				if(tweenItem.curObject == _tweenItem.curObject && tweenItem.property == _tweenItem.property){
					tween_list.splice(i,1);
					break;
				}
			}
		}
		
		public static function deleteTurnTween(_curObject:Object):void{
			var len:int = tween_list.length;
			for(var i:int = 0;i < len;i++){
				var tweenItem:TweenItem = tween_list[i];
				if(tweenItem.curObject == _curObject){
					tween_list.splice(i,1);
					if(tweenItem.matrix){
						tweenItem.matrix[tweenItem.property] = 1;
						tweenItem.curObject.transform.matrix = tweenItem.matrix;
					}
					break;
				}
			}
		}
		
		/**
		 *缓动比率 
		 * @param t
		 * @param d
		 * @return 
		 * 
		 */		
		private static function calculateRate(t:Number,d:Number):Number {
			return 1 - (t = 1 - (t / d)) * t;
		}
		
		public static function update():void{
			var len:int = tween_list.length;
			for(var i:int = 0;i < len;i++){
				var tweenItem:TweenItem = tween_list[i];
				
				if(tweenItem == null)continue;
				
				if(tweenItem.end){
					tween_list.splice(i,1);
					if(tweenItem.complete_callback != null)
						tweenItem.complete_callback(tweenItem.curObject);
					continue;
				}
				
				var cur_time:int,rate:Number;
				switch(tweenItem.type){
					case EASING:
						cur_time = getTimer();
						rate = calculateRate(cur_time - tweenItem.start_time,tweenItem.duration);
						
						tweenItem.curObject[tweenItem.property] = tweenItem.start_property + (tweenItem.target - 
							tweenItem.start_property)* rate;
						
						if(tweenItem.tween_callback != null)tweenItem.tween_callback();
						
						if(cur_time - tweenItem.start_time >= tweenItem.duration){
							tweenItem.curObject[tweenItem.property] = tweenItem.target;
							tweenItem.end = true;
						}
						break;
					case EASINGS:
						cur_time = getTimer();
						rate = calculateRate(cur_time - tweenItem.start_time,tweenItem.duration);
						
						tweenItem.curObject[tweenItem.property] = tweenItem.start_property + (tweenItem.target - 
							tweenItem.start_property)* rate;
						tweenItem.curObject[tweenItem.property_2] = tweenItem.start_property_2 + (tweenItem.target_2 - 
							tweenItem.start_property_2)* rate;
						
						if(tweenItem.tween_callback != null)tweenItem.tween_callback();
						
						if(cur_time - tweenItem.start_time >= tweenItem.duration){
							tweenItem.curObject[tweenItem.property] = tweenItem.target;
							tweenItem.end = true;
						}
						break;
					case TURNING:
						tweenItem.matrix[tweenItem.property] +=.2;
						if(tweenItem.matrix[tweenItem.property] >= 1){
							tweenItem.duration++;
							if(tweenItem.duration < tweenItem.target)tweenItem.matrix[tweenItem.property] = -1;
						}
						if(tweenItem.duration >= tweenItem.target){
							tweenItem.end = true;
							tweenItem.matrix[tweenItem.property] = 1;
						}
						tweenItem.curObject.transform.matrix = tweenItem.matrix;
						break;
				}
			}
		}
	}
}
import flash.geom.Matrix;

class TweenItem{
	public var type:int;
	public var property:String;
	public var property_2:String;
	public var start_property:int;
	public var start_property_2:int;
	public var start_time:int;
	public var duration:int;
	public var target:Number;
	public var target_2:Number;
	public var end:Boolean;
	public var curObject:Object;
	public var complete_callback:Function;
	public var tween_callback:Function;
	public var matrix:Matrix;
}