package charts {
	import charts.Elements.Element;
	import charts.Elements.PointBarGlass;
	import string.Utils;
	
	public class BarGlass extends BarBase {

		
		public function BarGlass( json:Object, group:Number ) {
			
			super( json, group );
		}
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {

			return new PointBarGlass( index, this.get_element_helper( value ), this.group );
		}
	}
}