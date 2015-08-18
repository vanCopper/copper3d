package core.shaders
{
	import flash.display3D.textures.Texture;
	
	import core.shaders.filters.DefaultFilter;

	/**
	 *
	 * @author vanCopper
	 */
	public class DefaultShader extends Shader3D
	{
		public var defaultTexture:Texture;
		private var _defaultFilter:DefaultFilter;
		public function DefaultShader()
		{
			super([], "DefaultShader");
			_defaultFilter = new DefaultFilter();
			addFilter(_defaultFilter);
		}
		
		override public function update():void
		{
			_defaultFilter.texture = defaultTexture;	
			super.update();
		}
	}
}