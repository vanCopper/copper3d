package core.entities
{
	import core.entities.primitives.LinesMesh;
	
	/**
	 *
	 * @author vanCopper
	 */
	public class Axis extends LinesMesh
	{
		public function Axis()
		{
			super();
			
			this.lineStyle(1.5, 0xFF0000);
			this.moveTo(0, 0, 0);
			this.lineTo(20, 0, 0);
			this.lineStyle(1.5, 0x00FF00);
			this.moveTo(0, 0, 0);
			this.lineTo(0, 20, 0);
			this.lineStyle(1.5, 0x0000ff);
			this.moveTo(0, 0, 0);
			this.lineTo(0, 0, 20);
		}
	}
}