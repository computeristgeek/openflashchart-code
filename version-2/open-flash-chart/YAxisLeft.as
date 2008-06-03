package {
	import flash.display.Sprite;
	
	public class YAxisLeft extends YAxisBase {

		// TODO: remove this
		public var min:Number;
		public var max:Number;
		
		function YAxisLeft( y_ticks:YTicks, json:Object, minmax:MinMax ) {
			super( y_ticks, json, minmax, 'y' );
		}
		
		public override function resize( sc:ScreenCoords ):void {
			// this should be an option:
			this.graphics.clear();

			// Grid lines
			this.graphics.lineStyle(1,this.grid_colour,1);

			// y axel grid lines
			var every:Number = (this.minmax.y_max - this.minmax.y_min) / this.steps;
			
			tr.ace( 'every ' + every );
			// Set opacity for the first line to 0 (otherwise it overlaps the x-axel line)
			//
			// Bug? Does this work on graphs with minus values?
			//
			var i2:Number = 0;
			var i:Number;
			var y:Number;
			
			var min:Number = Math.min(this.minmax.y_min, this.minmax.y_max);
			var max:Number = Math.max(this.minmax.y_min, this.minmax.y_max);
			
			for( i = min; i <= max; i+=every ) {
				
				// don't draw i = minmax.y_min
				// because it draws over the X axis line
//				if( i != this.minmax.y_min ) {
					
					y = sc.get_y_from_val(i);
					if(i2 == 0)
						this.graphics.lineStyle(1,this.grid_colour,0);
						
					this.graphics.moveTo( sc.left, y );
					this.graphics.lineTo( sc.right, y );

					if(i2 == 0)
						this.graphics.lineStyle(1,this.grid_colour,1);
					i2 += 1;
//				}
			}
			var left:Number = sc.left - this.stroke;
			
			// Axis line:
			this.graphics.lineStyle( 0, 0, 0 );
			this.graphics.beginFill( this.colour, 1 );
			this.graphics.drawRect( left, sc.top, this.stroke, sc.height );
			this.graphics.endFill();
			
			// ticks..
			var width:Number;
			for( i = min; i <= max; i+=every ) {
				
				// start at the bottom and work up:
				y = sc.get_y_from_val(i, false);
				
				if ( i % this.ticks.steps == 0 )
					width = this.ticks.big;
				else
					width = this.ticks.small;
		
				this.graphics.beginFill( this.colour, 1 );
				this.graphics.drawRect( left-this.tick_length, y-(this.stroke/2), this.tick_length, this.stroke );
				this.graphics.endFill();
					
			}
		}
	}
}