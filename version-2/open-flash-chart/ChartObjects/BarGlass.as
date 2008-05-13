package ChartObjects {
	import ChartObjects.Elements.Element;
	import ChartObjects.Elements.PointBarGlass;
	
	public class BarGlass extends BarBase {
		
		public function BarGlass( json:Object, group:Number ) {
			super( json, group );
		}
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {
			return new PointBarGlass( index, value, this.colour, this.group );
		}
	}
}