package core.materials
{
	import flash.display.BlendMode;
	import flash.display3D.Context3DCompareMode;
	
	import core.shaders.LineShader;

	/**
	 *
	 * @author vanCopper
	 */
	public class LineMaterial extends Material3D
	{
		private static var _instance:LineMaterial;
		
		public function LineMaterial()
		{
			blendMode = BlendMode.ALPHA;
			_shader = new LineShader();
			depthWrite = false;
			depthCompare = Context3DCompareMode.ALWAYS;
		}
		
		public static function get instance():LineMaterial
		{
			_instance ||= new LineMaterial();
			return _instance;
		}
	}
}