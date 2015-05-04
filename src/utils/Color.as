package utils
{
	import flash.geom.Vector3D;

	/**
	 *  
	 * @author vancopper
	 * 
	 */	
	public class Color
	{
		private var _color:uint;
		private var _rgba:Vector3D;
		
		public function Color(color:uint = 0xFFFFFFFF)
		{
			_rgba = new Vector3D();
			this.color = color;
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			_color = value;
			_rgba.x = ((_color >> 24) & 0xFF) / 255;
			_rgba.y = ((_color >> 16) & 0xFF) / 255;
			_rgba.z = ((_color >> 8) & 0xFF) / 255;
			_rgba.w = (_color & 0xFF) / 255;
		}
		
		public function get r():Number
		{
			return _rgba.x;
		}
		
		public function get g():Number
		{
			return _rgba.y;
		}
		
		public function get b():Number
		{
			return _rgba.z;
		}
		
		public function get a():Number
		{
			return _rgba.w;
		}
	}
}