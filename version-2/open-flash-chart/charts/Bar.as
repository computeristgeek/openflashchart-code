package charts {
	import charts.Elements.Element;
	import charts.Elements.PointBar;
	import string.Utils;

	
	public class Bar extends BarBase {
		
		public function Bar( json:Object, group:Number ) {
			
			super( json, group );
		}
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {

			return new PointBar( index, this.get_element_helper( value ), this.group );
		}
	}
}