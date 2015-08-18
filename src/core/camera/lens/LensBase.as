package core.camera.lens
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;

	/**
	 * 镜头
	 * @author vanCopper
	 */
	public class LensBase extends EventDispatcher
	{
		protected var _projection:Matrix3D;		//投影矩阵
		protected var _invProjection:Matrix3D;	//投影逆矩阵
		protected var _viewPort:Rectangle;		//视口
		protected var _scissorRect:Rectangle;
		protected var _near:Number;				//近截面
		protected var _far:Number;				//远截面
		protected var _aspectRatio:Number = 1;  
		protected var _projDirty:Boolean; //投影矩阵是否需要更新
		protected var _invProjDirty		: Boolean;			// 投影逆矩阵需要更新
		protected var _zoom				: Number;			// 焦距
		
		
		public static const PROJECTION_UPDATE:String = "projection_update";
		
		private static const projectionEvent:Event = new Event(PROJECTION_UPDATE);
			
			
		
		public function LensBase()
		{
			_projection = new Matrix3D();
			_invProjection = new Matrix3D();
			_viewPort = new Rectangle();
			_scissorRect = new Rectangle();
			_near = 0.01;
			_far = 1000;
		}
		
		public function get aspect():Number {
			return 1;
		}
		
		/**
		 * 焦距 
		 * @return 
		 * 
		 */		
		public function get zoom():Number {
			return _zoom;
		}
		
		/**
		 * 焦距 
		 * @return 
		 * 
		 */		
		public function set zoom(value:Number):void {
			if (value == _zoom) {
				return;
			}
			_zoom = value;
			invalidateProjection();
		}
		
		protected function invalidateProjection() : void
		{
			this._projDirty = true;
			this._invProjDirty = true;
		}
		
		public function get invProjection():Matrix3D
		{
			if (_invProjDirty) 
			{
				_invProjection.copyFrom(_projection);
				_invProjection.invert();
				_invProjDirty = false;
			}
			return _invProjection;
		}

		public function get near():Number
		{
			return _near;
		}

		public function set near(value:Number):void
		{
			if(_near == value)return;
			
			_near = value;
			invalidateProjection();
		}

		public function get far():Number
		{
			return _far;
		}

		public function set far(value:Number):void
		{
			if(_far == value)return;
			
			_far = value;
			invalidateProjection();
		}

		public function get aspectRatio():Number
		{
			return _aspectRatio;
		}

		public function set aspectRatio(value:Number):void
		{
			if(_aspectRatio == value) return;
			
			_aspectRatio = value;
			invalidateProjection();
		}
		

		/**
		 * 投影矩阵 
		 * @return 
		 * 
		 */		
		public function get projection() : Matrix3D
		{
			if (_projDirty)
			{
				updateProjectionMatrix();
			}
			return _projection;
		}
		
		
		public function updateViewport(x:int, y:int, width:int, height:int):void
		{
			_viewPort.x = x;
			_viewPort.y = y;
			_viewPort.width = width;
			_viewPort.height = height;
			invalidateProjection();
		}
		
		/**
		 * 更新投影矩阵 
		 */		
		public function updateProjectionMatrix() : void 
		{
			this._projDirty 	= false;	
			this._invProjDirty 	= true;
			this.dispatchEvent(projectionEvent);
		}

	}
}