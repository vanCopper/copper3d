package core.shaders.utils
{
	import flash.display3D.Context3DProfile;
	
	import core.base.Surface3D;

	/**
	 * 寄存器管理器
	 * @author vanCopper
	 */
	public class RegisterManager
	{
		private var _vas:Vector.<RegisterElement>;	//va
		private var _vs:Vector.<RegisterElement>;	//v寄存器
		
		private var _vtPool:RegisterPool;	//vt 对象池
		private var _vcPool:RegisterPool;	//vc 对象池
		private var _vaPool:RegisterPool;	//va 对象池
		private var _vPool:RegisterPool;	//v 对象池
		private var _ftPool:RegisterPool;	// ft 对象池
		private var _fcPool:RegisterPool;	// fc 对象池
		private var _fsPool:RegisterPool;	// fs 对象池
		
		private var _op:RegisterElement;	// 临时op
		private var _oc:RegisterElement;	//临时oc
		
		private var _vcUsed:Vector.<VcRegister>;	//已使用的vc寄存器
		private var _fcUsed:Vector.<FcRegister>;	//已使用的fc寄存器
		private var _fsUsed:Vector.<FsRegister>;	//已使用的fs寄存器
		
		private var _vcMVP:RegisterElement;			//mvp vc寄存器
		private var _vcCache:RegisterElement;		//vc 缓存数据[0,1,2,3]
		private var _fcCache:RegisterElement;		//fc 缓存数据[0,1,2,3]
		
		
		public function RegisterManager()
		{
			_vas = new Vector.<RegisterElement>(Surface3D.DATA_SIZE);
			_vs = new Vector.<RegisterElement>(Surface3D.DATA_SIZE);
			
			_vcUsed = new Vector.<VcRegister>();
			_fcUsed = new Vector.<FcRegister>();
			_fsUsed = new Vector.<FsRegister>();
			
			if(App.profileDefault == Context3DProfile.BASELINE)
			{
				_vaPool = new RegisterPool("va", 8);
				_vtPool = new RegisterPool("vt", 8);
				_vcPool = new RegisterPool("vc", 128);
				_vPool = new RegisterPool("v", 8);
				_ftPool = new RegisterPool("ft", 8);
				_fcPool = new RegisterPool("fc", 28);
				_fsPool = new RegisterPool("fs", 8);
			}else if(App.profileDefault == Context3DProfile.STANDARD)
			{
				_vaPool = new RegisterPool("va", 8);
				_vtPool = new RegisterPool("vt", 26);
				_vcPool = new RegisterPool("vc", 250);
				_vPool = new RegisterPool("v", 10);
				_ftPool = new RegisterPool("ft", 26);
				_fcPool = new RegisterPool("fc", 64);
				_fsPool = new RegisterPool("fs", 16);
			}
			
			_op = getVt();
			_oc = getFt();
		}
		
		public function get vas():Vector.<RegisterElement>
		{
			return _vas;
		}
		
		public function getVaByIndex(index:uint):RegisterElement
		{
			if(!_vas[index])
			{
				_vas[index] = getVa();
			}
			return _vas[index];
		}
		
		public function get vs():Vector.<RegisterElement>
		{
			return _vs;
		}
		
		public function getVByIndex(index:uint):RegisterElement
		{
			if(!_vs[index])
			{
				_vs[index] = getV();
			}
			
			return _vs[index];
		}
		
		/**
		 * 申请va寄存器 
		 * @return 
		 * 
		 */		
		public function getVa():RegisterElement
		{
			return _vaPool.requestReg();
		}
		
		/**
		 * 申请vt寄存器 
		 * @return 
		 * 
		 */		
		public function getVt():RegisterElement
		{
			return _vtPool.requestReg();
		}
		
		/**
		 * 归还vt寄存器 
		 * @param vtReg
		 * 
		 */		
		public function freeVt(vtReg:RegisterElement):void
		{
			_vtPool.freeReg(vtReg);
		}
		
		/**
		 * 申请v寄存器
		 * @return 
		 * 
		 */		
		public function getV():RegisterElement
		{
			return _vPool.requestReg();
		}
		
		/**
		 * 申请vc寄存器 
		 * @param num 申请寄存器的数量
		 * @param register
		 * @return 
		 * 
		 */		
		public function getVc(num:uint, register:VcRegister):RegisterElement
		{
			var vcRegElement:RegisterElement = _vcPool.requestReg();
			for(var i:int = 1; i < num; i++)
			{
				_vcPool.requestReg();
			}
			
			register.vcElement = vcRegElement;
			_vcUsed.push(register);
			return vcRegElement;
		}
		
		/**
		 * 已使用的vc寄存器 
		 * @return 
		 * 
		 */		
		public function get vcUsed():Vector.<VcRegister>
		{
			return _vcUsed;
		}
		
		/**
		 * 已经使用的fc寄存器 
		 * @return 
		 * 
		 */		
		public function get fcUsed():Vector.<FcRegister>
		{
			return _fcUsed;
		}
		
		/**
		 * 已经使用的fs寄存器 
		 * @return 
		 * 
		 */		
		public function get fsUsed():Vector.<FsRegister>
		{
			return _fsUsed;
		}
		
		/**
		 * 获取临时 op 
		 * @return 
		 * 
		 */		
		public function get op():RegisterElement
		{
			return _op;
		}
		
		/**
		 * 获取临时 oc 
		 * @return 
		 * 
		 */		
		public function get oc():RegisterElement
		{
			return _oc;
		}
		
		/**
		 * 获取 mvp 
		 * @return 
		 * 
		 */		
		public function get vcMVP():RegisterElement
		{
			if(!_vcMVP)
			{
				_vcMVP = getVc(4, new VcRegister(App.mvp));
			}
			
			return _vcMVP;
		}
		
		/**
		 * vc [0, 1, 2, 3] 
		 * @return 
		 * 
		 */		
		public function get vcCache():RegisterElement
		{
			if(!_vcCache)
			{
				_vcCache = getVc(1, new VcRegister(Vector.<Number>([0, 1, 2, 3])));
			}
			
			return _vcCache;
		}
		
		public function get fcCache():RegisterElement
		{
			if(!_fcCache)
			{
				_fcCache = getFc(1, new FcRegister(Vector.<Number>([0, 1, 2, 3])));
			}
			
			return _fcCache;
		}
		
		/**
		 * 申请一个ft寄存器 
		 * @return 
		 * 
		 */		
		public function getFt():RegisterElement
		{
			return _ftPool.requestReg();
		}
		
		/**
		 * 归还ft寄存器 
		 * @param ftReg
		 * 
		 */		
		public function freeFt(ftReg:RegisterElement):void
		{
			_ftPool.freeReg(ftReg);
		}

		/**
		 * 申请fc寄存器 
		 * @param num
		 * @param register
		 * @return 
		 * 
		 */		
		public function getFc(num:uint, register:FcRegister):RegisterElement
		{
			var fc:RegisterElement = _fcPool.requestReg();
			for(var i:int = 1; i < num; i++)
			{
				_fcPool.requestReg();
			}
			
			register.fcElement = fc;
			_fcUsed.push(register);
			return fc;
		}
		
		/**
		 * 申请fs寄存器 
		 * @param fsRegister
		 * @return 
		 * 
		 */		
		public function getFs(fsRegister:FsRegister):RegisterElement
		{
			var fs:RegisterElement = _fsPool.requestReg();
			fsRegister.fsElement = fs;
			_fsUsed.push(fsRegister);
			return fs;
		}
	}
}