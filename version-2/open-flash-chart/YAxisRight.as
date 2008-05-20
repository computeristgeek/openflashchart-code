﻿package {
	import flash.display.Sprite;
	
	public class YAxisRight extends YAxisBase {

		function YAxisRight( y_ticks:YTicks, json:Object, minmax:MinMax ) {
			if ( ( json['show_y2'] != undefined ) && (json['show_y2']=='true') )
				super( y_ticks, json, minmax, 'y' );
			else
			{
				this._width = 0;
				this.visible = false;
				
			}
		}
		
		public override function resize( sc:ScreenCoords ):void {
			if ( !this.visible )
				return;
				
			this.graphics.clear();
			this.graphics.lineStyle( this.stroke, this.colour, 100 );
		
			this.graphics.moveTo( sc.right, sc.top );
			this.graphics.lineTo( sc.right, sc.bottom );
			
			// create new ticks..
			var every:Number = (this.minmax.y2_max-this.minmax.y2_min)/this.steps;
			for( var i:Number=this.minmax.y2_min; i<=this.minmax.y2_max; i+=every )
			{
				// start at the bottom and work up:
				var y:Number = sc.get_y_from_val(i);
				this.graphics.moveTo( sc.right, y );
				if( i % this.ticks.steps == 0 )
					this.graphics.lineTo( sc.right+this.ticks.big, y );
				else
					this.graphics.lineTo( sc.right+this.ticks.small, y );
			}
		}
	}
}