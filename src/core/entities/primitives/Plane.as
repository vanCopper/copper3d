package core.entities.primitives
{
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import core.base.Surface3D;
	import core.entities.Mesh;
	
	import utils.Matrix3DUtils;
	
	/**
	 *
	 * @author vanCopper
	 */
	public class Plane extends Mesh
	{
		private var _width:Number;
		private var _height:Number;
		private var _segment:uint;
		private var _axis:String;
		public function Plane(width:Number = 10, height:Number = 10, segment:uint = 1, axis:String = "+xy")
		{
			super([new Surface3D()]);
			_width = width;
			_height = height;
			_segment = segment;
			_axis = axis;
			build();
		}
		
		private function build():void
		{
			var vertexes:Vector.<Number> = new Vector.<Number>();
			var uvs:Vector.<Number> = new Vector.<Number>();
			var normals:Vector.<Number> = new Vector.<Number>();
			var indices:Vector.<uint> = new Vector.<uint>();
			
			
			var matrix : Matrix3D = new Matrix3D();
			if (axis == "+xy") {
				Matrix3DUtils.setOrientation(matrix, new Vector3D(0, 0, -1));
			} else if (axis == "-xy") {
				Matrix3DUtils.setOrientation(matrix, new Vector3D(0, 0, 1));
			} else if (axis == "+xz") {
				Matrix3DUtils.setOrientation(matrix, new Vector3D(0, 1, 0));
			} else if (axis == "-xz") {
				Matrix3DUtils.setOrientation(matrix, new Vector3D(0, -1, 0));
			} else if (axis == "+yz") {
				Matrix3DUtils.setOrientation(matrix, new Vector3D(1, 0, 0));
			} else if (axis == "-yz") {
				Matrix3DUtils.setOrientation(matrix, new Vector3D(-1, 0, 0));
			} else {
				Matrix3DUtils.setOrientation(matrix, new Vector3D(0, 0, -1));
			}
			Matrix3DUtils.setScale(matrix, width, height, 1);
			var raw      : Vector.<Number> = matrix.rawData;
			var normal   : Vector3D  = Matrix3DUtils.getDir(matrix);
			
			var i : int = 0;
			var u : Number = 0;
			var v : Number = 0;
			var x : Number = 0;
			var y : Number = 0;
			var max : Number = 0;
			var hwidth : Number = 0;
			var hheight : Number = 0;
			
			while (v <= segment) {
				u = 0;
				while (u <= segment) {
					x = (u / segment) - 0.5;
					y = (v / segment) - 0.5;
					vertexes.push(
						(x * raw[0] + y * raw[4] + raw[12]), 
						(x * raw[1] + y * raw[5] + raw[13]), 
						(x * raw[2] + y * raw[6] + raw[14])
					);
					normals.push(normal.x, normal.y, normal.z);
					uvs.push(1 - u / segment, 1 - v / segment);
					i++;
					u++;
				}
				v++;
			}
			i = 0;
			v = 0;
			while (v < segment) {
				u = 0;
				while (u < segment) {
					indices[i++] = u + 1 + v * (segment + 1);
					indices[i++] = u + 1 + (v + 1) * (segment + 1);
					indices[i++] = u + (v + 1) * (segment + 1);
					indices[i++] = u + v * (segment + 1);
					indices[i++] = u + 1 + v * (segment + 1);
					indices[i++] = u + (v + 1) * (segment + 1);
					u++;
				}
				v++;
			}
			
			surfaces[0].setVertexData(Surface3D.POSITION, vertexes, Context3DVertexBufferFormat.FLOAT_3);
			surfaces[0].setVertexData(Surface3D.UV0, uvs, Context3DVertexBufferFormat.FLOAT_2);
			surfaces[0].setVertexData(Surface3D.NORMAL, normals, Context3DVertexBufferFormat.FLOAT_3);
			surfaces[0].vertexIndexes = indices;
			
		}

		public function get width():Number
		{
			return _width;
		}

		public function get height():Number
		{
			return _height;
		}

		public function get segment():uint
		{
			return _segment;
		}

		public function get axis():String
		{
			return _axis;
		}


	}
}