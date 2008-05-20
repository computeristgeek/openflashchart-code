﻿package ChartObjects.Elements {
	import flash.display.Sprite;
	
	public class PointBarOutline extends PointBarBase {
		private var outline:Number;
		
		public function PointBarOutline( index:Number, value:Object, colour:Number, outline:Number, group:Number )	{
			super(index, value, colour, group);
			this.outline = outline;
		}
		
		public override function resize( sc:ScreenCoords, axis:Number ):void {
			
			var h:Object = this.resize_helper( sc, axis );
			
			this.graphics.clear();
			this.graphics.lineStyle(1, this.outline, 1);
			this.graphics.beginFill( this.colour, 1.0 );
			this.graphics.moveTo( 0, 0 );
			this.graphics.lineTo( h.width, 0 );
			this.graphics.lineTo( h.width, h.height );
			this.graphics.lineTo( 0, h.height );
			this.graphics.lineTo( 0, 0 );
			this.graphics.endFill();
			
		}
	}
}