package core.entities.primitives
{
	import flash.display3D.Context3DVertexBufferFormat;
	
	import core.base.Surface3D;
	import core.entities.Mesh;
	import core.materials.LineMaterial;
	
	/**
	 *
	 * @author vanCopper
	 */
	public class LinesMesh extends Mesh
	{
		private var _thickness 	: Number = 1;
		private var _color 		: uint   = 0xFFFFFF;
		private var _alpha 		: Number = 1;
		private var _lx 		: Number = 0;
		private var _ly 		: Number = 0;
		private var _lz 		: Number = 0;
		private var _r 			: Number = 1;
		private var _g 			: Number = 1;
		private var _b 			: Number = 1;
		private var _surface 	: Surface3D;
		
		public function LinesMesh()
		{
			super([], LineMaterial.instance);
		}
		
		public function clear() : void
		{
			for each (var geo : Surface3D in surfaces)
			{
				geo.dispose();
			}
			this._lx = 0;
			this._ly = 0;
			this._lz = 0;
			this.surfaces  = new Vector.<Surface3D>();
			this._surface = null;
		}
		
		public function lineStyle(thickness : Number = 1, color : uint = 0xFFFFFF, alpha : Number = 1) : void 
		{
			this._alpha = alpha;
			this._color = color;
			this._thickness = thickness;
			this._r = (((color >> 16) & 0xFF) / 0xFF);
			this._g = (((color >> 8) & 0xFF) / 0xFF);
			this._b = ((color & 0xFF) / 0xFF);
		}
		
		public function moveTo(x : Number, y : Number, z : Number) : void 
		{
			this._lx = x;
			this._ly = y;
			this._lz = z;
		}
		
		public function lineTo(x : Number, y : Number, z : Number) : void 
		{
			var index : uint = 0;
			if (_surface) 
			{
				index = _surface.getVertexData(Surface3D.POSITION).length / 3;
			} else {
				index = 0;
			}
			if (this._surface == null || index >= (65536 - 6)) 
			{
				this._surface = new Surface3D();
				this._surface.setVertexData(Surface3D.POSITION, new Vector.<Number>(), Context3DVertexBufferFormat.FLOAT_3);
				this._surface.setVertexData(Surface3D.CUSTOM1,  new Vector.<Number>(), Context3DVertexBufferFormat.FLOAT_3);
				this._surface.setVertexData(Surface3D.CUSTOM2,  new Vector.<Number>(), Context3DVertexBufferFormat.FLOAT_2);
				this._surface.setVertexData(Surface3D.CUSTOM3,  new Vector.<Number>(), Context3DVertexBufferFormat.FLOAT_4);
				this._surface.vertexIndexes = new Vector.<uint>();
				this.surfaces.push(this._surface);
				index = 0;
			}
			
			this._surface.getVertexData(Surface3D.POSITION).push(
				_lx, _ly, _lz, x, y, z, _lx, _ly, _lz, x, y, z
			);
			this._surface.getVertexData(Surface3D.CUSTOM1).push(
				x, y, z, _lx, _ly, _lz, x, y, z, _lx, _ly, _lz
			);
			this._surface.getVertexData(Surface3D.CUSTOM2).push(
				_thickness, _thickness / 1877, -_thickness, _thickness / 1877, -_thickness, _thickness / 1877, _thickness, _thickness / 1877
			);
			this._surface.getVertexData(Surface3D.CUSTOM3).push(
				_r, _g, _b, _alpha, _r, _g, _b, _alpha, _r, _g, _b, _alpha, _r, _g, _b, _alpha
			);
			this._surface.vertexIndexes.push(index + 2, index + 1, index, index + 1, index + 2, index + 3);
			this._lx = x;
			this._ly = y;
			this._lz = z;
		}
	}
}