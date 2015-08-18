package core.camera.lens {
	
	
	
	/**
	 * 透视投影 
	 * @author Neil
	 * 
	 */	
	public class PerspectiveLens extends LensBase {
		
		private static const rawData : Vector.<Number> = new Vector.<Number>(16, true);
		
		private var _fieldOfView : Number;			// field of view
		private var _aspect 	 : Number;			// 横纵比
		
		public function PerspectiveLens(fieldOfView : Number = 75) {
			super();
			this._aspect = 1.0;
			this.fieldOfView = fieldOfView;
		}
		
		
		override public function get aspect():Number {
			return this._aspect;
		}
		
		/**
		 * 焦距 
		 * @param value
		 * 
		 */		
		override public function set zoom(value : Number) : void {
			if (_zoom == value) {
				return;
			}
			_zoom = value;
			_fieldOfView = Math.atan(value) * 360 / Math.PI;
			invalidateProjection();
		}
		
		public function get fieldOfView() : Number {
			return _fieldOfView;
		}
		
		public function set fieldOfView(value : Number) : void {
			if (value == _fieldOfView) {
				return;
			}
			_fieldOfView = value;
			_zoom = Math.tan(value * Math.PI / 360);
			invalidateProjection();
		}
		
		override public function updateProjectionMatrix() : void {
			
			var w : Number = _viewPort.width;
			var h : Number = _viewPort.height;
			var n : Number = near;
			var f : Number = far;
			var a : Number = w / h;
			var y : Number = 1 / this._zoom * a;
			var x : Number = y / a;
			
			rawData[0] = x;
			rawData[5] = y;
			rawData[10] = f / (n - f);
			rawData[11] = -1;
			rawData[14] = (f * n) / (n - f);
			
			
			rawData[0] = x / (w / _viewPort.width);
			rawData[5] = y / (h / _viewPort.height);
			rawData[8] = 1  - (_viewPort.width  / w) - (_viewPort.x / w) * 2;
			rawData[9] = -1 + (_viewPort.height / h) + (_viewPort.y / h) * 2;
			
			this._aspect    = a;
			this._projection.copyRawDataFrom(rawData);
			this._projection.prependScale(1, 1, -1);
			
			super.updateProjectionMatrix();
		}
		
	}
}


