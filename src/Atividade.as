package  
{
	import cepa.ai.AI;
	import cepa.ai.AIObserver;
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.Elastic;
	import com.eclecticdesignstudio.motion.easing.Quad;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Arthur
	 */
	public class Atividade extends Sprite implements AIObserver
	{
		public static const STATE_NONE:int = -1;
		public static const STATE_READY:int = 0;
		public static const STATE_EVALUATING:int = 1;
		public static const STATE_FEEDBACK:int = 2;
		public static const STATE_LOADING:int = 3;
		public static const STATE_RESET:int = 4;
		
		
		public static const MODE_FREEPLAY:int = 0;
		public static const MODE_EVALUATE:int = 1;
		
		private var layerBackground:Sprite = new Sprite();
		private var layerBotoesNovoExercicio:Sprite = new Sprite();
		private var layerBlocoBaixo:Sprite = new Sprite();
		private var layerPlanetas:Sprite = new Sprite();
		private var blocoNovoExercicio:BlocoNovoExercicio = new BlocoNovoExercicio();
		private var blocoBaixo:BlocoBaixo = new BlocoBaixo();
		private var posBlocoNovoExercicio:Point = new Point(20, 20);
		private var posBlocoBaixo:Point = new Point(10, 446);
		private var mode:int = MODE_FREEPLAY;
		private var state:int = STATE_NONE;
		private var ai:AI = null;
		
		public function Atividade(ai:AI) 
		{
			this.ai = ai;
			addChild(layerBackground);
			layerBackground.addChild(new Background());
			addChild(layerPlanetas);
			addChild(layerBotoesNovoExercicio);
			layerBotoesNovoExercicio.addChild(blocoNovoExercicio);
			addChild(layerBlocoBaixo);
			layerBlocoBaixo.addChild(blocoBaixo);
			blocoBaixo.x = posBlocoBaixo.x;
			blocoBaixo.y = posBlocoBaixo.y;
			blocoNovoExercicio.x = posBlocoNovoExercicio.x;
			blocoNovoExercicio.y = posBlocoNovoExercicio.y;
			
			changeState(STATE_RESET);
			
		}
		
		
		public function changeState(state:int):void {
			this.state = state;
			switch(state) {
				case STATE_EVALUATING:
					
					break;
				case STATE_FEEDBACK:
					break;
				case STATE_RESET:
					cleanUp();
					
					break;					
				case STATE_LOADING:
					createPlay();
					changeState(STATE_READY);
					break;
				case STATE_READY:
					break;

			}
		}
		
		private function createPlay():void {
			var play:PlayInstance = new PlayInstance();
			var spr:Sprite = new Sprite();
			spr.name = "play";
			var planeta1:Planeta1 = new Planeta1();
			planeta1.name = "planeta1";
			var planeta2:Planeta2 = new Planeta2();
			planeta2.name = "planeta2";
			spr.addChild(planeta1);
			spr.addChild(planeta2);
			var pos1:Point = new Point(rndBetween(200, 300), rndBetween(200, 400))
			var pos2:Point = new Point(rndBetween(400, 600), rndBetween(200, 400))
			var scale1:Number = rndBetween(7, 10) / 10;
			var scale2:Number = rndBetween(7, 10) / 10;
			layerPlanetas.addChild(spr);			
			planeta1.scaleX = 0.01;
			planeta1.scaleY = 0.01;
			planeta2.scaleX = 0.01;
			planeta2.scaleY = 0.01;
			planeta1.x = ai.container.stage.stageWidth / 2;
			planeta2.x = ai.container.stage.stageWidth / 2;
			planeta1.y = ai.container.stage.stageHeight / 2;
			planeta2.y = ai.container.stage.stageHeight / 2;			
			spr.addChild(planeta1);
			spr.addChild(planeta2);
			Actuate.tween(planeta1, 1.1, { scaleX:1, scaleY:1, x:pos1.x, y:pos1.y } ).ease(Quad.easeInOut);
			Actuate.tween(planeta2, 1.1, { scaleX:1, scaleY:1, x:pos2.x, y:pos2.y} ).ease(Quad.easeInOut);
			
		}
		
		private function cleanUp() {
			var spr:Sprite = Sprite(layerPlanetas.getChildByName("play"));
			if (spr == null) {
				changeState(STATE_LOADING);
				return;
			}
			var p1:Planeta1 = Planeta1(spr.getChildByName("planeta1"));			
			var p2:Planeta2 = Planeta2(spr.getChildByName("planeta2"));
			Actuate.tween(p1, 0.8, { scaleX:0.01, scaleY:0.01, x:ai.container.stage.stageWidth / 2, y:ai.container.stage.stageHeight / 2 } ).ease(Quad.easeOut);
			Actuate.tween(p2, 0.8, { scaleX:0.01, scaleY:0.01, x:ai.container.stage.stageWidth / 2, y:ai.container.stage.stageHeight / 2 } ).ease(Quad.easeOut).onComplete(function() { layerPlanetas.removeChildAt(0);changeState(STATE_LOADING); } );
		}
		
		public function rndBetween(valMin:Number, valMax:Number):Number {
			var v:Number = (Math.random() * (valMax - valMin)) + valMin;
			return v;
			
		}
		
		public function evaluate():void {
			
		}
		
		
		
		
		/* INTERFACE cepa.ai.AIObserver */
		
		public function onResetClick():void 
		{
			
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
		
	
		
		
		
	}

}