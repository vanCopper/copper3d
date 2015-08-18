package core.shaders.filters
{
	import flash.geom.Matrix3D;
	
	import core.base.Surface3D;
	import core.shaders.utils.RegisterElement;
	import core.shaders.utils.RegisterManager;
	import core.shaders.utils.VcRegister;

	/**
	 *
	 * @author vanCopper
	 */
	public class LineFilter extends Filter3D
	{
		private var invMvMt : Matrix3D;
		private var mvMt    : Matrix3D;
		private var color	: RegisterElement;
		
		public function LineFilter()
		{
			super("LineFilter");
			invMvMt = new Matrix3D();
			mvMt = new Matrix3D();
		}
		
		override public function update(regManager:RegisterManager):void
		{
			mvMt.copyFrom(App.world);
			mvMt.append(App.view);
			invMvMt.copyFrom(mvMt);
			invMvMt.invert();
		}
		
		override public function getFragmentCode(regCache:RegisterManager):String 
		{
			this.color = regCache.getV();
			var code : String = "mov " + regCache.oc + ", " + color + " \n";
			return code;
		}
		
		override public function getVertexCode(regCache:RegisterManager):String
		{
			
			var vc1 : RegisterElement = regCache.getVc(4, new VcRegister(mvMt));
			var vc0 : RegisterElement = regCache.getVc(1, new VcRegister(Vector.<Number>([1, 0, 0, 0])));
			var vc5 : RegisterElement = regCache.getVc(1, new VcRegister(Vector.<Number>([1, 1, 1, 1])));
			var vc7 : RegisterElement = regCache.getVc(4, new VcRegister(invMvMt));
			
			var vt0 : RegisterElement = regCache.getVt();
			var vt1 : RegisterElement = regCache.getVt();
			var vt2 : RegisterElement = regCache.getVt();
			var vt3 : RegisterElement = regCache.getVt();
			var vt4 : RegisterElement = regCache.getVt();
			var vt5 : RegisterElement = regCache.getVt();
			
			var code : String = '';
			
				code += 'm44 ' + vt0 + ", " + regCache.getVaByIndex(Surface3D.POSITION) + ', ' + vc1 + '.xyzw \n';
				code += 'm44 ' + vt1 + ', ' + regCache.getVaByIndex(Surface3D.CUSTOM1) + ', ' + vc1 + '.xyzw \n';
				code += 'sub ' + vt2 + ', ' + vt1 + ', ' + vt0 + ' \n';
				code += 'slt ' + vt3 + ', ' + vt0 + '.zzzz, ' + vc5 + '.xxxx \n';
				code += 'sub ' + vt3 + '.y, ' + vc0 + '.xxxx, ' + vt3 + '.xxxx \n';
				code += 'sub ' + vt3 + '.z, ' + vt0 + '.xxzz, ' + vc5 + '.xxxx \n';
				code += 'sub ' + vt3 + '.w, ' + vt0 + '.xxxz, ' + vt1 + '.xxxz \n';
				code += 'div ' + vt4 + ', ' + vt3 + '.zzzz, ' + vt3 + '.www \n';
				code += 'mul ' + vt5 + ', ' + vt2 + ', ' + vt4 + '.xxxx \n';
				code += 'add ' + vt4 + ', ' + vt0 + ', ' + vt5 + ' \n';			
				code += 'mul ' + vt5 + ', ' + vt3 + '.xxxx, ' + vt4 + ' \n';
				code += 'mul ' + vt4 + ', ' + vt0 + ', ' + vt3 + '.yyyy \n';
				code += 'add ' + vt0 + ', ' + vt5 + ', ' + vt4 + ' \n';
				code += 'crs ' + vt3 + '.xyz, ' + vt2 + ', ' + vt1 + ' \n';			
				code += 'nrm ' + vt1 + '.xyz, ' + vt3 + ' \n';
				code += 'mul ' + vt2 + '.xyz, ' + vt1 + ', ' + regCache.getVaByIndex(Surface3D.CUSTOM2) + '.xxxx \n';
				code += 'mul ' + vt1 + '.x, ' + vt0 + '.zzzz, ' + regCache.getVaByIndex(Surface3D.CUSTOM2) + '.yyyy \n';
				code += 'mul ' + vt3 + '.xyz, ' + vt2 + ', ' + vt1 + '.xxxx \n';
				code += 'add ' + vt1 + '.xyz, ' + vt0 + ', ' + vt3 + ' \n';			
				code += 'mov ' + vt1 + '.w, ' + vc0 + '.xxxx \n';
				code += 'm44 ' + regCache.op + ', ' + vt1 + ', ' + vc7 + '.xyzw \n';
				code += 'mov ' + color + ', ' + regCache.getVaByIndex(Surface3D.CUSTOM3) + '\n';
			
			regCache.freeVt(vt0);
			regCache.freeVt(vt1);
			regCache.freeVt(vt2);
			regCache.freeVt(vt3);
			regCache.freeVt(vt4);
			regCache.freeVt(vt5);
			
			return code;
		}
	}
}