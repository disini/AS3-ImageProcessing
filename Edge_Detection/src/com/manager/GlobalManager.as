package com.manager
{
	import com.utils.Log;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.media.Video;
	
	import mx.utils.NameUtil;
	
	import avmplus.getQualifiedClassName;
	
	import utils.Utils;


	/**
	 * 
	 * @author LiuSheng  QQ:532230294
	 * 创建时间 : 2016-12-8 下午5:25:42
	 *
	 */
	public class GlobalManager
	{
		public static const MAX_FRAMES_NUM:int = 1000;
//		public static const IMAGESEQ_HEIGHT:int = 100;
		public static const IMAGEFRAME_WIDTH:int = 120;
		public static const IMAGEFRAME_HEIGHT:int = 68;
		
//		public static const
		
		public static var socketConnected:Boolean;
		public static var isVideoPaused:Boolean = false;
		
		public static var snapShotter:SnapShotter1;
		
//		private static var _curSelectedIdxInFive:int = 4;
//		public static var curSelectedIdx:int = 49;
		public static var curSelectedIdx:int = 999;
		
		public static var curVideoFrameRate:Number = 25;
		
		private static var _allFragmentData:Object = {};
		private static var _timefragmentData:Object = {};
		private static var _labelFragmentData:Object = {};
		
		private static var _curFocusedRowNum:int = 0;
		
//		public static const COLOR_DICT:Array = [0xFF6600, 0xFF0066, 0x00FF66, 0x66FF00, 0x660066, 0x0FF066, 0xF00F66, 0xF0F066];
		public static const COLOR_DICT:Array = ["0xFF6600", "0xFF0066", "0x00FF66", "0x66FF00", "0x660066", "0x0FF066", "0xF00F66", "0xF0F066"];
		
//		public static var curFragmentIndex:int = -1;
		
		public static var curFragmentId:int = -1;
		public static var curFragmentLongId:int = -1;
		
		public static var curFragmentData:Object = {};
		
		public static var curIndexArr:Array = [];
		
		public static var curFragmentType:int = -1;
		
		public static var isSeeking:Boolean = false;
		
		public static var needAutoCheckFragment:Boolean = false;
		public static var needToNotifyJsCurFragmentDrawingComplete:Boolean = false;
		
		public static var waitingForSeekComplete:Boolean = false;
		
		//public static const MAINVIDEO_WIDTH:Number = 500;
		//public static const MAINVIDEO_HEIGHT:Number = 285;
		
		public static const MAINVIDEO_WIDTH:Number = 600;
		public static const MAINVIDEO_HEIGHT:Number = 338;
		
		public static var hasChangeIdxManually:Boolean = false;
		
		public static var isScrollBarDraggingDict:Array = [false, false, false];
		
		public static var snappedFramesNum:int = 0;
		
		
		public static var snapBmdDicts:Array;
		public static var timeDicts:Array;
		public static var frameDicts:Array;
		
		public static const FROMSTARTTOEND_COUNT:int = 21;
		
		
//		public static var bmdDict:Vector.<BitmapData> = new Vector.<BitmapData>(50);
		public static var _totalSnapBmdDict:Vector.<BitmapData> = new Vector.<BitmapData>();
		public static var _startSnapBmdDict:Vector.<BitmapData> = new Vector.<BitmapData>(FROMSTARTTOEND_COUNT);
		public static var _endSnapBmdDict:Vector.<BitmapData> = new Vector.<BitmapData>(FROMSTARTTOEND_COUNT);
		
//		public static var _adImageBmdDict:Vector.<BitmapData>;
//		public static var _imageLoaderDict:Vector.<Loader> = new Vector.<Loader>();
		public static var _totalTimeDict:Vector.<Number> = new Vector.<Number>();
		public static var _startTimeDict:Vector.<Number> = new Vector.<Number>(FROMSTARTTOEND_COUNT);
		public static var _endTimeDict:Vector.<Number> = new Vector.<Number>(FROMSTARTTOEND_COUNT);
		
		
		public static var _totalFrameDict:Vector.<int> = new Vector.<int>();
		public static var _startFrameDict:Vector.<int> = new Vector.<int>(FROMSTARTTOEND_COUNT);
		public static var _endFrameDict:Vector.<int> = new Vector.<int>(FROMSTARTTOEND_COUNT);
		
		public static var _totalAccurateFrameDict:Vector.<Number> = new Vector.<Number>();
		
		
		public function GlobalManager()
		{
		}
		
		/*public static function onClickItemToSelectFrame(idx:int):void
		{
			_curSelectedIdxInFive = idx;
			snapShotter.onClickItemToSelectFrame(_curSelectedIdxInFive);
		}*/
		
		
		public static function setup():void
		{
			setupArrays();
		}
		
		static private function setupArrays():void 
		{
			snapBmdDicts = [_totalSnapBmdDict, _startSnapBmdDict, _endSnapBmdDict];
			timeDicts = [_totalTimeDict, _startTimeDict, _endTimeDict];
			frameDicts = [_totalFrameDict, _startFrameDict, _endFrameDict];
		}
		
	
		
		
		
		
		public static function findVideoContainer(container:DisplayObjectContainer):DisplayObject
		{
			var containerName:String = container.name ? container.name : getQualifiedClassName(container);
			trace("findVideoContainer():, container is " + containerName + " , container.numChildren = " + container.numChildren);
			if(containerName == "share_mc")
			{
				trace("containerName == share_mc");
			}
			//			for each (var mc:DisplayObject in container) 
			var mc:DisplayObject;
			for (var i:int = 0; i < container.numChildren; i++) 
			{
				try
				{
					mc = container.getChildAt(i);
					var mcName:String = mc.name ? mc.name : getQualifiedClassName(mc);
					trace("findVideoContainer():, mc is " + mcName + " , mc.parent = " + mc.parent + " " + containerName);
				} 
				catch(error:Error) 
				{
					trace(error);
					//					continue;
				}
				
				if(mc.name == "mainVideo")
				{
					Log.info("alert", "Video found yet! video is " + mc.name ? mc.name : mc);
				}
				
				if((mc is Video) || (mc as Video) != null)
				{
					//					ExternalInterface.call("alert", "Video Container found yet! video is " + mc.name ? mc.name : mc);
					Log.info("alert", "Video Container found yet! video is " + mc.name ? mc.name : mc);
					return mc;
				}
				else if(mc is DisplayObjectContainer)
				{
					//					return findVideoContainer(mc as DisplayObjectContainer);
					var result:DisplayObject = findVideoContainer(mc as DisplayObjectContainer);
					if(result)
					{
						return result;
					}
					else
					{
						continue;
					}
				}
			}
			return null;
		}

		public static function get curFocusedRowNum():int
		{
			return _curFocusedRowNum;
		}
		
		
		public static function initFragmentData(data:Object):void
		{
//			_allFragmentData = data;
			if(data.type == 1)
			{
				_timefragmentData = data;
			}
			else if(data.type == 2)
			{
				_labelFragmentData = data;
			}
			Log.info("GlobalManager.initFragmentData() : \n");
//			for(var i:int = 0; i < _timefragmentData.resultlist.length;i++)
			/*for(var i:int = 0; i < _timefragmentData.resultlist.length;i++)
			{
				var data:Object = _timefragmentData.resultlist[i];
				var startTime:Number = data.startframe / curVideoFrameRate;
				var startTimeStr:String = Utils.getTimeStr1(startTime * 1000);
				Log.info("fragment " + i +" : startTime = " + startTimeStr + ";\n");
				
			}*/
		}
		
		
		public static function initLabelData(data:Object):void
		{
			
		}
		
		
		public static function onModifyCurFragmentList(id:int, data:Object):void
		{
			Log.info("GlobalManager.onModifyCurFragmentList() : \n");
			var list:Object;
			switch(id)
			{
				case 1:
				{
					list = _timefragmentData;
					break;
				}
				case 2:
				{
					list = _labelFragmentData;
					break;
				}
			}
				list.resultlist[id] = data;
		}
		
		
		
		public static function onAddDataToCurFragmentList(id:int, data:Object):void
		{
			Log.info("GlobalManager.onAddDataToCurFragmentList() : \n");
			var list:Object;
			switch(id)
			{
				case 1:
				{
					list = _timefragmentData;
					break;
				}
				case 2:
				{
					list = _labelFragmentData;
					break;
				}
			}
			list.resultlist.push(data);
		}
		
		public function onUpdateByFrame():void
		{
			
		}

		public static function get allFragmentData():Object
		{
			return _allFragmentData;
		}

		public static function get timefragmentData():Object
		{
			return _timefragmentData;
		}

		
		public static function get labelFragmentData():Object
		{
			return _labelFragmentData;
		}
		
		public static function getLabelDatabyName(data:Object):Object
		{
			for each(var obj:Object in _labelFragmentData.resultlist) 
			{
				if(obj.name == data.name)
				{
					return obj;
				}
			}
			return null;
		}
		
		public static function getLabelDatabyName1(data:Object):Object
		{
			return _labelFragmentData.resultlist[data.index[0]];
		}
		
		
		public static function getCurFrameByTimePoint(curTime:Number):int
		{
			//var curFrame:int = Math.round(curTime * GlobalManager.curVideoFrameRate);
			var curFrame:int = int(curTime * curVideoFrameRate);
			return curFrame;
		}

	}
}