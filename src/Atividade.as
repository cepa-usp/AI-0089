package  
{
	import cepa.ai.AI;
	import cepa.ai.AIObserver;
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.Elastic;
	import com.eclecticdesignstudio.motion.easing.Linear;
	import com.eclecticdesignstudio.motion.easing.Quad;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
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
		private var layerControle:Sprite = new Sprite();
		private var layerPlanetas:Sprite = new Sprite();
		private var layerFeedback:Sprite = new Sprite();
		private var blocoControle:BlocoBaixo = new BlocoBaixo();
		private var posblocoControle:Point = new Point(10, 10);
		private var mode:int = MODE_FREEPLAY;
		private var state:int = STATE_NONE;
		private var ai:AI = null;
		private var playInstance:PlayInstance = null;
		
		public function Atividade(ai:AI) 
		{
			this.ai = ai;
			addChild(layerBackground);
			layerBackground.addChild(new Background());
			addChild(layerPlanetas);
			addChild(layerControle);
			layerControle.addChild(blocoControle);
			blocoControle.x = posblocoControle.x;
			blocoControle.y = posblocoControle.y;
			addChild(layerFeedback);
			rotateBg();
			changeState(STATE_RESET);
			blocoControle.btTerminei.addEventListener(MouseEvent.CLICK, function(e:Event) {
				changeState(STATE_EVALUATING);
			});
			blocoControle.btNovoExercicio.addEventListener(MouseEvent.CLICK, function(e:Event) {
				changeState(STATE_RESET);
			});	
			blocoControle.btValendoNota.addEventListener(MouseEvent.CLICK, function(e:Event) {
				mode = MODE_EVALUATE;
				changeState(STATE_RESET);
			});			
		}
		
		private var r:Number = 0;
		public function rotateBg():void {			
			r += 2;
			Actuate.tween(Background(layerBackground.getChildAt(0)).estrelas, 2, { rotation:r} ).onComplete(rotateBg).ease(Linear.easeNone); 
			
		}
		
		
		
		
		public function changeState(state:int):void {
			this.state = state;
			switch(state) {
				case STATE_EVALUATING:
					evaluate();
					break;
				case STATE_FEEDBACK:
					showFeedback();
					break;
				case STATE_RESET:
					hideFeedback();
					cleanUp();
					
					break;					
				case STATE_LOADING:
					createPlay();
					changeState(STATE_READY);
					break;
				case STATE_READY:
					blocoControle.btTerminei.visible = true;
					blocoControle.btNovoExercicio.visible = false;
					ai.container.enableComponent(blocoControle.btTerminei);
					if (mode == MODE_FREEPLAY) {
						ai.container.enableComponent(blocoControle.btValendoNota);
					}
					ai.container.stage.focus = blocoControle.txEnergy.txMantissa;
					break;

			}
		}
		
		private function showFeedback():void 
		{
			var scr:TelaResposta = new TelaResposta();
			scr.name = "resposta";
			scr.txRespostaEsperada.setType(SciNotComponent.TYPE_VIEW);
			scr.txRespostaUsuario.setType(SciNotComponent.TYPE_VIEW);
			layerFeedback.addChild(scr);
			scr.x = 0;
			scr.y = 200;
			scr.alpha = 0;
			scr.txRespostaEsperada.setTextColor(0xFFFFFF);
			scr.txRespostaUsuario.setTextColor(0xFFFFFF);
			scr.txRespostaUsuario.txMantissa.text = playInstance.answerMantissa.toString();
			scr.txRespostaUsuario.txExponent.text = playInstance.answerExponent.toString();
			scr.txRespostaEsperada.setValue(playInstance.energy.mantissa, playInstance.energy.exponent);
			ai.container.stage.focus =  blocoControle.btNovoExercicio;

			
			Actuate.tween(scr, 1, { alpha:1 } );
		}

		private function hideFeedback():void {
			if (layerFeedback.getChildByName("resposta") == null) return;
			Actuate.tween(layerFeedback.getChildByName("resposta"), 1.5, { y:700 } ).ease(Elastic.easeInOut).onComplete(function() {
				layerFeedback.removeChild(layerFeedback.getChildByName("resposta"));
			});
		}
		
		
		private var pos1:Point;
		private var pos2:Point;
		private function createPlay():void {
			blocoControle.txEnergy.setType(SciNotComponent.TYPE_EDIT);
			blocoControle.txEnergy.txMantissa.text = "";
			blocoControle.txEnergy.txExponent.text = "";
			var play:PlayInstance = new PlayInstance();
			playInstance = play;
			var spr:Sprite = new Sprite();
			spr.name = "play";
			var planeta1:Planeta1 = new Planeta1();
			planeta1.name = "planeta1";
			var planeta2:Planeta2 = new Planeta2();
			planeta2.name = "planeta2";
			spr.addChild(planeta1);
			spr.addChild(planeta2);
			pos1 = new Point(rndBetween(200, 300), rndBetween(200, 400))
			pos2 = new Point(rndBetween(400, 600), rndBetween(200, 400))
			var scale1:Number = rndBetween(7, 10) / 10;
			var scale2:Number = rndBetween(7, 10) / 10;
			layerPlanetas.addChild(spr);			
			var s:Sprite = new Sprite();
			s.name = "lines";
			s.alpha = 0;
			spr.addChild(s);
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
			Actuate.tween(planeta2, 1.1, { scaleX:1, scaleY:1, x:pos2.x, y:pos2.y } ).ease(Quad.easeInOut).onComplete(enablePlay);
		}
		
		private function enablePlay():void 
		{
			var s:Sprite = Sprite(Sprite(layerPlanetas.getChildByName("play")).getChildByName("lines"));
			s.graphics.lineStyle(1, 0xFF8000, 0.8);
			s.graphics.moveTo(pos1.x, pos1.y);
			s.graphics.lineTo(pos2.x, pos2.y);
			var p:Point = Point.interpolate(pos2, pos1, 0.5);
			p.y -= 50;
			var dist:SciNotComponent = new SciNotComponent();
			dist.setType(SciNotComponent.TYPE_VIEW);
			dist.setTextColor(0xFF8000);
			dist.setValue(playInstance.distance.mantissa, playInstance.distance.exponent);
			dist.x = p.x - (dist.width / 2);
			dist.txMantissa.text = "d=" + dist.txMantissa.text;
			dist.y = p.y;
			s.addChild(dist);
			Actuate.tween(s, 1, { alpha:1 } );

		}
		
		private function cleanUp() {
			var spr:Sprite = Sprite(layerPlanetas.getChildByName("play"));
			ai.container.disableComponent(blocoControle.btNovoExercicio);
			ai.container.disableComponent(blocoControle.btValendoNota);
			ai.container.disableComponent(blocoControle.btTerminei);
			if (spr == null) {
				changeState(STATE_LOADING);
				return;
			}
			var s:Sprite = Sprite(spr.getChildByName("lines"));
			Actuate.tween(s, 0.7, { alpha:0 } );

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
			
			blocoControle.btNovoExercicio.visible = true;
			blocoControle.btTerminei.visible = false;
			ai.container.enableComponent(blocoControle.btNovoExercicio);
			playInstance.answerMantissa = parseFloat(blocoControle.txEnergy.txMantissa.text);
			playInstance.answerExponent = parseFloat(blocoControle.txEnergy.txExponent.text);
			
			playInstance.evaluate();
			trace("avaliou")
			
			ai.playInstances.push(playInstance);
			
			changeState(STATE_FEEDBACK);
			
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