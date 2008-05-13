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
		
	}
}