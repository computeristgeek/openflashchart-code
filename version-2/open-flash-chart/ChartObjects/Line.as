package ChartObjects {
	//import caurina.transitions.Tweener;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import ChartObjects.Elements.Element;
	import ChartObjects.Elements.Point;
	import string.Utils;
	
	
	public class Line extends BaseLine
	{
		
		public function Line( json:Object )
		{
			var style:Object = {
				values: [],
				width: 2,
				colour: '#3030d0',
				text: '',		// <-- default not display a key
				'dot-size': 5,
				'font-size': 12
			};
			
			object_helper.merge_2( json, style );
			
			this.line_width = style.width;
			this.colour		= string.Utils.get_colour( style.colour );
			this.key		= style.text;
			this.font_size	= style['font-size'];
			this.circle_size = style['dot-size'];
				
			this.values = style.values;
			this.set_links( null );
//			this.set_links( data['links'+append] );
			this.make();
//			this.set_tooltips( lv['tool_tips_set'+name] );
		}
		

		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {
			tr.ace( x );
			tr.ace( value );
			return new ChartObjects.Elements.Point( index, Number(value), this.colour, this.circle_size );
		}
	}
}