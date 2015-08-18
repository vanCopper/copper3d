package core.shaders.utils
{
	/**
	 *
	 * @author vanCopper
	 */
	public class OpCode
	{
		/**
		 * 移动: 将数据从 source1 移动到 destination，按组件 
		 */		
		public static const MOV : String = "mov ";
		
		/**
		 * 相加: destination = source1 + source2，按组件 
		 */		
		public static const ADD : String = "add ";
		
		/**
		 * 相减: destination = source1 - source2，按组件 
		 */		
		public static const SUB : String = "sub ";
		
		/**
		 * 相乘: destination = source1 * source2，按组件 
		 */		
		public static const MUL : String = "mul ";
		
		/**
		 * 相除: destination = source1 / source2，按组件 
		 */		
		public static const DIV : String = "div ";
		
		/**
		 * 倒数: destination = 1/source1，按组件 
		 */		
		public static const RCP : String  = "rcp ";
		
		/**
		 * 最小值: destination = minimum(source1,source2)，按组件 
		 */		
		public static const MIN : String = "min ";
		
		/**
		 * 最大值: destination = maximum(source1,source2)，按组件 
		 */		
		public static const MAX : String = "max ";
		
		/**
		 * 分数: destination = source1 - (float)floor(source1)，按组件 
		 */		
		public static const FRC : String = "frc ";
		
		/**
		 * 平方根: destination = sqrt(source1)，按组件 
		 */		
		public static const SQT : String = "sqt ";
		
		/**
		 * 平方根倒数: destination = 1/sqrt(source1)，按组件 
		 */		
		public static const RSQ : String = "rsq ";
		
		/**
		 * 幂: destination = pow(source1,source2)，按组件 
		 */		
		public static const POW : String = "pow ";
		
		/**
		 * 对数: destination = log_2(source1)，按组件 
		 */		
		public static const LOG : String = "log ";
		
		/**
		 * 指数: destination = 2^source1，按组件 
		 */		
		public static const EXP : String = "exp ";
		
		/**
		 * 标准化: destination = normalize(source1)，按组件（仅生成一个 3 组件结果，目标必须掩码为 .xyz 或更小） 
		 */		
		public static const NRM : String = "nrm ";
		
		/**
		 * 正弦: destination = sin(source1)，按组件 
		 */		
		public static const SIN : String = "sin ";
		
		/**
		 *余弦: destination = cos(source1)，按组件 
		 */		
		public static const COS : String = "cos ";
		
		/**
		 * 叉积:</br>
 		 * destination.x = source1.y * source2.z - source1.z * source2.y</br>
		 * destination.y = source1.z * source2.x - source1.x * source2.z</br>
		 * destination.z = source1.x * source2.y - source1.y * source2.x</br>
		 *（仅生成一个 3 组件结果，目标必须掩码为 .xyz 或更小） 
		 */		
		public static const CRS : String = "crs ";
		
		/**
		 * 点积: destination = source1.x*source2.x + source1.y*source2.y + source1.z*source2.z 
		 */		
		public static const DP3 : String = "dp3 ";
		
		/**
		 * 点积: destination = source1.x*source2.x + source1.y*source2.y + source1.z*source2.z + source1.w*source2.w
		 */		
		public static const DP4 : String = "dp4 ";
		
		/**
		 * 取绝对值: destination = abs(source1)，按组件 
		 */		
		public static const ABS : String = "abs ";
		
		/**
		 * 求反: destination = -source1，按组件 
		 */		
		public static const NEG : String = "neg ";
		
		/**
		 * 饱和: destination = maximum(minimum(source1,1),0)，按组件 
		 */		
		public static const SAT : String = "sat ";
		
		/**
		 * 矩阵连乘 3x3 </br>
		 * destination.x = (source1.x * source2[0].x) + (source1.y * source2[0].y) + (source1.z * source2[0].z)</br>
		 * destination.y = (source1.x * source2[1].x) + (source1.y * source2[1].y) + (source1.z * source2[1].z)</br>
		 * destination.z = (source1.x * source2[2].x) + (source1.y * source2[2].y) + (source1.z * source2[2].z)</br>
		 *（仅生成一个 3 组件结果，目标必须掩码为 .xyz 或更小） 
		 */		
		public static const M33 : String = "m33 ";
		
		/**
		 * 矩阵连乘 4x4 </br>
		 * destination.x = (source1.x * source2[0].x) + (source1.y * source2[0].y) + (source1.z * source2[0].z) + (source1.w * source2[0].w)</br>
		 * destination.y = (source1.x * source2[1].x) + (source1.y * source2[1].y) + (source1.z * source2[1].z) + (source1.w * source2[1].w)</br>
		 * destination.z = (source1.x * source2[2].x) + (source1.y * source2[2].y) + (source1.z * source2[2].z) + (source1.w * source2[2].w)</br>
		 * destination.w = (source1.x * source2[3].x) + (source1.y * source2[3].y) + (source1.z * source2[3].z) + (source1.w * source2[3].w)</br>
		 */		
		public static const M44 : String = "m44 ";
		
		/**
		 * 矩阵连乘 3x4 </br>
		 * destination.x = (source1.x * source2[0].x) + (source1.y * source2[0].y) + (source1.z * source2[0].z) + (source1.w * source2[0].w)</br>
		 * destination.y = (source1.x * source2[1].x) + (source1.y * source2[1].y) + (source1.z * source2[1].z) + (source1.w * source2[1].w)</br>
		 * destination.z = (source1.x * source2[2].x) + (source1.y * source2[2].y) + (source1.z * source2[2].z) + (source1.w * source2[2].w)</br>
		 *（仅生成一个 3 组件结果，目标必须掩码为 .xyz 或更小） 
		 */		
		public static const M34 : String = "m34 ";
		
		//---------version 2--------------------//
		public static const DDX : String = "ddx ";
		
		public static const DDY : String = "ddy ";
		
		public static const IFE : String = "ife ";
		
		public static const INE : String = "ine ";
		
		public static const IFG : String = "ifg ";
		
		public static const IFL : String = "ifl ";
		
		public static const ELS : String = "els ";
		
		public static const EIF : String = "eif ";
		
		public static const TED : String = "ted ";
		
		//-------------------------------------//
		/**
		 * 丢弃（仅适用于片段着色器）:</br>
		 * 如果单个标量源组件小于零，则将丢弃片段并不会将其绘制到帧缓冲区。（目标寄存器必须全部设置为 0） 
		 */		
		public static const KIL : String = "kil ";
		
		/**
		 * 纹理取样（仅适用于片段着色器）:
		 * destination 等于从坐标 source1 上的纹理 source2 进行加载。在这种情况下，source2 必须采用取样器格式。
		 */		
		public static const TEX : String = "tex ";
		
		/**
		 * 大于等于时设置:</br>
		 * destination = source1 >= source2 ? 1 : 0，按组件 
		 */		
		public static const SGE : String = "sge ";
		
		/**
		 * 小于时设置:</br>
		 * destination = source1 < source2 ? 1 : 0，按组件 
		 */		
		public static const SLT : String = "slt ";
		
		// set if greater than
		public static const SGN : String = "sgn ";
		
		/**
		 * 相等时设置:</br>
		 * destination = source1 == source2 ? 1 : 0，按组件 
		 */		
		public static const SEQ : String = "seq ";
		
		/**
		 * 不相等时设置:</br>
		 * destination = source1 != source2 ? 1 : 0，按组件 
		 */		
		public static const SNE : String = "sne ";
		
		public function OpCode()
		{
		}
	}
}