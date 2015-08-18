package core.materials
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	
	import core.base.Surface3D;
	import core.shaders.DefaultShader;

	/**
	 *
	 * @author vanCopper
	 */
	public class DefaultMaterial extends Material3D
	{
		private static var _instance:DefaultMaterial;
		
		private var _texture:Texture;
		
		public function DefaultMaterial()
		{
			_shader = new DefaultShader()	
		}
		
		public static function get instance():DefaultMaterial
		{
			_instance ||= new DefaultMaterial();
			return _instance;
		}
		
		
		override protected function updateShader():void
		{
			if(_shader)
			{
				DefaultShader(_shader).defaultTexture = texture;
			}
			super.updateShader();
			//TODO:
		}
		
		override protected function updateTexture():void
		{
			super.updateTexture();
			
			createDefaultTexture();
//			App.context3D.setTextureAt(0, texture);
		}
		
		override public function draw(surface:Surface3D):void
		{
			super.draw(surface);
			//TODO:
			
			
		}
		
		private function createDefaultTexture():void
		{
			var bitmapData:BitmapData = new BitmapData(8, 8, false, 0x0);
			
			var i:uint, j:uint;
			for (i = 0; i < 8; i++) {
				for (j = 0; j < 8; j++) {
					if ((j & 1) ^ (i & 1))
						bitmapData.setPixel(i, j, 0XFFFFFF);
				}
			}
			
			_texture = App.context3D.createTexture(8, 8, Context3DTextureFormat.BGRA, false, 0);
			_texture.uploadFromBitmapData(bitmapData);
		}

		public function get texture():Texture
		{
			return _texture;
		}

		public function set texture(value:Texture):void
		{
			_texture = value;
		}

	}
}