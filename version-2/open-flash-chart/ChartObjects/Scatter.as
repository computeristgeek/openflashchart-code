package ChartObjects {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ChartObjects.Elements.Element;
	import ChartObjects.Elements.PointScatter;
	import string.Utils;
	import flash.geom.Point;
	
	public class Scatter extends Base
	{
		// TODO: move this into Base
		
		protected var style:Object;
		
		public function Scatter( json:Object )
		{
			this.style = {
				values:			[],
				width:			2,
				colour:			'#3030d0',
				text:			'',		// <-- default not display a key
				'dot-size':		5,
				'font-size':	12,
				tip:			'[#x#,#y#] #size#'
			};
			
			object_helper.merge_2( json, style );
			
			this.line_width = style.width;
			this.colour		= string.Utils.get_colour( style.colour );
			this.key		= style.text;
			this.font_size	= style['font-size'];
			this.circle_size = style['dot-size'];
			
			for each( var val:Object in style.values )
			{
				if( val['dot-size'] == null )
					val['dot-size'] = style['dot-size'];
			}
			
			this.values = style.values;

			this.add_values();
		}
		
		public override function closest( x:Number, y:Number ): Object {
			//
			// because this is a scatter chart, we may have
			// many items for the same X axis value, so we
			// keep them all, then find the closest to the
			// Y position (see data-32.txt for a test)
			//
			var shortest:Number = Number.MAX_VALUE;
			var dx:Number;
			var i:Number;
			var e:Element;
			var elements:Array = new Array();
			var e_x:Number;
			
			// find the closest point(s) in X
			for ( i = 0; i < this.numChildren; i++ ) {
				e = this.getChildAt(i) as Element;
				
				dx = Math.abs( x - e.screen_x );
			
				if ( dx < shortest )
				{
					shortest = dx;
					e_x = e.screen_x;
				}
			}
			
			// get all the points at this X distance
			for ( i = 0; i < this.numChildren; i++ ) {
				e = this.getChildAt(i) as Element;
				
				if( e.screen_x == e_x )
					elements.push( e );
			}
			
			var dist_x:Number = shortest;
		
			shortest = Number.MAX_VALUE;
			var closest:Element = null;
			var dy:Number;
			
			// now find the closest of this bunch in Y
			for ( i = 0; i < elements.length; i++ ) {
				e = elements[i];
				
				dy = Math.abs( y - e.screen_y );
			
				if( dy < shortest )	{
					shortest = dy;
					closest = e;
				}
			}

			for ( i = 0; i < this.numChildren; i++ ) {
				e = this.getChildAt(i) as Element;
				if( e!=closest)
					e.set_tip( false );
			}
				
			return { element:closest, distance_x:dist_x, distance_y:shortest };
		}
		

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
			
			return new PointScatter( default_style );
		}
		
		// Draw points...
		public override function resize( sc:ScreenCoords ): void {
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				var e:PointScatter = this.getChildAt(i) as PointScatter;
				e.resize( sc, this.axis );
			}
		}
		
		//
		// scatter charts can have many items at the same Y position
		// so we need to figure out which one to pass back
		//
		public override function closest_2( x:Number, y:Number ): Object {
			
			var shortest:Number = Number.MAX_VALUE;
			var dx:Number;
			var x_pos:Number;
			var i:Number;
			var e:Element;
			var p:flash.geom.Point;
			
			//
			// get shortest distance along X
			//
			for( i=0; i < this.numChildren; i++ ) {
			
				// some of the children will will mask
				// Sprites, so filter those out:
				//
				if( this.getChildAt(i) is Element ) {
		
					e = this.getChildAt(i) as Element;
				
					p = e.get_mid_point();
					dx = Math.abs( x - p.x );
				
					if( dx < shortest )
					{
						shortest = dx;
						x_pos = p.x;
					}
				}
			}

			var tmp:Array = new Array();
			
			for( i=0; i < this.numChildren; i++ ) {
			
				// some of the children will will mask
				// Sprites, so filter those out:
				//
				if( this.getChildAt(i) is Element ) {
		
					e = this.getChildAt(i) as Element;
				
					p = e.get_mid_point();
					if ( p.x == x_pos )
						tmp.push( e );
				}
			}
			
			var y_min:Number = Number.MAX_VALUE;
			var closest:Element = tmp[0];
			var dy:Number;
			
			for each( e in tmp ) {
				
				p = e.get_mid_point();
				dy = Math.abs( y - p.y );
				
				if ( dy < y_min )
				{
					closest = e;
					y_min = dy;
				}
			}
			
			//
			// TODO: this should be used in Base
			//
			for ( i=0; i < this.numChildren; i++ ) {
			
				if( this.getChildAt(i) is Element ) {
		
					e = this.getChildAt(i) as Element;
					if ( e != closest )
						e.set_tip( false );
				}
			}
		
			if( closest )
				dy = Math.abs( y - closest.y );
				
			return { element:closest, distance_x:shortest, distance_y:dy };
		}
	}
}