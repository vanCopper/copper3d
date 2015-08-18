package core.shaders.utils
{
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;

	/**
	 * vc寄存器
	 * @author vanCopper
	 */
	public class VcRegister
	{
		public var vcElement:RegisterElement;
		public var num:uint;
		public var data:Object;
		
		public function VcRegister(data:Object, vcReg:RegisterElement = null)
		{
			this.vcElement = vcReg;
			this.data = data;
			if(this.data is Vector.<Number>)
			{
				num = Vector.<Number>(this.data).length/4;
			}else if(this.data is Matrix3D)
			{
				num = 1;
			}else if(this.data is ByteArray)
			{
				num = ByteArray(this.data).length/4/4;
			}
		}
	}
}