package core.shaders.utils
{
	/**
	 *
	 * @author vanCopper
	 */
	public class RegisterPool
	{
		private var _regVec:Vector.<RegisterElement>;
		private var _regName:String;
		public function RegisterPool(regName:String, regCount:uint)
		{
			_regVec = new Vector.<RegisterElement>(regCount);
			_regName = regName;
			
			for(var i:int = 0; i < _regVec.length; i++)
			{
				_regVec[i] = new RegisterElement(regName, i);
			}
		}
		
		public function requestReg():RegisterElement
		{
			if(!_regVec)return null;
			if(_regVec.length == 0)
			{
				throw new Error("申请寄存器："+_regName+"超最大数量");
			}
			
			return _regVec.shift();
		}
		
		public function freeReg(regElement:RegisterElement):void
		{
			if(_regVec)
			{
				_regVec.push(regElement);
			}
		}
		
		public function dispose():void
		{
			_regVec = null;
		}
	}
}