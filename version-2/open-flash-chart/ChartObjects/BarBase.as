﻿package ChartObjects {
	import ChartObjects.Elements.Element;
	import ChartObjects.Elements.PointBarBase;
	import string.Utils;
	import global.Global;
	
	public class BarBase extends Base
	{
		protected var group:Number;
		
		public function BarBase( json:Object, group:Number )
		{
			this.parse_bar( json );
			
//			this.axis = which_axis_am_i_attached_to(data, num);
			
			//
			// bars are grouped, so 3 bar sets on one chart
			// will arrange them selves next to each other
			// at each value of X, this.group tell the bar
			// where it is in that grouping
			//
			this.group = group;
			
			this.values = json['values'];
			
			super.set_links( null );
//			super.set_links( data['links'+append] );
//			super.set_tooltips( data['tool_tips_set'+append] );
			
			this.make();
		}
		
		//
		// remove this when we move to JSON
		//
		public function parse_bar( json:Object ):void {
		
			//this.alpha = Number( vals[0] );
			this.colour = string.Utils.get_colour( json.colour );
			this.key = json.text;
			this.font_size = json['font-size'];
			
		}
		
		//
		// called from the base object
		//
		protected override function get_element( x:Number, val:Object ): ChartObjects.Elements.Element {
			return new ChartObjects.Elements.PointBar( x, val, this.colour, this.group );// right_axis, bar, bar_count );
		}
		
		//
		// hello people in the future! I was doing OK until I found some red wine. Now I can't figure stuff out,
		// like, do I pass in this.axis, or do I make it a member of each PointBarBase? I don't know. Hey, I know
		// I'll flip a coin and see what happens. It was heads. What does it mean? Mmmmm.... red wine....
		// Fuck it, I'm passing it in. Makes the resize method messy, but keeps the PointBarBase clean.
		//
		public override function resize( sc:ScreenCoords ): void {
			
			for ( var i:Number = 0; i < this.numChildren; i++ )
			{
				var e:Element = this.getChildAt(i) as Element;
				e.resize( sc, this.axis );
			}
		}
		
		/*
				
			      +-----+
			      |  B  |
			+-----+     |   +-----+
			|  A  |     |   |  C  +- - -
			|     |     |   |     |  D
			+-----+-----+---+-----+- - -
			         1   2
			
		*/
			
		
		public override function closest( x:Number, y:Number ): Object {
			var shortest:Number = Number.MAX_VALUE;
			var ex:Element = null;
			
			for ( var i:Number = 0; i < this.numChildren; i++ )
			{
				var e:Element = this.getChildAt(i) as Element;

				e.is_tip = false;
				
				if( (x > e.x) && (x < e.x+e.width) )
				{
					// mouse is in position 1
					shortest = Math.min( Math.abs( x - e.x ), Math.abs( x - (e.x+e.width) ) );
					ex = e;
					break;
				}
				else
				{
					// mouse is in position 2
					// get distance to left side and right side
					var d1:Number = Math.abs( x - e.x );
					var d2:Number = Math.abs( x - (e.x+e.width) );
					var min:Number = Math.min( d1, d2 );
					if( min < shortest )
					{
						shortest = min;
						ex = e;
					}
				}
			}
			var dy:Number = Math.abs( y - ex.y );
			
			return { element:ex, distance_x:shortest, distance_y:dy };
		}
	}
}