package
{
	import flash.display3D.Context3DProfile;

	/**
	 * 
	 * @author vancopper
	 * 
	 */	
	public class App
	{
		public function App()
		{
		}
		
		public static var profileDefault:String = Context3DProfile.BASELINE;
		
		
		public static const VIEW_PORT_MAX:Number = 2048;
		public static const VIEW_PORT_MIN:Number = 50;
		public static const enableErrorChecking:Boolean = true;
	}
}