package core.shaders.utils
{
	import flash.display3D.textures.Texture;

	/**
	 * fs寄存器
	 * @author vanCopper
	 */
	public class FsRegister
	{
		public var fsElement:RegisterElement;
		public var texture:Texture;
		
		public function FsRegister(texture:Texture, fsReg:RegisterElement = null )
		{
			this.fsElement = fsReg;
			this.texture = texture;
		}
	}
}