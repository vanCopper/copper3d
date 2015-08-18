/**
* GitHub: http://github.com/vanCopper/copper3d
* Blog: http://tgerm.org
*/

package core.shaders
{
	import com.adobe.utils.extended.AGALMiniAssembler;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;
	
	import core.base.Surface3D;
	import core.shaders.filters.Filter3D;
	import core.shaders.utils.FcRegister;
	import core.shaders.utils.FsRegister;
	import core.shaders.utils.NewLine;
	import core.shaders.utils.OpCode;
	import core.shaders.utils.RegisterElement;
	import core.shaders.utils.RegisterManager;
	import core.shaders.utils.VcRegister;

	/**
	 * shader 
	 * @author vancopper
	 */
	public class Shader3D
	{

		private var _program3d:Program3D;
		private var _regManager:RegisterManager;
		private var _filters:Vector.<Filter3D>;
		private var _programDirty:Boolean;			//是否需要更新program3d
		private var _oldContext3D:Context3D;		//当前使用的Context3d
		
		private var _vertexCode:String;
		private var _fragmentCode:String;
		
		protected static var agalMiniAssembler:AGALMiniAssembler = new AGALMiniAssembler();
		
		public var name:String;
		
		public function Shader3D(filters:Array, name:String = "Shader3D")
		{
			_filters = new Vector.<Filter3D>(filters);
			_programDirty = true;
			_regManager = new RegisterManager();
			this.name = name;
		}
		
		public function addFilter(filter:Filter3D):void
		{
			if(_filters.indexOf(filter) == -1)
			{
				_filters.push(filter);
				_programDirty = true;
			}
		}
		
		public function removeFilter(filter:Filter3D):void
		{
			var index:int = _filters.indexOf(filter);
			if(index != -1)
			{
				_filters.splice(index, 1);
			}
		}
		
		public function getFilterByName(filterName:String):Filter3D
		{
			var sfilter:Filter3D;
			for(var i:int = 0; i < _filters.length; i++)
			{
				sfilter = _filters[i];
				if(sfilter.name == filterName)
				{
					break;
				}
			}
			return sfilter;
		}
		
		public function get filters():Vector.<Filter3D>
		{
			return _filters;
		}

		
		public function update():void
		{
			// 更新filter 设置寄存器数据等
			for(var i:int = 0; i < _filters.length; i++)
			{
				_filters[i].update(_regManager);
			}
			//是否需要重新创建 Program3D
			if(_oldContext3D != App.context3D || _programDirty)
			{
				buildProgram();
				_oldContext3D = App.context3D;
			}
			
		}
		
		public function draw(surface:Surface3D):void
		{
			setContextData(surface);
			App.context3D.drawTriangles(surface.indexBuffer);
			clear();
		}
		
		protected function setContextData(surface:Surface3D):void
		{
			// va 
			for(var i:int = 0; i < _regManager.vas.length; i++)
			{
				var va:RegisterElement = _regManager.vas[i];
				if(va)
				{
					App.context3D.setVertexBufferAt(va.regIndex, surface.vertexBuffers[i], 0, surface.vertexFormat[i]);
				}
			}
			
			// 上传vc数据
			var vcReg:VcRegister;
			for each(vcReg in _regManager.vcUsed)
			{
				if(vcReg.data is Vector.<Number>)
				{
					App.context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, vcReg.vcElement.regIndex, vcReg.data as Vector.<Number>, vcReg.num);
				}else if( vcReg.data is Matrix3D)
				{
					App.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, vcReg.vcElement.regIndex, vcReg.data as Matrix3D, vcReg.num);
				}else 
				{
					App.context3D.setProgramConstantsFromByteArray(Context3DProgramType.VERTEX, vcReg.vcElement.regIndex, vcReg.num, vcReg.data as ByteArray, 0);
				}
			}
			// 上传fc数据
			var fcReg:FcRegister;
			for each(fcReg in _regManager.fcUsed)
			{
				if(fcReg.data is Vector.<Number>)
				{
					App.context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, fcReg.fcElement.regIndex, fcReg.data as Vector.<Number>, fcReg.num);
				}else if(fcReg.data is Matrix3D)
				{
					App.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, fcReg.fcElement.regIndex, fcReg.data as Matrix3D, fcReg.num);
				}else
				{
					App.context3D.setProgramConstantsFromByteArray(Context3DProgramType.VERTEX, fcReg.fcElement.regIndex, fcReg.num, fcReg.data as ByteArray, 0);
				}
			}
			// 设置fs
			var fsReg:FsRegister
			for each(fsReg in _regManager.fsUsed)
			{
				App.context3D.setTextureAt(fsReg.fsElement.regIndex, fsReg.texture);
			}
			App.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, App.mvp, true);
			App.context3D.setProgram(_program3d);
		}
		
		/**
		 * clear context3d 数据 
		 * 
		 */		
		public function clear():void
		{
			//TODO:
			for each (var va : RegisterElement in _regManager.vas)
			{
				if (va) 
				{
					App.context3D.setVertexBufferAt(va.regIndex, null);
				}
			}
			for each (var fs : FsRegister in _regManager.fsUsed) 
			{
				App.context3D.setTextureAt(fs.fsElement.regIndex, null);
			}
		}
		
		protected function buildProgram():void
		{
			buildFragmentAgal();
			buildVertexAgal()
			
			if(App.DEBUG)
			{
				trace("---------构建Program3D:"+ name +"----------");
				trace("------------顶点程序--------------")
				trace(_vertexCode);
				trace("------------片段程序--------------");
				trace(_fragmentCode);
				trace("------------完成构建-----------------");
			}
			
			_program3d = agalMiniAssembler.assemble2(App.context3D, 2, _vertexCode, _fragmentCode);
			_programDirty = false;
		}
		
		protected function buildVertexAgal():void
		{
			// 将顶点移至 临时op
			_vertexCode = OpCode.MOV + _regManager.op + ", " + _regManager.getVaByIndex(Surface3D.POSITION) + NewLine;
			// 对v寄存器进行赋值， vs中是所有在片段寄存器中使用到的v寄存器 vs的索引即是Surface3D对应的数据类型
			for(var i:int = 0; i < _regManager.vs.length; i++)
			{
				if(_regManager.vs[i])
				{
					_vertexCode += OpCode.MOV + _regManager.getVByIndex(i) + ", " + _regManager.getVaByIndex(i) + NewLine;
				}
			}
			
			//TODO:
			//转换法线
			
			//拼接filter
			for each(var filter:Filter3D in filters)
			{
				_vertexCode += filter.getVertexCode(_regManager);
			}
			//输出
			
			_vertexCode += OpCode.M44 + "op, " + _regManager.op + ", " + _regManager.vcMVP + NewLine;
		}
		
		protected function buildFragmentAgal():void
		{
			//初始化 oc
			_fragmentCode = OpCode.MOV + _regManager.oc + ", " + _regManager.fcCache + ".yyyy \n";
			
			//TODO:
			// 拼接filter
			for each(var filter:Filter3D in filters)
			{
				_fragmentCode += filter.getFragmentCode(_regManager);
			}
			// 是否需要法线
			
			//输出
			_fragmentCode += OpCode.MOV + "oc, " + _regManager.oc + NewLine;
		}
		
	}
}