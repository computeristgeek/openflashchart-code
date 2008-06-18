package ChartObjects.Elements {
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class PointBarStack extends PointBarBase {
		private var total:Number;
		
		public function PointBarStack( index:Number, value:Object, group:Number ) {
			
			// we are not passed a string value, the value
			// is set by the parent collection later
			super( index, value, value.colour, group );
			this.total = value.total;
		}

		
		public override function make_tooltip( key:String ):void {
			this.tooltip = 'Total : '+ this.total + '<br>' + NumberUtils.formatNumber( this.top-this.bottom );
		}
				
		//
		// BUG: we assume that all are positive numbers:
		//
		public override function resize( sc:ScreenCoords, axis:Number ):void {
			this.graphics.clear();
			
			var tmp:Object = sc.get_bar_coords( this.index, this.group );
			
			// move the Sprite into position:
			this.x = tmp.x;
			this.y = sc.get_y_from_val( this.top, axis==2 );
			
			var height:Number = sc.get_y_from_val( this.bottom, axis == 2) - this.y;

			this.graphics.beginFill( this.colour, 1 );
			this.graphics.drawRect( 0, 0, tmp.width, height );
			this.graphics.endFill();
			
			this.tip_pos = new flash.geom.Point( this.x + (tmp.width / 2), this.y );
		}
	}
}