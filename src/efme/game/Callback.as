package efme.game 
{
	/**
	 * A wrapper for callback functions. The constructor takes in any number
	 * of arguments you want to be passed in when the callback is called.
	 * 
	 * <p> Say you want to fire a callback when an animation finished. Well, one
	 * user wants that to call <code>funcNoArgs()</code>, while another
	 * user wants that to call <code>funcManyArgs(a, b, c)</code>. 
	 * Using the <code>Callback</code> class as a callback handler, rather
	 * than the <code>Function</code> class, provides that extra flexibility.
	 * 
	 * @example Using both types of callbacks
	 * <listing version="3.0">
	 * public function traceHelloWorld():void
	 * {
	 *   trace("Hello, World");
	 * }
	 * public function traceNumber(number:Number=7):void
	 * {
	 *   trace("Number:", number);
	 * }
	 * public function traceSum(number1:Number, number2:Number):void
	 * {
	 *   trace("Sum:", number1+number2);
	 * }
	 * 
	 * public function doCallbackTest():void
	 * {
	 *   var callback:Callback = new Callback(traceHelloWorld);
	 *   var callbackDefaultArg:Callback = new Callback(traceNumber);
	 *   var callback1Arg:Callback = new Callback(traceNumber, 42);
	 *   var callback2Args:Callback = new Callback(traceSum, 1, 1);
	 * 
	 *   callback.call();           => "Hello, World"
	 *   callbackDefaultArg.call(); => "Number: 7"
	 *   callback1Arg.call();       => "Number: 42"
	 *   callback2Args.call();      => "Sum: 2"
	 * }
	 * 
	 * </listing>
	 *
	 */
	public class Callback
	{
		public function Callback(callback:Function, ...args) 
		{
			_callback = callback;
			_args = args;
		}
		
		final public function call():void
		{
			_callback.apply(null, _args);
		}
		
		private var _callback:Function;
		private var _args:Array;
	}
}