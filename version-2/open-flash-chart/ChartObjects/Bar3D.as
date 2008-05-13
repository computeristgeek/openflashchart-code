package ChartObjects {
	import ChartObjects.Elements.Element;
	import ChartObjects.Elements.PointBar3D;
	
	public class Bar3D extends BarBase {
		
		public function Bar3D( json:Object, group:Number ) {
			super( json, group );
		}
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {
			return new PointBar3D( index, value, this.colour, this.group );
		}
	}
}