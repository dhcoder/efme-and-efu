package efme.core.support 
{
	import flash.utils.Dictionary;
	/**
	 * The <code>Services</code> class implements the Service Locator pattern.
	 * Or, to put it another way, it acts as a home for classes which would
	 * otherwise be global singletons.
	 * 
	 * @see http://gameprogrammingpatterns.com/service-locator.html
	 * 
	 * @example
	 * <listing version="3.0">
	 * services.register(CollisionManager, new CollisionManager());
	 * services.register(Logger, new FileLogger()); // FileLogger extends Logger
	 * 
	 * var collisionManager:CollisionManager = 
	 *   services.locate(CollisionManager) as CollisionManager;
	 * </listing>
	 */
	public class Services
	{
		/**
		 * Services constructor.
		 */
		public function Services() 
		{
			_dictServices = new Dictionary();
		}
		
		/**
		 * Register a service. (A service is any object that you want global
		 * access to and which there should only be one instance of).
		 * 
		 * <p> You have to provide both the services' class, as well as an 
		 * instance of that class (or a class that derives from it). You later
		 * locate your service using the class type as a key.
		 * 
		 * <p> This allows you to register an interface, binding it with a
		 * particular implementation of that interface. For example, you can
		 * register an abstract Logger service, while passing in an instance of
		 * a FileLogger or a TraceLogger as you need.
		 * 
		 * <p> <strong>Note:</strong> If you make multiple register calls
		 * with the same <code>classType</code>, the last call to register
		 * will be the active service.
		 * 
		 * @param classType The type of class that this service is.
		 * @param obj An instance of the specified class.
		 */
		public function register(classType:Class, obj:Object):void
		{
			if (obj is classType)
			{
				_dictServices[classType] = obj;
			}
			else
			{
				throw new Error("Tried registering service of type " + obj + " which is not an instance of class type " + classType);
			}
		}
		
		/**
		 * Search for a registered service.
		 * 
		 * <p> <strong>Note:</strong> If no service was ever registered,
		 * this can return <code>null</code>.
		 * 
		 * @param classType The type of class that this service is.
		 * @return The requested service
		 */
		public function locate(classType:Class):Object
		{
			return _dictServices[classType];
		}
		
		private var _dictServices:Dictionary;
	}
}