package ChartObjects {
	//import caurina.transitions.Tweener;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import ChartObjects.Elements.Element;
	import ChartObjects.Elements.PointDot;
	import string.Utils;
	import flash.display.BlendMode;
	
	public class LineHollow extends BaseLine
	{
		public function LineHollow( json:Object )
		{
			
			// may be line_dot, line_dot_2, line_dot_3 etc...
			var vals:Array = json['values'];
			
			this.line_width = json.width;
			this.colour = string.Utils.get_colour( json.colour );
			
			this.key = json.text;
			this.font_size = json['font-size'];
			this.circle_size = json['dot-size'];
			
//			this.axis = which_axis_am_i_attached_to(data, num);
			tr.ace( name );
			tr.ace( 'axis : ' + this.axis );
				
//			this.make_highlight_dot();
			this.values = this.parse_list( json['values'] );
			this.set_links( null );
//			this.set_links( data['links'+append] );
			this.make();
			
			//
			// this allows the dots to erase part of the line
			//
			this.blendMode = BlendMode.LAYER;
		}
		
		
		//
		// called from the base object
		//
		protected override function get_element( x:Number, value:Object ): ChartObjects.Elements.Element {
			return new ChartObjects.Elements.PointHollow( x, Number(value), this.circle_size, this.colour );
		}
			
	}
}