/* */

package labels {
	
    import flash.text.TextField;
	import flash.geom.Rectangle;
	
	
	public class AxisLabel extends TextField {
		public var xAdj:Number = 0;
		public var yAdj:Number = 0;
		public var leftOverhang:Number = 0;
		public var rightOverhang:Number = 0;
		
		public function AxisLabel()	{}
		
		/**
		 * Rotate the label and align it to the X Axis tick
		 * 
		 * @param	rotation
		 */
		public function rotate_and_align( rotation:Number ): void
		{
			if (this.visible) 
			{
				this.rotation = rotation;
				
				// NOTE: We want the labels to be top justified along the X Axis
				// NOTE: Child rotation is between -180 and 180

				var xAdj:Number = 0;
				var yAdj:Number = 0;
				
				var titleRect:Rectangle = this.getBounds(this);
				var tempRect:Rectangle;

				if (this.rotation == 0)
				{
					xAdj = - titleRect.width / 2;
					///yAdj += 0;
				} 
				else if (this.rotation == -90) 
				{
					xAdj = - titleRect.width / 2;
					yAdj = titleRect.height;
				} 
				else if (this.rotation == 90) 
				{
					xAdj = titleRect.width / 2;
					//yAdj += 0;
				} 
				else if (Math.abs(this.rotation) == 180) 
				{
					xAdj = titleRect.width / 2;
					yAdj = titleRect.height;
				} 
				else if (this.rotation < -90) //-90
				{
					// temporarily change rotation to easily determine x adjustment
					this.rotation += 180;
					tempRect = this.getBounds(this);
					this.rotation -= 180;

					xAdj = titleRect.width + ((3 * tempRect.x) / 2);
					yAdj = -titleRect.y;
				} 
				else if (this.rotation < 0) 
				{
					// temporarily change rotation to easily determine x adjustment
					this.rotation += 90;
					tempRect = this.getBounds(this);
					this.rotation -= 90;

					xAdj = -titleRect.width - (tempRect.x / 2);
					yAdj = -titleRect.y;
				} 
				else if (this.rotation < 90) 
				{
					xAdj = -titleRect.x / 2;
					yAdj = -titleRect.y;
				} 
				else 
				{
					// temporarily change rotation to easily determine x adjustment
					this.rotation -= 90;
					tempRect = this.getBounds(this);
					this.rotation += 90;

					xAdj = -tempRect.x / 2;
					yAdj = -titleRect.y;
				}
				
				this.xAdj = xAdj;
				this.yAdj = yAdj;
				this.leftOverhang = Math.abs(this.x + xAdj);
				this.rightOverhang = Math.abs(this.x + this.width + xAdj);
			}
		}
	}
}