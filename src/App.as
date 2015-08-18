package
{
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Matrix3D;
	
	import core.materials.Material3D;

	/**
	 * 
	 * @author vancopper
	 * 
	 */	
	public class App
	{
		public function App()
		{
		}
		
		protected var _sourceFactor:String	//混合模式
		protected var _destFactor:String 	//混合模式
		protected var _depthWrite:String	//深度测试
		protected var _depthCompare:String 	//测试条件
		protected var _cullFace:String		//裁剪
		
		public static var profileDefault:String = Context3DProfile.STANDARD;
		
		public static var defaultCullFace:String = Context3DTriangleFace.NONE;
		public static var defaultDepthWirte:Boolean = true;
		public static var defaultDepthCompare:String = Context3DCompareMode.LESS_EQUAL;
		public static var defaultSourceFactor:String = Context3DBlendFactor.ONE;
		public static var defaultDestFactor:String = Context3DBlendFactor.ZERO;
		
		public static var context3D:Context3D;	//当前激活的Context3D
		public static var stage3D:Stage3D;		//当前激活的Stage3D
		public static var stage:Stage;			//舞台
		
		public static var view:Matrix3D = new Matrix3D();
		public static var projection:Matrix3D;
		public static var viewProjection:Matrix3D;
		public static var world:Matrix3D = new Matrix3D();
		public static var mvp:Matrix3D = new Matrix3D();
		
		public static const VIEW_PORT_MAX:Number = 2048;
		public static const VIEW_PORT_MIN:Number = 50;
		public static const enableErrorChecking:Boolean = true;
		
		public static const DEBUG:Boolean = true;	//	是否为调试模式		
	}
}