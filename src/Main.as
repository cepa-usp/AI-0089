package 
{
	import cepa.ai.AI;
	import cepa.ai.AIObserver;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Main extends Sprite implements AIObserver
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/* INTERFACE cepa.ai.AIObserver */
		
		public function onResetClick():void 
		{
			atividade.changeState(Atividade.STATE_RESET);
		}
		
		public function onScormFetch():void 
		{
			
		}
		
		public function onScormSave():void 
		{
			
		}
		
		public function onTutorialClick():void 
		{
			
		}
		
		/* INTERFACE cepa.ai.AIObserver */
		
		public function onStatsClick():void 
		{
			
		}
		
		/* INTERFACE cepa.ai.AIObserver */
		
		public function onScormConnected():void 
		{
			
		}
		
		public function onScormConnectionError():void 
		{
			
		}
		

		private var atividade:Atividade 
		private function init(e:Event = null):void 
		{
			var ai:AI = new AI(this);
			atividade = new Atividade(ai);
			ai.container.messageLabel.visible = false;
			ai.container.addChild(atividade);
			ai.addObserver(this);
			ai.initialize();
			//ai.addObserver(atividade);
			
			
			
		}
		
	}
	
}