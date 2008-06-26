package ChartObjects {
	import ChartObjects.Elements.Element;
	import ChartObjects.Elements.PointBarGlass;
	import string.Utils;
	
	
	public class BarGlass extends BarBase {
		private var style:Object;
		
		public function BarGlass( json:Object, group:Number ) {
			
			this.style = {
				values:				[],
				colour:				'#3030d0',
				text:				'',		// <-- default not display a key
				'font-size':		12
			};
			
			object_helper.merge_2( json, style );
			
			
			super( json, group );
		}
		
		//
		// called from the base object
		//
		protected override function get_element( index:Number, value:Object ): Element {
			
			var default_style:Object = {
					colour:		this.style.colour
			};
					
			if( value is Number )
				default_style.value = value;
			else
				object_helper.merge_2( value, default_style );
				
			// our parent colour is a number, but
			// we may have our own colour:
			if( default_style.colour is String )
				default_style.colour = Utils.get_colour( default_style.colour );
				
				
			return new PointBarGlass( index, default_style, -99, this.group );
		}
	}
}