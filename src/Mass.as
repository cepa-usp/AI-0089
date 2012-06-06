package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Brunno
	 */
	public class Mass extends Sprite 
	{
		private var _mass:int;
		
		private var image:Sprite;
		private var textField:TextField;
		private var textFormat:TextFormat;
		
		public function Mass()
		{
			textField = new TextField();
			textField.background = true;
			textField.backgroundColor = 0xFFFFFF;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.selectable = false;
			textField.textColor = 0x000000;
			textField.x = 0;
			textField.y = this.height / 2 + 5;
			addChild(textField);
			
			textFormat = new TextFormat();
			textFormat.font = "Arial";
			textFormat.size = 14;
		}
		
		public function get mass():int { return _mass; }
		
		public function set mass(value:int):void 
		{
			_mass = value;
			textField.text = String(value) + "x10^8 kg";
			textField.setTextFormat(textFormat);
		}
		
		public function set textMass(value:String):void 
		{
			textField.text = value;
		}
		
	}
	
}