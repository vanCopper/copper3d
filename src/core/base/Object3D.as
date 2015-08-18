/**
* GitHub: http://github.com/vanCopper/copper3d
* Blog: http://tgerm.org
*/

package core.base
{
	import flash.geom.Matrix3D;
	

	/**
	 * 基类 
	 * @author vancopper
	 */
	public class Object3D extends Transform3D
	{

		private var _children:Vector.<Object3D>;
		private var _parent:Object3D;
		
		public var name:String = "";
		
		public function Object3D()
		{
			_children = new Vector.<Object3D>();
		}
		
		public function dispose():void
		{
			//TODO:	
		}
		
		override public function get world():Matrix3D
		{
			super.world;
			
			if(this.parent)
			{
				_world.append(this.parent.world);
			}
			
			return _world;
		}
		
		public function addChild(child:Object3D):void
		{
			if(child.parent)
			{
				child.parent.removeChild(child);
			}
			child.parent = this;
			_children.push(child);
		}
		
		public function removeChild(child:Object3D):void
		{
			var index:int = _children.indexOf(child);
			if(index != -1)
			{
				_children.splice(index, 1);
				child.parent = null;
			}
		}
		
		public function getChildByName(childName:String):Object3D
		{
			var cl:Object3D;
			
			for(var i:int = 0; i < _children.length; i++)
			{
				cl = _children[i];
				if(cl.name == childName)
				{
					break;
				}
			}
			
			return cl;
		}

		public function get children():Vector.<Object3D>
		{
			return _children;
		}

		public function set children(value:Vector.<Object3D>):void
		{
			_children = value;
		}

		public function get parent():Object3D
		{
			return _parent;
		}

		public function set parent(value:Object3D):void
		{
			_parent = value;
		}

	}
}