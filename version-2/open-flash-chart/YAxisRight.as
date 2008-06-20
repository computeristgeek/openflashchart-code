package {
	import flash.display.Sprite;
	
	public class YAxisRight extends YAxisBase {

		function YAxisRight( json:Object, minmax:MinMax ) {
			
			//
			// default values for a right axis (turned off)
			//
			var style:Object = {
				stroke:			2,
				'tick-length':	3,
				colour:			'#784016',
				offset:			false,
				'grid-colour':	'#F5E1AA',
				'3d':			0,
				steps:			1,
				visible:		false
			};
			
			//
			// OK, the user has set the right Y axis,
			// but forgot to specifically set visible to
			// true, I think we can forgive them:
			//
			if( json.y_axis_right )
				style.visible = true;
				
			
			super( json, minmax, 'y_axis_right', style );
		}
		
		public override function resize( sc:ScreenCoords ):void {
			if ( !this.style.visible )
				return;
				
			this.graphics.clear();
			
			// Axis line:
			this.graphics.lineStyle( 0, 0, 0 );
			this.graphics.beginFill( this.colour, 1 );
			this.graphics.drawRect( sc.right, sc.top, this.stroke, sc.height );
			this.graphics.endFill();
//			return;
			

			// ticks..

			var min:Number = Math.min(this.minmax.y2_min, this.minmax.y2_max);
			var max:Number = Math.max(this.minmax.y2_min, this.minmax.y2_max);
			var every:Number = (this.minmax.y2_max - this.minmax.y2_min) / this.steps;
			var left:Number = sc.right + this.stroke;
			var width:Number;
			for( var i:Number = min; i <= max; i+=every ) {
				
				// start at the bottom and work up:
				var y:Number = sc.get_y_from_val(i, false);
				this.graphics.beginFill( this.colour, 1 );
				this.graphics.drawRect( left, y-(this.stroke/2), this.tick_length, this.stroke );
				this.graphics.endFill();
					
			}
			
		}
	}
}