/**
* GitHub: http://github.com/vanCopper/copper3d
* Blog: http://tgerm.org
*/

package
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import core.base.Object3D;
	
	import utils.Color;

	/**
	 * Scene3D
	 *
	 * @author vanCopper
	 */
	public class Scene3D extends Object3D
	{
		// PROPERTIES
		private static var _stage3dIndex:uint = 0;
		
		private var _stage3d:Stage3D;
		private var _context3d:Context3D;
		private var _container:DisplayObjectContainer;
		private var _viewPort:Rectangle;
		private var _antialias:int;
		private var _backgroundColor:Color;

		// METHODS
		
		
		public function Scene3D(container:DisplayObjectContainer)
		{
			if(!container)return;
			_container = container;
			_backgroundColor = new Color();
			if(_container.stage)
			{
				onAddToStage(null);				
			}else
			{
				_container.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			}
		}
		
		private function onAddToStage(event:Event):void
		{
			if(_container.hasEventListener(Event.ADDED_TO_STAGE))
			{
				_container.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			}
			
			if(_stage3dIndex >= 4)
			{
				throw new Error("Scene3D创建上限：4");
			}
			
			_stage3d = _container.stage.stage3Ds[_stage3dIndex];
			_stage3d.addEventListener(Event.CONTEXT3D_CREATE, onContext3dCreate);
			_stage3d.requestContext3D(Context3DRenderMode.AUTO, Context3DProfile.BASELINE);
			
			_stage3dIndex ++;
		}
		
		private function onContext3dCreate(event:Event):void
		{
			_context3d = _stage3d.context3D;
			
			if (_context3d.driverInfo.indexOf("Software") != -1) 
			{
				// 软解模式
			} else if (_context3d.driverInfo.indexOf("disposed") != -1)
			{
				//Context 销毁
			}
			
			if(!_viewPort)
			{
				setViewPort(0, 0, _container.stage.stageWidth, _container.stage.stageHeight);
			}
			
			_context3d.enableErrorChecking = App.enableErrorChecking;
			_container.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			//TODO:	
			
			renderScene();
		}
		
		/**
		 * 渲染场景 
		 * 
		 */		
		private function renderScene():void
		{
			//TODO:
		}
		
		public function setViewPort(x:Number, y:Number, width:Number, height:Number):void
		{
			if(!_viewPort) _viewPort = new Rectangle();
			
			if(width < App.VIEW_PORT_MIN) width = App.VIEW_PORT_MIN;
			if(height < App.VIEW_PORT_MIN) height = App.VIEW_PORT_MIN;
			
			if(width > App.VIEW_PORT_MAX) width = App.VIEW_PORT_MAX;
			if(height > App.VIEW_PORT_MAX) height = App.VIEW_PORT_MAX;
			
			_viewPort.setTo(x, y, width, height);
			
			//TODO: 设置镜头的 viewPort
			
			if(_context3d)
			{
				_stage3d.x = _viewPort.x;
				_stage3d.y = _viewPort.y;
				_context3d.configureBackBuffer(_viewPort.width, _viewPort.height, antialias);
				_context3d.clear(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
			}
		}
		
		
		/**
		 * 获取抗锯齿等级 
		 * @return 
		 * 
		 */		
		public function get antialias():int {
			return _antialias;
		}
		
		/**
		 * 设置抗锯齿等级 
		 * @param value
		 * 
		 */		
		public function set antialias(value:int):void {
			if (value == _antialias) {
				return;
			}
			_antialias = value;
			if (viewPort && _stage3d && _stage3d.context3D) {
				_stage3d.context3D.configureBackBuffer(viewPort.width, viewPort.height, value);
				_stage3d.context3D.clear(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a);
			}
		}

		public function get viewPort():Rectangle
		{
			return _viewPort ? _viewPort.clone() : _viewPort;
		}
		
		public function get stage3d():Stage3D
		{
			return _stage3d;
		}

		public function set stage3d(value:Stage3D):void
		{
			_stage3d = value;
		}

		public function get backgroundColor():Color
		{
			return _backgroundColor;
		}

		public function set backgroundColor(value:Color):void
		{
			_backgroundColor = value;
		}


	}
}