package core.shaders
{
	import core.shaders.filters.LineFilter;

	/**
	 *
	 * @author vanCopper
	 */
	public class LineShader extends Shader3D
	{
		private var _lineFilter:LineFilter;
		
		public function LineShader()
		{
			super([],"LineShader");
			_lineFilter = new LineFilter();
			addFilter(_lineFilter);
		}
		
	}
}