package core.shaders.filters
{
	import core.shaders.utils.RegisterManager;

	/**
	 *
	 * @author vanCopper
	 */
	public class Filter3D
	{
		public var name:String;
		
		public var priority : int = 0;	//权重 越小越早组装
		
		public function Filter3D(filterName:String = "filter3d")
		{
			name = filterName;
		}
		
		public function update(regManager:RegisterManager):void
		{
			//TODO:
		}
		
		/**
		 * 获取顶点程序 
		 * @param regManager
		 * @return 
		 * 
		 */		
		public function getVertexCode(regManager:RegisterManager):String
		{
			return "";
		}
		
		/**
		 * 获取片段程序 
		 * @param regManager
		 * @return 
		 * 
		 */		
		public function getFragmentCode(regManager:RegisterManager):String
		{
			return "";
		}
	}
}