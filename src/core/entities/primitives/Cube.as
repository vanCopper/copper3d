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
	public class Cube extends Mesh
	{
		private var _width:Number;
		private var _height:Number;
		private var _depth:Number;
		private var _segments:uint;
		public function Cube(width:Number = 10, height:Number = 10, depth:Number = 10, segments:uint = 1)
		{
			super([new Surface3D()]);
			_width = width;
			_height = height;
			_depth = depth;
			_segments = segments;
			build();
		}
		
		private function build():void
		{
			surfaces[0].setVertexData(Surface3D.POSITION, new Vector.<Number>(), Context3DVertexBufferFormat.FLOAT_3);
			surfaces[0].setVertexData(Surface3D.UV0, new Vector.<Number>(), Context3DVertexBufferFormat.FLOAT_2);
			surfaces[0].setVertexData(Surface3D.NORMAL, new Vector.<Number>(), Context3DVertexBufferFormat.FLOAT_3);
			surfaces[0].vertexIndexes = new Vector.<uint>();
			
			createPlane(width, height, (depth * 0.5), segments, "+xy");
			createPlane(width, height, (depth * 0.5), segments, "-xy");
			createPlane(depth, height, (width * 0.5), segments, "+yz");
			createPlane(depth, height, (width * 0.5), segments, "-yz");
			createPlane(width, depth, (height * 0.5), segments, "+xz");
			createPlane(width, depth, (height * 0.5), segments, "-xz");
		}
		
		private function createPlane(width : Number, height : Number, depth : Number, segments : int, axis : String) : void {
			
			var surf : Surface3D = surfaces[0];
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
			}
			
			Matrix3DUtils.setScale(matrix, width, height, 1);
			Matrix3DUtils.translateZ(matrix, depth);
			
			var vertexs : Vector.<Number> = surf.getVertexData(Surface3D.POSITION);
			var normals : Vector.<Number> = surf.getVertexData(Surface3D.NORMAL);
			var uvs     : Vector.<Number> = surf.getVertexData(Surface3D.UV0);
			var raw 	: Vector.<Number> = matrix.rawData;
			var normal 	: Vector3D = Matrix3DUtils.getDir(matrix);
			var i : int = 0;
			var e : int = 0;
			var u : Number = 0;
			var v : Number = 0;
			var x : Number = 0;
			var y : Number = 0;
			i = vertexs.length / 3;
			e = i;
			v = 0;
			while (v <= segments) {
				u = 0;
				while (u <= segments) {
					x = (u / segments) - 0.5;
					y = (v / segments) - 0.5;
					vertexs.push((x * raw[0]) + (y * raw[4]) + raw[12], (x * raw[1]) + (y * raw[5]) + raw[13], (x * raw[2]) + (y * raw[6]) + raw[14]);
					normals.push(normal.x, normal.y, normal.z);
					uvs.push(1 - (u /segments), 1 - (v / segments));
					i++;
					u++;
				}
				v++;
			}
			i = surf.vertexIndexes.length;
			v = 0;
			while (v < segments) {
				u = 0;
				while (u < segments) {
					surf.vertexIndexes[i++] = u + 1 + v * (segments + 1) + e;
					surf.vertexIndexes[i++] = u + 1 + (v + 1) * (segments + 1) + e;
					surf.vertexIndexes[i++] = u + (v + 1) * (segments + 1) + e;
					surf.vertexIndexes[i++] = u + v * (segments + 1) + e;
					surf.vertexIndexes[i++] = u + 1 + v * (segments + 1) + e;
					surf.vertexIndexes[i++] = u + (v + 1) * (segments + 1) + e;
					u++;
				}
				v++;
			}
			
		}
		
		public function get width():Number
		{
			return _width;
		}
		
		public function get height():Number
		{
			return _height;
		}
		
		public function get segments():uint
		{
			return _segments;
		}
		
		public function get depth():Number
		{
			return _depth;
		}
	}
}