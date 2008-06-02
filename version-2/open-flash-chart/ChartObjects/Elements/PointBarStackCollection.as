package ChartObjects.Elements {
	import flash.display.Sprite;
	import flash.geom.Point;
	import com.serialization.json.JSON;
	import string.Utils;
	
	public class PointBarStackCollection extends Element {
		
		protected var tip_pos:flash.geom.Point;
		private var vals:Array;
		public var colour:Number;
		protected var group:Number;
		private var total:Number;
		
		public function PointBarStackCollection( index:Number, value:Object, colour:Number, group:Number ) {
			
			// this is very similar to a normal
			// PointBarBase but without the mouse
			// over and mouse out events
			this.index = index;
			
			// a stacked bar has n Y values
			// so this is an array of objects
			this.vals = value as Array;
			
			this.colour = colour;
			this.group = group;
			this.visible = true;
			
			var prop:String;
			
			var n:Number;	// <-- ugh, leaky variables.
			var bottom:Number = 0;
			var top:Number = 0;
			var odd:Boolean = false;
			var c:Number;

			for each( var item:Object in this.vals )
			{
				// is this a null stacked bar group?
				if( item != null )
				{
					c = odd?this.colour:0x909090;
					tr.ace( item );
					//
					// a valid item is one of [ Number, Object, null ]
					//
					if( item is Number ) {
						tr.ace( item );
						tr.ace( top );
						top += item;
						tr.ace( top );
					}
					else
					{
						top += item.val;
						if( item.colour )
							c = string.Utils.get_colour(item.colour);
					}
						
					var p:PointBarStack = new PointBarStack( index, c, group );
					
					p.set_vals( top, bottom );
					
					p.make_tooltip( 'key' );
					
					this.addChild( p );
					
					bottom = top;
					odd = !odd;
				}
			}
			
			//
			// now, make our 'total' tooltip
			// which is displayed when the mouse
			// is *near* the bar stack
			//
			this.total = 0;
			for (prop in this.vals)
				if( this.vals[prop] is Number )
					this.total += this.vals[prop];
				else
					this.total += this.vals[prop].val;
				
				
			super.make_tooltip( 'key' );
		}
		
		//
		
		//
		// NOTE: sort of JSON object passed in
		//
		protected function parse_value( value:Object ):void {
			
			//var result:* = JSON.deserialize( '['+value+']' ) ;
			
			// for (var prop:String in result)
			//	tr.ace(prop + " : " + result[prop]);
			
			//this.vals = value;
			
			// this.vals = value.split(',');
		}

		public override function resize( sc:ScreenCoords, axis:Number ):void {
			for ( var i:Number = 0; i < this.numChildren; i++ )
			{
				var e:Element = this.getChildAt(i) as Element;
				e.resize( sc, axis );
			}
		}
		
		//
		// is the mouse above, inside or below this bar?
		//
		public override function inside( x:Number ):Boolean {
			for ( var i:Number = 0; i < this.numChildren; i++ )
			{
				var e:Element = this.getChildAt(i) as Element;
				if ( e.inside( x ) )
					return true;
			}
			
			return false;
		}
		
		public override function get_tip_pos():Object {
			var e:Element = this.getChildAt(this.numChildren-1) as Element;
			return e.get_tip_pos();
		}
		
		//
		// TODO: remove this as it is a dirty hack
		//
		public override function make_tooltip( key:String ):void
		{
			// ignore what Base is passing us as it is rubbish
		}
		
		public override function get_tooltip():String {
			//
			// is the mouse over one of the bars in this stack?
			//
			for ( var i:Number = 0; i < this.numChildren; i++ )
			{
				var e:Element = this.getChildAt(i) as Element;
				if ( e.is_tip )
					return e.get_tooltip();
			}
			//
			// the mouse is *near* our stack, so show the 'total' tooltip
			//
			super.get_tooltip();
			
			var tmp:String = this.tooltip.replace('#val#',NumberUtils.formatNumber( this.total ));
			this.tooltip = tmp;
			
			return this.tooltip;
		}
	}
}