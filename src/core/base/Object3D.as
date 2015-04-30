package core.base
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	/**
	 * 基类 
	 * @author vancopper
	 * 
	 */	
	public class Object3D extends EventDispatcher
	{
		public function Object3D(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}