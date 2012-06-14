package  {
	
	import flash.display.MovieClip;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	
	
	public class SciNotComponent extends MovieClip {
		
		

		public static const TYPE_EDIT:int = 1;
		public static const TYPE_VIEW:int = 2;
		public static const TYPE_EDIT_NOADJUST:int = 3;
		
		private var type:int = TYPE_EDIT;		
		
		public function SciNotComponent() {
			// constructor code
			TextField(this.txMantissa).addEventListener(FocusEvent.FOCUS_IN, onTxFocusIn);
			TextField(this.txMantissa).addEventListener(FocusEvent.FOCUS_IN, onTxFocusOut);
		}
		
		private function onTxFocusOut(e:FocusEvent):void 
		{
			if (e.target == this.txMantissa) {
				
			} else {
				
			}
		}
		
		
		public function setValue(mantissa:Number, exponent:int):void {
			this.txMantissa.text = mantissa.toFixed(2);
			this.txExponent.text = exponent.toString();
		}
		
		public function setTextColor(color:int):void {
			txMantissa.textColor = color;
			txMult.textColor = color;
			txExponent.textColor = color;

		}
		private function onTxFocusIn(e:FocusEvent):void 
		{
			if (e.target == this.txMantissa) {
				
			} else {
				
			}			
		}
		
		public function setType(val:int):void {
			this.type = val;
			switch(type) {				
				case TYPE_EDIT:
				case TYPE_EDIT_NOADJUST:
					this.outter.visible = true;
					this.fields.visible = true;
					break;
				case TYPE_VIEW:
					this.outter.visible = false;
					this.fields.visible = false;					
					break;
			}
		}
		
		
		
		public function getType():int {
			return type;
		}
		
		
	}
	
}
