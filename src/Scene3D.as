/**
* GitHub: http://github.com/vanCopper/copper3d
* Blog: http://tgerm.org
*/

package
{
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import core.base.Object3D;
	import core.camera.Camera3D;
	import core.camera.lens.PerspectiveLens;
	
	import utils.Color;

	/**
	 * Scene3D
	 *
	 * @author vanCopper
	 */
	public class Scene3D extends Object3D
	{
		private static var _stage3dIndex:uint = 0;
		
		private var _stage3d:Stage3D;
		private var _context3d:Context3D;
		private var _container:DisplayObject;
		private var _viewPort:Rectangle;
		private var _antialias:int = 4;
		private var _backgroundColor:Color;
		
		
		private var _camera3d:Camera3D;

		public function Scene3D(container:DisplayObject)
		{
			if(!container)return;
			_container = container;
			_backgroundColor = new Color();
			
			_camera3d = new Camera3D(new PerspectiveLens());
			
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
			_stage3d.requestContext3D(Context3DRenderMode.AUTO, App.profileDefault);
			
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
			}else
			{
				setViewPort(_viewPort.x, _viewPort.y, _viewPort.width, _viewPort.height);
			}
			
			_context3d.enableErrorChecking = App.enableErrorChecking;
			_container.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			dispatchEvent(event);
		}
		
		private function onEnterFrame(event:Event):void
		{
			//TODO:	
			
			renderScene();
		}
		
		
		public var model:PerspectiveMatrix3D;
		/**
		 * 渲染场景 
		 * 
		 */		
		private function renderScene():void
		{
			//TODO:
			_context3d.clear(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.alpha);
			App.context3D = _context3d;
			App.stage3D = _stage3d;
			
			App.view = _camera3d.invWorld;
			App.projection = _camera3d.projection;
			App.viewProjection = _camera3d.viewProjection;
			
//			_context3d.setFillMode(Context3DFillMode.WIREFRAME);
			var len:int = children.length;
			for(var i:int = 0; i < len; i++)
			{
				var child:Object3D = children[i];
				if(child)
				{
					child.update();
					child.draw();
				}
			}
			
			_context3d.present();
		}
		
		public function setViewPort(x:int, y:int, width:int, height:int):void
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
				_context3d.clear(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.alpha);
			}
			
			camera3d.lens.updateViewport(0, 0, _viewPort.width, _viewPort.height);
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
				_stage3d.context3D.clear(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.alpha);
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

		public function get camera3d():Camera3D
		{
			return _camera3d;
		}

		public function set camera3d(value:Camera3D):void
		{
			_camera3d = value;
		}

	}
}