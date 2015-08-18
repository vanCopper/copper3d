/**
* GitHub: http://github.com/vanCopper/copper3d
* Blog: http://tgerm.org
*/

package core.base
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;

	/**
	 * 网格基类
	 * @author vancopper
	 */
	public class Surface3D
	{
		/**
		 * 顶点 
		 */		
		public static const POSITION:int = 0;	
		
		/**
		 * 默认uv 
		 */		
		public static const UV0:int = 1;
		
		/**
		 * uv1 
		 */		
		public static const UV1:int = 2;
		
		/**
		 * 法线 
		 */		
		public static const NORMAL:int = 3;
		
		/**
		 * 自定义数据 
		 */		
		public static const CUSTOM1:int = 4;
		public static const CUSTOM2:int = 5;
		public static const CUSTOM3:int = 6;
		public static const CUSTOM4:int = 7;
		
		
		public static const DATA_SIZE:int = 8;
		
		
		private var _vertexData:Vector.<Vector.<Number>>;	//顶点数据
		private var _vertexFormat:Vector.<String>;			//顶点数据格式
		private var _vertexIndexes:Vector.<uint>;			//顶点索引
		
		private var _vertexBuffers:Vector.<VertexBuffer3D>; //顶点Buffer
		private var _indexBuffer:IndexBuffer3D;				//索引Buffer
		
		private var _oldContext3D:Context3D;
		
		public function Surface3D()
		{
			//TODO:
			_vertexData = new Vector.<Vector.<Number>>(DATA_SIZE, true);
			_vertexFormat = new Vector.<String>(DATA_SIZE, true);
			_vertexBuffers = new Vector.<VertexBuffer3D>(DATA_SIZE, true);
		}
		
		/**
		 * 设置顶点数据 
		 * @param index 
		 * <ul>
		 * <li>Surface3D.POSTION 顶点位置</li>
		 * <li>Surface3D.UV0 默认uv</li>
		 * <li>具体参照 Surface3D 类</li>
		 * </ul>
		 * @param data
		 * @param format
		 * <ul>
		 * <li>参照 Context3DVertexBufferFormat 常量</li>
		 * </ul>
		 * 
		 */		
		public function setVertexData(index:uint, data:Vector.<Number>, format:String):void
		{
			if(index >= DATA_SIZE) return;
			
			_vertexData[index] = data;
			_vertexFormat[index] = format;
		}
		
		public function getVertexData(index:uint):Vector.<Number>
		{
			if(index >= DATA_SIZE) return null;
			
			return _vertexData[index];
		}
		
		public function set vertexIndexes(value:Vector.<uint>):void
		{
			_vertexIndexes = value;
		}
		
		public function get vertexIndexes():Vector.<uint>
		{
			return _vertexIndexes;
		}
		
		public function get indexBuffer():IndexBuffer3D
		{
			return _indexBuffer;
		}
		
		public function get vertexBuffers():Vector.<VertexBuffer3D>
		{
			return _vertexBuffers;
		}
		
		public function get vertexFormat():Vector.<String>
		{
			return _vertexFormat;
		}
		
		public function update():void
		{
			//TODO:
			if(_oldContext3D == App.context3D)
			{
				return;
			}
			
			//上传顶点数据
			updateVertexBuffer();
			//上传索引数据
			updateIndexBuffer();
			
			_oldContext3D = App.context3D;
		}
//		
//		public function draw():void
//		{
//			for(var i:int = 0; i < _vertexBuffers.length; i++)
//			{
//				if(_vertexBuffers[i])
//				{
//					App.context3D.setVertexBufferAt(i, _vertexBuffers[i], 0, _vertexFormat[i]);
//				}
//			}
//			
//			App.context3D.drawTriangles(_indexBuffer);
//		}
//		
		public function dispose():void
		{
			//TODO:	
		}
		
		private function updateVertexBuffer():void
		{
			for (var i:int = 0; i < _vertexData.length; i++) 
			{
				if(_vertexBuffers[i])
				{
					_vertexBuffers[i].dispose();
					_vertexBuffers[i] = null;
				}
				
				if(_vertexData[i])
				{
					var size:uint = getSizeByFormat(_vertexFormat[i]);
					var numVertices:uint = _vertexData[i].length/size;
					_vertexBuffers[i] = App.context3D.createVertexBuffer(numVertices, size); 
					_vertexBuffers[i].uploadFromVector(_vertexData[i], 0, numVertices);
				}
			}
			
		}
		
		private function updateIndexBuffer():void
		{
			if(_indexBuffer)
			{
				_indexBuffer.dispose();
				_indexBuffer = null;
			}
			
			_indexBuffer = App.context3D.createIndexBuffer(_vertexIndexes.length);
			_indexBuffer.uploadFromVector(_vertexIndexes, 0, _vertexIndexes.length);
		}
	
		private static function getSizeByFormat(format:String):uint
		{
			switch(format)
			{
				case Context3DVertexBufferFormat.FLOAT_1:
					return 1;			
					break;
				case Context3DVertexBufferFormat.FLOAT_2:
					return 2;
					break;
				case Context3DVertexBufferFormat.FLOAT_3:
					return 3;
					break;
				case Context3DVertexBufferFormat.FLOAT_4:
					return 4;
					break;
				default:
					return 4;
					break;
				
			}
		}
	}
}