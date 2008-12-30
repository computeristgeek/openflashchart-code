package charts.series.dots {
	import charts.series.dots.scat;
	import charts.Elements.Point;
	
	public class dot_factory {
		
		public static function make( index:Number, style:Object ):PointDotBase {
			
			tr.aces( 'dot factory type:', style.type);
			switch (style['type'])
			{
				case 'star':
					//return new Hollow(index, style);
					//return make_star(index, style);
					return new star(index, style);
					break;
				
				case 'dot':
					return new charts.Elements.Point(index, style);
					break;
				
				case 'solid-dot':
					return new PointDot(index, style);
					break;
					
				case 'hollow-dot':
					return new Hollow(index, style);
					break;
					
				default:
					return new scat(style);
					break;
			}
		}
		
		/*
		private static function make_star(index:Number, style:Object): PointDotBase {
			
			var default_style:Object = {
				'dot-size':		this.style['dot-size'],
				'halo-size':	this.style['halo-size'],
				width:			this.style.width,	// stroke
				colour:			this.style.colour,
				tip:			this.style.tip
			};
			
			this.style = {
				values:			[],
				width:			2,
				colour:			'#3030d0',
				text:			'',		// <-- default not display a key
				'dot-size':		5,
				'halo-size':	2,
				'font-size':	12,
				tip:			'[#x#,#y#] #size#',
				stepgraph:		0
			};
			
			// Apply dot style defined at the plot level
			object_helper.merge_2( this.style['dot-style'], default_style );
			// Apply attributes defined at the value level
			object_helper.merge_2( value, default_style );
				
			// our parent colour is a number, but
			// we may have our own colour:
			if( default_style.colour is String )
				default_style.colour = Utils.get_colour( default_style.colour );
			
			return new star(index, style);
		}
		*/
	}
}