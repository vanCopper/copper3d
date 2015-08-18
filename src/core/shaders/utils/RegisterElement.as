package core.shaders.utils
{
	/**
	 * 寄存器
	 * @author vanCopper
	 */
	public class RegisterElement
	{
		/**
		 * 寄存器名称 
		 */		
		private var _regName:String;
		/**
		 * 寄存器索引 
		 */		
		private var _regIndex:uint;
		/**
		 * 寄存器 
		 */		
		private var _reg:String;
		/**
		 * 
		 * @param regName
		 * @param index
		 * 
		 */		
		public function RegisterElement(regName:String, regIndex:uint)
		{
			_regName = regName;
			_regIndex = regIndex;
			_reg = _regName + _regIndex;
		}
		
		public function get regIndex():uint
		{
			return _regIndex;
		}
		
		public function get regName():String
		{
			return _regName;
		}
		
		public function get reg():String
		{
			return _reg;
		}
		
		public function toString():String
		{
			return _reg;
		}
	}
}