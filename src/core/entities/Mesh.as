/**
* GitHub: http://github.com/vanCopper/copper3d
* Blog: http://tgerm.org
*/

package core.entities
{
	import core.base.Object3D;
	import core.base.Surface3D;
	import core.materials.DefaultMaterial;
	import core.materials.Material3D;

	/**
	 * @author vancopper
	 */
	public class Mesh extends Object3D
	{
		private var _surfaces:Vector.<Surface3D>;
		private var _material:Material3D;
		
		
		public function Mesh(surfaces:Array, material:Material3D = null)
		{
		    _surfaces = Vector.<Surface3D>(surfaces);
			_material = material;
			if(this.material == null)
			{
				this.material = DefaultMaterial.instance;
			}
		}
		
		override public function update():void
		{
			super.update();
			//TODO:
			
			//更新material
			if(material)
			{
				material.update();
			}
			
			//更新surface
			if(_surfaces)
			{
				for(var i:int = 0; i < _surfaces.length; i++)
				{
					_surfaces[i].update();
				}
			}
		}

		override public function draw():void
		{
			super.draw();
			
			if(_surfaces)
			{
				for(var i:int = 0; i < _surfaces.length; i++)
				{
					if(material)
					{
						material.draw(_surfaces[i]);
					}
				}
			}
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			//TODO:
		}
		
		public function get surfaces():Vector.<Surface3D>
		{
			return _surfaces;
		}

		public function set surfaces(value:Vector.<Surface3D>):void
		{
			_surfaces = value;
		}

		public function get material():Material3D
		{
			return _material;
		}

		public function set material(value:Material3D):void
		{
			_material = value;
		}


	}
}