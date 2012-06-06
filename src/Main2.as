package  {
	import fl.controls.CheckBox;
	import fl.motion.ITween;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import pipwerks.SCORM;
	
	public class Main extends MovieClip{
		
		private const GRAV:Number = 6.67428;
		private const ERROR:Number = 0.5;
		
		private var distance:int;
		private var mass01:Planeta1;
		private var mass02:Planeta2;
		private var line:Sprite;
		
		private var check:CheckBox;
		
		private var tw01x:Tween;
		private var tw02x:Tween;
		private var tw01y:Tween;
		private var tw02y:Tween;
		
		private var dTextField:TextField;
		private var alertText:TextField;
		private var textFormat:TextFormat;
		private var textFormat2:TextFormat;
		
		private var userResp:*;
		private var progResp:*;
		
		private var limitsX:Array = [100, 450];
		private var limitsY:Array = [100, 260];
		private var massLimits:Array = [1, 9];
		
		/******* SCORM VARIABLES *******/
		private const PING_INTERVAL:Number = 5 * 60 * 1000; // 5 minutos
		private var numExercicies:int = 3; // número de exercicios que o aluno deve fazer
		private var completed:Boolean = false;
		private var scorm:SCORM;
		private var scormTimeTry:String;
		private var connected:Boolean;
		private var score:int;
		private var pingTimer:Timer;
		private var lastTimes:* = 0;//quantas vezes ele ja fez
		private var lastScore:* = 0;//pontuação anterior
		
		public function Main() {
			init();
			reset();
		}
		
		/**
		 * Restaura a CONFIGURAÇÃO inicial (padrão).
		 */
		public function reset ()
		{
		}
		
		//--------------------------------------------------
		// Membros privados.
		//--------------------------------------------------
		private const VIEWPORT:Rectangle = new Rectangle(0, 0, 550, 400);
		private var index:TextField;
		private var textFormat3:TextFormat;
		
		/**
		 * @private
		 * Inicialização (CRIAÇÃO DE OBJETOS) independente do palco (stage).
		 */
		private function init () : void
		{
			scrollRect = VIEWPORT;

			if (stage) stageDependentInit();
			else addEventListener(Event.ADDED_TO_STAGE, stageDependentInit);
			
		}
		
		/**
		 * @private
		 * Inicialização (CRIAÇÃO DE OBJETOS) dependente do palco (stage).
		 */
		private function stageDependentInit (event:Event = null) : void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, stageDependentInit);
			
			ok_BTN.addEventListener(MouseEvent.CLICK, compareResult);
			next_BTN.addEventListener(MouseEvent.CLICK, goToNext);
			
			userInput.selectable = false;
			next_BTN.visible = false;
			
			line = new Sprite()
			addChild(line);
			
			mass01 = new Planeta1();
			mass02 = new Planeta2();
			mass01.visible = mass02.visible = false;
			addChild(mass01);
			addChild(mass02);
			mass01.x = mass02.x = 100;
			mass01.y = mass02.y = 100;
			
			dTextField = new TextField();
			dTextField.background = true;
			dTextField.backgroundColor = 0xffffff;
			dTextField.autoSize = TextFieldAutoSize.CENTER;
			dTextField.selectable = false;
			dTextField.textColor = 0x000000;
			addChild(dTextField);
			
			textFormat = new TextFormat();
			textFormat.font = "Arial";
			textFormat.size = 14;
			
			alertText = new TextField();
			alertText.autoSize = TextFieldAutoSize.LEFT
			alertText.selectable = false;
			alertText.x = 25;
			alertText.y = 360;
			addChild(alertText);
			
			textFormat2 = new TextFormat();
			textFormat2.font = "Arial";
			textFormat2.size = 16;
			textFormat2.color = 0xfedd02;
			textFormat2.bold = true;
			alertText.defaultTextFormat = textFormat2;
			
			check = new CheckBox();
			check.label = ""
			check.move(525 - 100, 318.35);
			addChild(check);
			
			index = new TextField();
			index.autoSize = TextFieldAutoSize.LEFT
			index.selectable = false;
			index.x = check.x + 20;
			index.y = check.y+2;
			index.text = "(0/0)";
			addChild(index);
			
			textFormat3 = new TextFormat();
			textFormat3.font = "Arial";
			textFormat3.size = 10;
			textFormat3.color = 0xffffff;
			textFormat3.bold = true;
			index.defaultTextFormat = textFormat3;
			
			sortPositionsMass();
			
			initLMSConnection();
		}
		
		/**
		 * Sorteia as massas e a distancia das massas
		 */
		private function sortPositionsMass():void 
		{
			dTextField.visible = false;
			userInput.selectable = true;
			userInput.text = "";
			next_BTN.visible = false;
			alertText.text = "";
			ok_BTN.enabled = true;
			check.enabled = true;
			index.text = "valendo nota (" + lastTimes + "/" + numExercicies + ")";
			
			if (completed)
			{
				index.visible = false;
				check.visible = false;
				alertText.text = "Atividade completada.";
			}
			
			var aux_X1 = rand(limitsX[0], limitsX[1]);
			var aux_X2 = rand(limitsX[0], limitsX[1]);
			var aux_Y1 = rand(limitsY[0], limitsY[1]);
			var aux_Y2 = rand(limitsY[0], limitsY[1]);
			var aux_mass01 = rand(massLimits[0], massLimits[1]);
			var aux_mass02 = rand(massLimits[0], massLimits[1]);
			
			while (Math.abs(aux_X1 - aux_X2) < limitsX[0]+50)
			{
				aux_X1 = rand(limitsX[0], limitsX[1]);
				aux_X2 = rand(limitsX[0], limitsX[1]);
			}
			
			mass01.mass = aux_mass01;
			mass01.visible = true;
			tw01x = new Tween(mass01, "x", Regular.easeInOut, mass01.x, aux_X1, 3, true);
			tw01y = new Tween(mass01, "y", Regular.easeInOut, mass01.y, aux_Y1, 3, true);
			//mass01.x = aux_X1;
			//mass01.y = aux_Y1;

			mass02.mass = aux_mass02;
			mass02.visible = true;
			tw02x = new Tween(mass02, "x", Regular.easeInOut, mass02.x, aux_X2, 3, true);
			tw02y = new Tween(mass02, "y", Regular.easeInOut, mass02.y, aux_Y2, 3, true);
			tw02y.addEventListener(TweenEvent.MOTION_CHANGE, drawDistance);
			tw02y.addEventListener(TweenEvent.MOTION_FINISH, seeDistance);
			//mass02.x = aux_X2;
			//mass02.y = aux_Y2
			
			distance = Math.sqrt(Math.pow(aux_X1 - aux_X2, 2) + Math.pow(aux_Y1 - aux_Y2, 2));
			
			dTextField.htmlText = String(distance/100).replace(".", ",") + "x10^5 m";
			//dTextField.visible = false;
			
			if (aux_X1 > aux_X2)	dTextField.x = aux_X2 + (aux_X1 - aux_X2) / 2 - dTextField.width/2;
			else 	dTextField.x = aux_X1 + (aux_X2 - aux_X1) / 2 - dTextField.width/2;
			if (aux_Y1 > aux_Y2)	dTextField.y = aux_Y2 + (aux_Y1 - aux_Y2) / 2 - dTextField.height/2;
			else 	dTextField.y = aux_Y1 + (aux_Y2 - aux_Y1) / 2 - dTextField.height/2;;
			dTextField.setTextFormat(textFormat);
		}
		
		/**
		 * Função que calcula inteiros aleatórios entre 2 numeros
		 * @param	min
		 * @param	max
		 * @return  numero inteiro
		 */
		private function rand(min:Number, max:Number):Number {
			
			var aux;
			
			aux = Math.floor(Math.random() * (1+max-min)) + min;
			
			return aux;
		}
		
		/**
		 * Desenha a linha de distancia entre as massas
		 */
		private function drawDistance(e:Event = null):void 
		{
			line.graphics.clear();
			line.graphics.lineStyle(2, 0x444444, 1);
			line.graphics.moveTo(mass01.x, mass01.y);
			line.graphics.lineTo(mass02.x, mass02.y);
		}
		private function seeDistance(e:TweenEvent):void 
		{
			dTextField.visible = true;
		}
		
		/**
		 * Calcula o valor real da energia
		 */
		private function calculate():void
		{
			progResp = (GRAV * mass01.mass * mass02.mass) / (distance/100);
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function compareResult(e:MouseEvent):void 
		{
			
			if (userInput.text != "")
			{
				ok_BTN.enabled = false;
				check.enabled = false;
				userInput.selectable = false;
				calculate();
				userResp = Number((userInput.text).replace(",","."));
				if (userResp < progResp+ERROR && userResp > progResp-ERROR)
				{
					alertText.text = "Acertou.";
					if (!completed && check.selected)
					{
						lastTimes++;
						lastScore += 100 / numExercicies;
						if (lastTimes == numExercicies){ completed = true;}
						save2LMS();
					}
				}else {
					alertText.text = "Errou. A resposta correta seria: " + progResp.toFixed(1).replace(".", ",") + " Joules";
					if (!completed && check.selected)
					{
						lastTimes++;
						lastScore = lastScore;
						if (lastTimes == numExercicies){ completed = true;}
						save2LMS();
					}
				}
				next_BTN.visible = true;
				
			}else {
				alertText.text = "Não escreveu nada.";
			}
		}
		
		/**
		 * Vai para a próxima questão
		 * @param	e
		 */
		private function goToNext(e:MouseEvent):void
		{
			sortPositionsMass();
		}
		
		
		
		/*------------------------------SCORM----------------------------------------------------------------------------------------------------------------------
		/**
		 * @private
		 * Inicia a conexão com o LMS.
		 */
		private function initLMSConnection () : void
		{
			completed = false;
			connected = false;
			
			scorm = new SCORM();

			connected = scorm.connect();

			if (connected) {

				// Verifica se a AI já foi concluída.
				var status:String = scorm.get("cmi.completion_status");		
			 
				switch(status)
				{
					// Primeiro acesso à AI// Continuando a AI...
					case "not attempted":
					case "unknown":
					default:
						completed = false;
						scormTimeTry = "times=0,points=0";
						lastTimes = 0;
						lastScore = 0;
						score = 0;
						break;
					
					case "incomplete":
						completed = false;
						scormTimeTry = scorm.get("cmi.location");
						score = 0;
						break;
						
					// A AI já foi completada.
					case "completed"://Apartir desse momento os pontos nao serão mais acumulados
						completed = true;
						scormTimeTry = scorm.get("cmi.location");//Deve contar a quantidade de funções que ele fez e tambem média que ele tinha
						score = 0;
						break;
				}
				//Tratamento do scormTimeTry--------------------------------------------------------------------
				if (!completed)//Somente se a atividade nao estiver completa
				{
					var lista:Array = scormTimeTry.split(",");
					for(var i = 0; i < lista.length; i++)
					{
						if(i == 0)
						{
							lastTimes = Number(lista[i].substr(lista[i].search("=")+1));
						}else if(i == 1)
						{
							lastScore = Number(lista[i].substr(lista[i].search("=")+1));
						}
					}
					index.text = "valendo nota (" + lastTimes.toString() + "/" + numExercicies.toString() + ")";
				}
				//----------------------------------------------------------------------------------------------
				var success:Boolean = scorm.set("cmi.score.min", "0");
				if (success) success = scorm.set("cmi.score.max", "100");
				
				if (success)
				{
					scorm.save();
					pingTimer.start();
				}
				else
				{
					connected = false;
				}
			}
		}
		
		/**
		 * @private
		 * Salva cmi.score.raw, cmi.location e cmi.completion_status no LMS
		 */ 
		private function save2LMS ()
		{
			if (connected)
			{
				// Salva no LMS a nota do aluno.
				var success:Boolean = scorm.set("cmi.score.raw", (lastScore).toString());

				// Notifica o LMS que esta atividade foi concluída.
				success = scorm.set("cmi.completion_status", (completed ? "completed" : "incomplete"));

				// Salva no LMS o exercício que deve ser exibido quando a AI for acessada novamente.
				scormTimeTry = "times=" + lastTimes + ",points=" + lastScore;
				success = scorm.set("cmi.location", scormTimeTry);

				if (success)
				{
					scorm.save();
				}
				else
				{
					pingTimer.stop();
					connected = false;
				}
			}
		}
		
		/**
		 * @private
		 * Mantém a conexão com LMS ativa, atualizando a variável cmi.session_time
		 */
		private function pingLMS (event:TimerEvent)
		{
			scorm.get("cmi.completion_status");
		}
	}
}