package 
{
	import cepa.ai.AI;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		

		
		private function init(e:Event = null):void 
		{
			var ai:AI = new AI(this);
			
			
			
		}
		
	}
	
}