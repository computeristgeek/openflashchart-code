package charts {
	import charts.Elements.Element;
	import charts.series.bars.PointBarStackCollection;
	import string.Utils;
	import com.serialization.json.JSON;
	import flash.geom.Point;
	
	
	public class BarStack extends BarBase {
		
		public function BarStack( json:Object, num:Number, group:Number ) {
			
			super(null, 0);
			
			this.style = {
				values:				[],
				keys:				[],
				tip:				'#x_label# : #val#<br>#total'
			};
			
			object_helper.merge_2( json, style );
			
			
//			this.axis = which_axis_am_i_attached_to(data, num);
			
			//
			// bars are grouped, so 3 bar sets on one chart
			// will arrange them selves next to each other
			// at each value of X, this.group tell the bar
			// where it is in that grouping
			//
			this.group = group;
			
			this.values = this.style.values;

			this.add_values();
		}
		
		//
		// return an array of key info objects:
		//
		public override function get_keys(): Object {
			
			var tmp:Array = [];
			
			for each( var o:Object in this.style.keys ) {
				if ( o.text && o['font-size'] && o.colour ) {
					o.colour = string.Utils.get_colour( o.colour );
					tmp.push( o );
				}
			}
			
			return tmp;
		}
		
		//
		// value is an array (a stack) of bar stacks
		//
		protected override function get_element( index:Number, value:Object ): Element {
			
			//
			// TODO: colour - should we pass this through
			//       to colour the key text?
			//
			
			//
			// this is the style for a stack:
			//
			var default_style:Object = {
				tip:		this.style.tip,
				values:		value
			};
			
			
			return new PointBarStackCollection( index, default_style, this.group );
		}
		
		
		//
		// override the default closest behaviour
		//
		public override function closest_2( x:Number, y:Number ): Array {
			var shortest:Number = Number.MAX_VALUE;
			var closest:Element = null;
			var dx:Number;
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
			
				// get the collection
				var e:PointBarStackCollection = this.getChildAt(i) as PointBarStackCollection;
				
				var p:flash.geom.Point = e.get_mid_point();
				dx = Math.abs( x - p.x );
				
				if( dx < shortest )	{
					shortest = dx;
					closest = e;
				}
			}
			
			var dy:Number = 0;
			if( closest )
				dy = Math.abs( y - closest.y );
				
			return new Array();// TODO: FIX!! { element:closest, distance_x:shortest, distance_y:dy };
		}
		
		
		//
		// TODO: maybe delete this?
		//
		public override function closest( x:Number, y:Number ): Object {
			var shortest:Number = Number.MAX_VALUE;
			var ex:Element = null;
			
			for ( var i:Number = 0; i < this.numChildren; i++ )
			{
				// get the collection
				var stack:Element = this.getChildAt(i) as PointBarStackCollection;
				
				// get the first bar in the stack
				var e:Element = stack.getChildAt(0) as Element;
				
				e.is_tip = false;
				
				if( (x > e.x) && (x < e.x+e.width) )
				{
					// mouse is in position 1
					shortest = Math.min( Math.abs( x - e.x ), Math.abs( x - (e.x+e.width) ) );
					ex = stack;
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
						ex = stack;
					}
				}
			}
			var dy:Number = Math.abs( y - ex.y );
			
			return { element:ex, distance_x:shortest, distance_y:dy };
		}
		
		//
		// TODO: maybe delete this?
		//
		//
		// stacked bar charts will need the Y to figure out which
		// bar in the stack to return
		//
		public override function inside__( x:Number, y:Number ):Object {
			var ret:Element = null;
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				
				var e:PointBarStackCollection = this.getChildAt(i) as PointBarStackCollection;
				
				//
				// may return a PointBarStack or null
				//
				ret = e.inside_2(x);
				
				if( ret )
					break;
			}
			
			var dy:Number = 0;
			if ( ret != null )
				dy = Math.abs( y - ret.y );
				
			return { element:ret, distance_y:dy };
		}
	}
}