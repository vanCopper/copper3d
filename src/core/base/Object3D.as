/**
* GitHub: http://github.com/vanCopper/copper3d
* Blog: http://tgerm.org
*/

package core.base
{
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;

	/**
	 * 基类 
	 * @author vancopper
	 */
	public class Object3D extends EventDispatcher
	{

		private var _children:Vector.<Object3D>;
		private var _parent:Object3D;
		
		private var _local:Matrix3D;
		private var _world:Matrix3D;
		private var _invWorld:Matrix3D;
		
		public var name:String = "";
		// METHODS
		
		
		public function Object3D()
		{
			_children = new Vector.<Object3D>();
			_local = new Matrix3D();
			_world = new Matrix3D();
			_invWorld = new Matrix3D();
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