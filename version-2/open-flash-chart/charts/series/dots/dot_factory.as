﻿package charts.series.dots {
	import charts.series.dots.scat;
	import charts.Elements.Point;
	
	public class dot_factory {
		
		public static function make( index:Number, style:Object ):PointDotBase {
			
			tr.aces( 'dot factory type:', style.type);
			switch (style['type'])
			{
				case 'star':
					return new star(index, style);
					break;
				
				case 'anchor':
					return new anchor(index, style);
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
	}
}