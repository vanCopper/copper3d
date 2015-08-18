package core.shaders.filters
{
	import flash.display3D.textures.Texture;
	
	import core.base.Surface3D;
	import core.shaders.utils.FsRegister;
	import core.shaders.utils.NewLine;
	import core.shaders.utils.OpCode;
	import core.shaders.utils.RegisterElement;
	import core.shaders.utils.RegisterManager;

	/**
	 *
	 * @author vanCopper
	 */
	public class DefaultFilter extends Filter3D
	{
		public var texture:Texture;
		public function DefaultFilter(filterName:String="filter3d")
		{
			super(filterName);
		}
		
		override public function getFragmentCode(regManager:RegisterManager):String
		{
			var fs0:RegisterElement = regManager.getFs(new FsRegister(texture));
			var code:String = OpCode.TEX + regManager.oc + ", " + regManager.getVByIndex(Surface3D.UV0) + ", " + fs0 + " <2d, repeat, nearest, nomip>" + NewLine;
			return code;
		}
		
	}
}