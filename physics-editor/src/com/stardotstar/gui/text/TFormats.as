package com.stardotstar.gui.text
{
	import flash.text.Font;
	import flash.text.TextFormat;
	//import flash.utils.getDefinitionByName;

	public class TFormats
	{
		public function TFormats()
		{			
		}
		
		// set up fonts - this is a pain to do dynamically, so we'll do it here manually.


		public static function getFontByName(fName:String):Font
		{
			var theFont:Font;
			
			switch (fName)
			{
				case "HelveticaNeue":
					theFont = new HelveticaNeue();
				break;
				
				case "HelveticaNeueBold":
					theFont = new HelveticaNeueBold();
				break;
				
				default:
					trace("	**** ERROR **** Font name not declared in TFormats getFontByName");
				break;
			}
			
			//trace("theFont",theFont, theFont.fontName);
			
			return theFont;
		}
		
		public static function getTFormatToSize(size:int, theFont:Font, colour:int=0xFFFFFF, tAlign:String="left",  lineSpace:Number=0):TextFormat
		{
//			var ClassReference:Class =	getDefinitionByName(fontStr) as Class;
//			
//			var TFfont:Font = new ClassReference();
			
			var newFormat:TextFormat = new TextFormat();
			newFormat.font = theFont.fontName;
			newFormat.color = colour;
			newFormat.size = size;
			newFormat.align = tAlign;
			newFormat.leading = lineSpace;		
			
			return newFormat;
			
		}
	}
}