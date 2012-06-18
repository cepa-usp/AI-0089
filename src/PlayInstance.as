package  
{
	import cepa.ai.IPlayInstance;
	import cepa.utils.NotacaoCientifica;
	/**
	 * ...
	 * @author Arthur
	 */
	public class PlayInstance implements IPlayInstance
	{
		
		private var _playMode:int;
		private var _mass1:NotacaoCientifica = new NotacaoCientifica();		
		private var _mass2:NotacaoCientifica = new NotacaoCientifica();
		private var _distance:NotacaoCientifica = new NotacaoCientifica();
		private var _answerMantissa:Number = Number.NaN;
		private var _answerExponent:Number = Number.NaN;
		private var score:Number = 0;
		private var _obs:Object;
		
		
		public function PlayInstance() 
		{
			create();
		}
		
		public function getScore():Number {
			return score;
		}
		
		public function create() {
			createMass(mass1);
			createMass(mass2);
			createDistance();			
		}
		
		public function get energy():NotacaoCientifica {
			var g:NotacaoCientifica = new NotacaoCientifica();
			g.setExpValues(6.67, -11);
			var n:Number = ((g.value *  mass1.value * mass2.value) / distance.value) * -1;
			var nc:NotacaoCientifica = new NotacaoCientifica();
			nc.setValue(n);
			return nc;
		}
		
		private function createMass(mass:NotacaoCientifica):void {
			mass.mantissa = Math.max(int(Math.random() * 1000) / 100, 1)
			mass.exponent = (Math.random() * (32 - 22)) + 22;
		}
		
		private function createDistance():void {
			distance.mantissa = Math.max(int(Math.random() * 1000) / 100, 1);
			var ii:Number = (Math.random() * (10 - 6)) + 6;
			distance.exponent = int(ii);
		}
		

		
		public function get mass1():NotacaoCientifica 
		{
			return _mass1;
		}
		
		public function set mass1(value:NotacaoCientifica):void 
		{
			_mass1 = value;
		}
		
		public function get mass2():NotacaoCientifica 
		{
			return _mass2;
		}
		
		public function set mass2(value:NotacaoCientifica):void 
		{
			_mass2 = value;
		}
		
		public function get distance():NotacaoCientifica 
		{
			return _distance;
		}
		
		public function set distance(value:NotacaoCientifica):void 
		{
			_distance = value;
		}
		
		public function get playMode():int 
		{
			return _playMode;
		}
		
		public function set playMode(value:int):void 
		{
			_playMode = value;
		}
		
		public function get answerMantissa():Number 
		{
			return _answerMantissa;
		}
		
		public function set answerMantissa(value:Number):void 
		{
			_answerMantissa = value;
		}
		
		public function get answerExponent():Number 
		{
			return _answerExponent;
		}
		
		public function set answerExponent(value:Number):void 
		{
			_answerExponent = value;
		}
		
		public function get obs():Object 
		{
			return _obs;
		}
		
		public function set obs(value:Object):void 
		{
			_obs = value;
		}
		
		
		public function debug():void {
			trace("******** sit 1 ****** ");
			trace("massa 1:", mass1);
			trace("massa 2:", mass2);
			trace("distância :", distance);
			trace("E :", energy);
			trace("   ");
		}
		
		public function returnAsObject():Object {
			var obj_answer:Object = new Object();
			obj_answer.mantissa = answerMantissa;
			obj_answer.exponent = answerExponent;
			return { mode:(this.playMode == 0?"FREE":"EVAL"), mass1: scinotToObj(this.mass1), mass2:scinotToObj(this.mass2), distance:scinotToObj(this.distance), E:scinotToObj(this.energy), answer:obj_answer, score:this.score, obs:this.obs };
		}
		
		public function scinotToObj(el:NotacaoCientifica) {
			return { mant: el.mantissa, exp: el.exponent };
		}
		
		/* INTERFACE cepa.ai.IPlayInstance */
		
		public function bind(obj:Object):void 
		{
			
		}
		
	
		public function evaluate():void 
		{
			var e:NotacaoCientifica = energy;
			
			var aval_1:Object = new Object();
			aval_1.name = "Valor numérico dos campos:";
			aval_1.ok = true;
			aval_1.score = 0.4;
			var ans:NotacaoCientifica = new NotacaoCientifica().setExpValues(answerMantissa, answerExponent);
			if (!isIntoToleranceIntervalPercent(Math.abs(ans.value), Math.abs(e.value), 0.01)) {
				aval_1.ok = false;
				aval_1.score = 0.0
				//trace("errou2")
			} 			

			var aval_2:Object  = new Object();
			aval_2.name = "Sinal negativo da energia potencial gravitacional";
			aval_2.ok = false;
			aval_2.score = 0;
			if (signal(answerMantissa * Math.pow(10, answerExponent)) == signal(e.value) && aval_1.ok) {
			aval_2.ok = true;
			aval_2.score = 0.4;
			};
			

			var aval_3:Object  = new Object();
			aval_3.name = "Resposta expressa em notação científica";
			aval_3.ok = false;
			aval_3.score = 0;
			if (answerMantissa > -10 && answerMantissa < 10 && aval_1.ok) {
				aval_3.ok = false;
				aval_3.score = 0.2;				
			};
			
			score = aval_1.score + aval_2.score + aval_3.score;
		}
		
		
		public function isIntoToleranceIntervalPercent(val1:Number, val2:Number, tolerance:Number):Boolean {
			var tolmin:Number = val2 - (val2 *  tolerance);
			var tolmax:Number = val2 + (val2 *  tolerance);
			
			return (val1 > (tolmin) && val1 < (tolmax))
		}
		
		public function signal(val:Number):Boolean {
			return (val >= 0);
		}
		
	}

}