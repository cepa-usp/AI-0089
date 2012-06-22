package tests 
{
	import cepa.ai.AI;
	import cepa.ai.AIInstance;
	import cepa.ai.IPlayInstance;
	import cepa.eval.ProgressiveEvaluator;
	import com.adobe.serialization.json.JSON;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Arthur
	 */
	public class TestPlayEval extends Sprite implements AIInstance
	{
		
		
		
		public function TestPlayEval() 
		{
			var p:PlayInstance = new PlayInstance();
			var ai:AI = new AI(this);
			var evaluator:ProgressiveEvaluator = new ProgressiveEvaluator(ai);
			ai.evaluator = evaluator;
			
			
			var saida:String = "{\"eval\":{\"0\":{\"mass1\":{\"mant\":9.25,\"exponent\":25},\"mode\":\"EVAL\",\"E\":{\"mant\":-1.2397161214953272,\"exponent\":33},\"answer\":{\"mantissa\":-1.23,\"exponent\":33},\"mass2\":{\"mant\":2.15,\"exponent\":25},\"score\":1,\"obs\":null,\"distance\":{\"mant\":1.07,\"exponent\":8}},\"1\":{\"mass1\":{\"mant\":8.99,\"exponent\":23},\"mode\":\"EVAL\",\"E\":{\"mant\":-1.8345914404761896,\"exponent\":36},\"answer\":{\"mantissa\":-1.83,\"exponent\":36},\"mass2\":{\"mant\":5.14,\"exponent\":31},\"score\":1,\"obs\":null,\"distance\":{\"mant\":1.6800000000000002,\"exponent\":9}},\"3\":{\"mass1\":{\"mant\":5.46,\"exponent\":26},\"mode\":\"EVAL\",\"E\":{\"mant\":-1.5843567371601206,\"exponent\":34},\"answer\":{\"mantissa\":-1.58,\"exponent\":34},\"mass2\":{\"mant\":1.4400000000000002,\"exponent\":27},\"score\":1,\"obs\":null,\"distance\":{\"mant\":3.31,\"exponent\":9}},\"4\":{\"mass1\":{\"mant\":8.24,\"exponent\":26},\"mode\":\"EVAL\",\"E\":{\"mant\":-1.8621047164179108,\"exponent\":34},\"answer\":{\"mantissa\":3,\"exponent\":3},\"mass2\":{\"mant\":2.27,\"exponent\":25},\"score\":0,\"obs\":null,\"distance\":{\"mant\":6.7,\"exponent\":7}},\"2\":{\"mass1\":{\"mant\":1.22,\"exponent\":28},\"mode\":\"EVAL\",\"E\":{\"mant\":-7.2956,\"exponent\":35},\"answer\":{\"mantissa\":-7.29,\"exponent\":35},\"mass2\":{\"mant\":4.42,\"exponent\":27},\"score\":1,\"obs\":null,\"distance\":{\"mant\":4.93,\"exponent\":9}},\"length\":5},\"general\":{\"mode\":1}}"
			var obj:Object = JSON.decode(saida);
			

			evaluator.readData(obj.eval);
			
			trace(evaluator.score);
			
			
			trace(saida)
		}
		
		/* INTERFACE cepa.ai.AIInstance */
		
		public function getData():Object 
		{
			return 0;
		}
		
		public function readData(obj:Object) 
		{
			
		}
		
		public function createNewPlayInstance():IPlayInstance 
		{
			var p:PlayInstance = new PlayInstance();
			return p;
		}
		
		
	}

}