﻿package  {
	
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
			TextField(this.txMantissa).restrict = "0-9,\\-"
			TextField(this.txMantissa).addEventListener(FocusEvent.FOCUS_IN, onTxFocusOut);
			TextField(this.txExponent).restrict = "0-9,\\-"
		}
		
		private function onTxFocusOut(e:FocusEvent):void 
		{
			if (e.target == this.txMantissa) {
				
			} else {
				
			}
		}
		
		
		public function setValue(mantissa:Number, exponent:int):void {
			this.txMantissa.text = mantissa.toFixed(2).replace(".", ",");
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
					TextField(this.txMantissa).selectable = true;
					TextField(this.txExponent).selectable = true;
					break;
				case TYPE_VIEW:
					this.outter.visible = false;
					this.fields.visible = false;					
					TextField(this.txMantissa).selectable = false;
					TextField(this.txExponent).selectable = false;
					TextField(this.txMantissa).mouseEnabled = false;
					TextField(this.txExponent).mouseEnabled = false;
					TextField(this.txExponent).selectable = false;
					break;
			}
		}
		
		
		
		public function getType():int {
			return type;
		}
		
		
	}
	
}
