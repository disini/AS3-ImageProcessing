package ui.tip.message
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class SystemMessageItem extends Sprite
	{
		public var txt:flash.text.TextField;
		//public var bg:Bitmap;他大爷的又不要底框了日
		public function SystemMessageItem()
		{
			//			bg = new Bitmap();
			//			bg.bitmapData = ResourceManager.getBitmapData("systemMessageBg");
			//			addChild(bg);
			txt = new TextField();
			var textFormat1:TextFormat = new TextFormat();
			textFormat1.align  = "center";
			textFormat1.color = 0xff6600;
			textFormat1.italic = true;
			textFormat1.size = 32;
			textFormat1.bold = true;
			textFormat1.font = "楷体";
			txt.defaultTextFormat = textFormat1;
			txt.autoSize = TextFieldAutoSize.CENTER;
//				(0,0,0xffffff,0x000000,20,"left",false,true,true);
//			txt.setFilter(true);
//			txt.addFilterFormat(0xff0000,0.8,14,14,2,1);
			addChild(txt);
		}
		
		public function set content(value:String):void
		{
			txt.text = value;
			//			bg.width = txt.width * 1.2;
			//			bg.height = txt.height * 1.5;
			//			bg.x = -(bg.width - txt.width)/2;
			//			bg.y =  -(bg.height - txt.height)/2;
		}
	}
}