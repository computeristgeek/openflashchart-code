package ChartObjects {
	import ChartObjects.Elements.Element;
	import ChartObjects.Elements.PointBarStackCollection;
	import string.Utils;
	import com.serialization.json.JSON;
	
	public class BarStack extends BarBase {
		//private var line_width:Number;
		
		public function BarStack( json:Object, num:Number, group:Number ) {
			super( json, group );
		}
		
		
		protected override function get_element( x:Number, value:Object ): Element {
			return new PointBarStackCollection( x, value, this.colour, this.group );
		}
		
		//
		// stacked bar charts will need the Y to figure out which
		// bar in the stack to return
		//
		public override function inside( x:Number, y:Number ):Object {
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