package charts {
	
	import charts.series.dots.scat;
	import charts.series.Element;
	import string.Utils;
	import flash.geom.Point;
	
	public class ScatterBase extends Base {

		// TODO: move this into Base
		protected var style:Object;
		
		public function ScatterBase() { }
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {
			// we ignore the X value (index) passed to us,
			// the user has provided their own x value
			
			var default_style:Object = {
				'dot-size':		this.style['dot-size'],
				width:			this.style.width,	// stroke
				colour:			this.style.colour,
				tip:			this.style.tip
			};
			
			object_helper.merge_2( value, default_style );
				
			// our parent colour is a number, but
			// we may have our own colour:
			if( default_style.colour is String )
				default_style.colour = Utils.get_colour( default_style.colour );
			
			return new scat( default_style );
		}
		
		// Draw points...
		public override function resize( sc:ScreenCoordsBase ): void {
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				var e:scat = this.getChildAt(i) as scat;
				e.resize( sc );
			}
		}

	}
}