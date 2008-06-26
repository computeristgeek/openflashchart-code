package ChartObjects {
	import ChartObjects.Elements.Element;
	import ChartObjects.Elements.PointBarSketch;
	import string.Utils;
	
	public class BarSketch extends BarBase {
		private var outline_colour:Number;
		private var offset:Number;
		
		public function BarSketch( json:Object, group:Number ) {
			super( json, group );
		}
		
/*
 *
 * FIX THIS::
 *
		public override function parse_bar( json:Object ):void {
			var style:Object = {
				values:				[],
				colour:				'#3030d0',
				'outline-colour':	"#000000",
				text:				'',		// <-- default not display a key
				'font-size':		12,
				offset:				3,
				width:				2
			};
			
			object_helper.merge_2( json, style );
			
			this.line_width = style.width;
			this.colour		= string.Utils.get_colour( style.colour );
			this.outline_colour = string.Utils.get_colour( style['outline-colour'] );
			this.key		= style.text;
			this.font_size	= style['font-size'];
			this.offset     = style.offset;
		}
*/
		
		//
		// called from the base object
		//
		protected override function get_element( x:Number, value:Object ): Element {
			return new PointBarSketch( x, value, this.offset, this.colour, this.outline_colour, this.group );
		}
	}
}