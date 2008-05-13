package ChartObjects {
	import ChartObjects.Elements.Element;
	import ChartObjects.Elements.PointBarOutline;
	import string.Utils;
	
	public class BarOutline extends BarBase {
		private var outline_colour:Number;
		
		public function BarOutline( json:Object, group:Number ) {
			super( json, group );
			this.outline_colour = string.Utils.get_colour( json['outline-colour'] );
		}
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {
			return new PointBarOutline( index, value, this.colour, this.outline_colour, this.group );
		}
	}
}