package  
{
	/**
	 * ...
	 * @author Arthur
	 */
	public class PlayInstance 
	{
		
		private var _mode:int;
		private var _mass1:NotacaoCientifica = new NotacaoCientifica();		
		private var _mass2:NotacaoCientifica = new NotacaoCientifica();
		private var _distance:NotacaoCientifica = new NotacaoCientifica();
		
		
		
		public function PlayInstance() 
		{
			create();
		}
		
		public function create() {
			createMass(mass1);
			createMass(mass2);
			createDistance();			
		}
		
		public function get energy():NotacaoCientifica {
			var g:NotacaoCientifica = new NotacaoCientifica();
			g.setExpValues(6.67, -11);
			var n:Number = ( -1 * g.value *  mass1.value * mass2.value) / distance.value
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
		
		public function get mode():int 
		{
			return _mode;
		}
		
		public function set mode(value:int):void 
		{
			_mode = value;
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
		
		public function debug():void {
			trace("******** sit 1 ****** ");
			trace("massa 1:", mass1);
			trace("massa 2:", mass2);
			trace("distância :", distance);
			trace("E :", energy);
			trace("   ");
		}
		
		public function returnAsObject():Object {
			return { mode:(this.mode == 0?"FREE":"EVAL"), mass1: scinotToObj(this.mass1), mass2:scinotToObj(this.mass2), distance:scinotToObj(this.distance), E:scinotToObj(this.energy) };
		}
		public function scinotToObj(el:NotacaoCientifica) {
			return { mant: el.mantissa, exp: el.exponent };
		}
		
	}

}