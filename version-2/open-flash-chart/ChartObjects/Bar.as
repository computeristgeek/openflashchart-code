package ChartObjects {
	import ChartObjects.Elements.Element;
	import ChartObjects.Elements.PointBar;
	
	public class Bar extends BarBase {
		
		public function Bar( json:Object, group:Number ) {
			super( json, group );
		}
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {
			return new PointBar( index, value, this.colour, this.group );
		}
	}
}