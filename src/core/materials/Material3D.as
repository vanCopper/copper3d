/**
* GitHub: http://github.com/vanCopper/copper3d
* Blog: http://tgerm.org
*/

package core.materials
{
	import flash.display.BlendMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DTriangleFace;
	
	import core.base.Surface3D;
	import core.shaders.Shader3D;
	

	/**
	 * 材质 
	 * @author vancopper
	 */
	public class Material3D
	{
		protected var _sourceFactor:String	//混合模式
		protected var _destFactor:String 	//混合模式
		protected var _depthWrite:Boolean	//深度测试
		protected var _depthCompare:String 	//测试条件
		protected var _cullFace:String		//裁剪
		protected var _blendMode:String		//混合模式
		protected var _stateDirty:Boolean = false;	//context3d状态
		protected var _shader:Shader3D;	
		protected var _oldContext3D:Context3D;
		
		public function Material3D()
		{
			//TODO:
			
			_sourceFactor = App.defaultSourceFactor;
			_destFactor = App.defaultDestFactor;
			_cullFace = App.defaultCullFace;
			_depthWrite = App.defaultDepthWirte;
			_depthCompare = App.defaultDepthCompare;
		}
		
		public function update():void
		{
			//TODO:
			if(_oldContext3D != App.context3D)
			{
				updateTexture();
			}
			updateShader();
			
			_oldContext3D = App.context3D;
			
			validate();
			if(_stateDirty)
			{
				App.context3D.setBlendFactors(sourceFactor, destFactor);
				App.context3D.setCulling(cullFace);
				App.context3D.setDepthTest(depthWrite, depthCompare);
			}else
			{
				App.context3D.setBlendFactors(App.defaultSourceFactor, App.defaultDestFactor);
				App.context3D.setCulling(App.defaultCullFace);
				App.context3D.setDepthTest(App.defaultDepthWirte, App.defaultDepthCompare);
			}
		}
		
		public function draw(surface:Surface3D):void
		{
			//TODO:
			if(_shader)
			{
				_shader.draw(surface);
			}
		}
		
		public function clear():void
		{
			//TODO:
			if(_shader)
			{
				_shader.clear();
			}
		}
		
		public function dispose():void
		{
			//TODO:
		}
		
		protected function updateTexture():void
		{
			//TODO:	
		}
		
		protected function updateShader():void
		{
			//TODO:
			if(_shader)
			{
				_shader.update();
			}
		}
		
		private function validate():void
		{
			//TODO:
			if(sourceFactor != App.defaultSourceFactor	||
				destFactor	!= App.defaultDestFactor	||
				cullFace	!= App.defaultCullFace		||
				depthWrite	!= App.defaultDepthWirte	||
				depthCompare!= App.defaultDepthCompare)
			{
				_stateDirty = true;
			}else
			{
				_stateDirty = false;
			}
		}

		public function get sourceFactor():String
		{
			return _sourceFactor;
		}

		public function set sourceFactor(value:String):void
		{
			_sourceFactor = value;
		}

		public function get destFactor():String
		{
			return _destFactor;
		}

		public function set destFactor(value:String):void
		{
			_destFactor = value;
		}

		public function get depthWrite():Boolean
		{
			return _depthWrite;
		}

		public function set depthWrite(value:Boolean):void
		{
			_depthWrite = value;
		}

		public function get depthCompare():String
		{
			return _depthCompare;
		}

		public function set depthCompare(value:String):void
		{
			_depthCompare = value;
		}

		public function get cullFace():String
		{
			return _cullFace;
		}

		public function set cullFace(value:String):void
		{
			_cullFace = value;
		}

		public function get blendMode():String
		{
			return _blendMode;
		}

		/**
		 *  
		 * @param value
		 * <ul>
		 * <li>BlendMode.NORMAL: 无混合</li>
		 * <li>BlendMode.MULTIPLY</li>
		 * <li>BlendMode.ADD</li>
		 * <li>BlendMode.ALPHA</li>
		 * </ul>
		 */		
		public function set blendMode(value:String):void
		{
			_blendMode = value;
			
			switch(_blendMode)
			{
				case BlendMode.NORMAL:
					_sourceFactor = Context3DBlendFactor.ONE;
					_destFactor = Context3DBlendFactor.ZERO;
					break;
				case BlendMode.MULTIPLY:
					_sourceFactor = Context3DBlendFactor.ZERO;
					_destFactor = Context3DBlendFactor.SOURCE_COLOR;
					break;
				case BlendMode.ADD:
					_sourceFactor = Context3DBlendFactor.SOURCE_ALPHA;
					_destFactor = Context3DBlendFactor.ONE;
					break;
				case BlendMode.ALPHA:
					_sourceFactor = Context3DBlendFactor.SOURCE_ALPHA;
					_destFactor = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
					break;
				case BlendMode.SCREEN:
					_sourceFactor = Context3DBlendFactor.ONE;
					_destFactor = Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR;
					break;
				default:
					break;
			}
		}
		
		public function set bothSides(value:Boolean):void
		{
			if(value)
			{
				cullFace = Context3DTriangleFace.NONE;
			}else
			{
				cullFace = Context3DTriangleFace.BACK;
			}
		}
		
		public function set transparent(value:Boolean):void
		{
			if(value)
			{
				blendMode = BlendMode.ALPHA;
			}
		}


	}
}