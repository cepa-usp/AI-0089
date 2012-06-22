package  
{
	import cepa.ai.AI;
	import cepa.ai.AIConstants;
	import cepa.ai.AIInstance;
	import cepa.ai.AIObserver;
	import cepa.ai.IPlayInstance;
	import cepa.eval.ProgressiveEvaluator;
	import cepa.scorm.CmiConstants;
	import cepa.tutorial.CaixaTexto;
	import cepa.tutorial.Tutorial;
	import cepa.tutorial.TutorialEvent;
	import com.adobe.serialization.json.JSON;
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.Elastic;
	import com.eclecticdesignstudio.motion.easing.Linear;
	import com.eclecticdesignstudio.motion.easing.Quad;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Arthur
	 */
	public class Atividade extends Sprite implements AIObserver, AIInstance
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
			ai.evaluator = new ProgressiveEvaluator(ai);
			ai.ai_instance = this;
			addChild(layerBackground);
			layerBackground.addChild(new Background());
			addChild(layerPlanetas);
			addChild(layerControle);
			ai.debugMode = true;
			//ai.debugTutorial = true;
			layerControle.addChild(blocoControle);
			blocoControle.x = posblocoControle.x;
			blocoControle.y = posblocoControle.y;
			addChild(layerFeedback);
			ai.container.setAboutScreen(new AboutScreen());
			ai.container.setInfoScreen(new InstructScreen());
			rotateBg();
			changeState(STATE_RESET);
			blocoControle.btTerminei.addEventListener(MouseEvent.CLICK, function(e:Event):void {
				if(checkFields()){
					changeState(STATE_EVALUATING);
				}
			});
			blocoControle.btNovoExercicio.addEventListener(MouseEvent.CLICK, function(e:Event):void {
				changeState(STATE_RESET);
			});	
			blocoControle.btValendoNota.addEventListener(MouseEvent.CLICK, function(e:Event):void {
				
				openValendoScreen();
			});	
			
			
		}
		
		private function checkFields():Boolean 
		{
			// Enviar essa função pra dentro do componente
			var r:Boolean = true;
			if (blocoControle.txEnergy.txExponent.text == "") {
				highLightControl(blocoControle.txEnergy.fields.borderExp);
				r = false;
			}
			if (blocoControle.txEnergy.txMantissa.text == "") {
				highLightControl(blocoControle.txEnergy.fields.borderMantissa);
				r = false;
			}
			return r;
		}
		
		private var a:Sprite = new Sprite();
		private function highLightControl(tx:Sprite):void 
		{
			a.filters = tx.filters;
			tx.filters = [new GlowFilter(0xFF8000, 0.01, 3, 3, 2, 2, true)];			
			Actuate.effects(tx, 0.4).filter(GlowFilter, { alpha:1 ,  blurX: 12, blurY: 12 } ).onComplete(function() {
				Actuate.effects(tx, 0.6).filter(GlowFilter, { alpha:0 ,  blurX: 12, blurY: 12 } ).onComplete(function() {
					tx.filters = a.filters;
				})
			});
			

			
		}
		
		private var r:Number = 0;
		public function rotateBg():void {			
			r += 2;
			if (r > 180) r = 0;
			Actuate.tween(Background(layerBackground.getChildAt(0)).estrelas, 2, { rotation:r } ).onComplete(rotateBg).ease(Linear.easeNone); 
			//trace(r)
			
		}
		
		
		
		
		public function openValendoScreen():void {
			var valendoScreen:FeedBackScreen = new FeedBackScreen();
			valendoScreen.name = "valendo";
			valendoScreen.btOk.addEventListener(MouseEvent.CLICK, function(e:Event):void {
				mode = MODE_EVALUATE;
				changeState(STATE_RESET);
				ai.container.closeScreen(Sprite(ai.container.getChildByName("valendo")));
			});
			valendoScreen.btCancel.addEventListener(MouseEvent.CLICK, function(e:Event):void {
				ai.container.closeScreen(Sprite(ai.container.getChildByName("valendo")));
			});			
			valendoScreen.addEventListener(Event.CLOSE, function(e:Event):void {
				ai.container.removeChild(ai.container.getChildByName("valendo"));
			});
			ai.container.addChild(valendoScreen);
			ai.container.openScreen(valendoScreen)
		}
		

		public function openStatScreen():void {
			var stats:StatsScreen = new StatsScreen();
			stats.name = "stats";
			var eval:ProgressiveEvaluator = ProgressiveEvaluator(ai.evaluator);
			var nTotal:int = eval.numTrials;
			var nValendo:int = eval.numTrialsByMode(AIConstants.PLAYMODE_EVALUATE);
			var nNaoValendo:int = eval.numTrialsByMode(AIConstants.PLAYMODE_FREEPLAY);
			var scoreMin:int = eval.minimumScoreForAcceptance * 100;
			var scoreTotal:int = eval.scoreGeneralMean * 100;
			var scoreValendo:int = eval.score * 100;
			stats.valendoMC.gotoAndStop((mode == MODE_FREEPLAY?2:1));
			stats.nTotal.text = nTotal.toString();
			stats.nValendo.text = nValendo.toString();
			stats.nNaoValendo.text = nNaoValendo.toString();
			stats.valendoText.visible =  (mode==MODE_FREEPLAY)
			stats.scoreMin.text = scoreMin.toString();
			stats.scoreTotal.text = scoreTotal.toString();
			stats.scoreValendo.text = scoreValendo.toString();
			stats.closeButton.addEventListener(MouseEvent.CLICK, function(e:Event) {
				ai.container.closeScreen(Sprite(ai.container.getChildByName("stats")));
			});
			stats.addEventListener(Event.CLOSE, function(e:Event) {
				ai.container.removeChild(ai.container.getChildByName("stats"));
			});
			ai.container.addChild(stats);
			ai.container.openScreen(stats)
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
			scr.txPontuacao.text = Number(playInstance.getScore() * 100).toString() + "%";
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
			play.playMode= mode
			playInstance = play;
			
			var spr:Sprite = new Sprite();
			spr.name = "play";
			var planeta1:Planeta1 = new Planeta1();
			planeta1.name = "planeta1";
			ai.debugScreen.msg("Resposta esperada: " +  play.energy);
			var planeta2:Planeta2 = new Planeta2();
			planeta2.name = "planeta2";
			spr.addChild(planeta1);
			spr.addChild(planeta2);
			pos1 = new Point(rndBetween(200, 300), rndBetween(200, 400))
			pos2 = new Point(rndBetween(400, 550), rndBetween(200, 400))
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
			dist.txMantissa.text = "d = " + dist.txMantissa.text;
			dist.y = p.y;
			s.addChild(dist);
			var p1:Sprite = Sprite(Sprite(layerPlanetas.getChildByName("play")).getChildByName("planeta1"));
			var p2:Sprite = Sprite(Sprite(layerPlanetas.getChildByName("play")).getChildByName("planeta2"));
			var lb_p1:SciNotComponent = new SciNotComponent();
			lb_p1.setType(SciNotComponent.TYPE_VIEW);
			lb_p1.setTextColor(0xF8D307);
			lb_p1.setValue(playInstance.mass1.mantissa, playInstance.mass1.exponent);
			lb_p1.x = p1.x;
			lb_p1.y = p1.y + 30;
			lb_p1.txMantissa.text = "m=" + lb_p1.txMantissa.text;
			s.addChild(lb_p1);

			var lb_p2:SciNotComponent = new SciNotComponent();
			lb_p2.setType(SciNotComponent.TYPE_VIEW);
			lb_p2.setTextColor(0xF8D307);
			lb_p2.setValue(playInstance.mass2.mantissa, playInstance.mass2.exponent);			
			lb_p2.x = p2.x;
			lb_p2.y = p2.y + 30;
			lb_p2.txMantissa.text = "m=" + lb_p2.txMantissa.text;
			s.addChild(lb_p2);
			
			
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
			
			playInstance.answerMantissa = parseFloat(blocoControle.txEnergy.txMantissa.text.replace(",", "."));
			playInstance.answerExponent = parseFloat(blocoControle.txEnergy.txExponent.text.replace(",", "."));
			playInstance.evaluate();
			
			//trace("avaliou")
			
			ai.evaluator.addPlayInstance(playInstance);
			
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
			ai.container.disableComponent(ai.container.optionButtons.btTutorial)
			var t:Tutorial = new Tutorial();
			
			t.adicionarBalao('Digite aqui a energia potencial gravitacional', new Point(123,61), CaixaTexto.TOP, CaixaTexto.FIRST);
			t.adicionarBalao('Pressione \"Terminei\" para verificar sua resposta', new Point(92,90), CaixaTexto.TOP, CaixaTexto.FIRST);
			t.adicionarBalao('Pressione \"valendo nota\" quando achar que já está pronto(a) para ser avaliado(a).', new Point(223, 93), CaixaTexto.TOP, CaixaTexto.FIRST);
			t.iniciar(this.ai.container.stage);
			
			t.addEventListener(TutorialEvent.FIM_TUTORIAL, onTutorialEnd);

		}
		
		private function onTutorialEnd(e:TutorialEvent):void 
		{
			ai.container.stage.focus = blocoControle.txEnergy.txMantissa;
			ai.container.enableComponent(ai.container.optionButtons.btTutorial)
		}
		
		/* INTERFACE cepa.ai.AIObserver */
		
		public function onStatsClick():void 
		{
			openStatScreen();
		}
		
		/* INTERFACE cepa.ai.AIObserver */
		
		public function onScormConnected():void 
		{
			// passar pro evaluator
			ai.scorm.cmi.exit = CmiConstants.EXIT_SUSPEND;
			if (ai.scorm.cmi.entry == CmiConstants.ENTRY_ABINITIO) {
				ai.debugScreen.msg("ai.scorm.cmi.entry = ab-initio")				
				ai.scorm.performAutoSave = false;				
				ai.scorm.cmi.completion_status = CmiConstants.COMPLETION_STATUS_INCOMPLETE;
				ai.scorm.cmi.success_status = CmiConstants.SUCCESS_STATUS_FAILED;
				ai.scorm.cmi.progress_measure = 0;
				ai.scorm.cmi.score.min = 0;
				ai.scorm.cmi.score.max = 100;
				ai.scorm.cmi.exit = CmiConstants.EXIT_SUSPEND;
				ai.scorm.save();
				
			} 
			
			

		}
		
		public function onScormConnectionError():void 
		{
			
		}
		
		/* INTERFACE cepa.ai.AIInstance */
		
		public function getData():Object 
		{
			var obj:Object = new Object();
			obj.mode = mode;
			return obj;
		}
		
		public function readData(obj:Object) 
		{
			ai.debugScreen.msg("ativ:" + JSON.encode(obj))			
			mode = obj.mode;
			changeState(STATE_RESET);
		}
		
		/* INTERFACE cepa.ai.AIInstance */
		
		public function createNewPlayInstance():IPlayInstance 
		{
			var p:PlayInstance = new PlayInstance();
			return p;
		}
		
	
		
		
		
	}

}