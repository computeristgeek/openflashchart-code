package ChartObjects {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ChartObjects.Elements.Element;
	import ChartObjects.Elements.PointScatter;
	import string.Utils;
	import flash.geom.Point;
	
	public class ScatterLine extends ScatterBase
	{
		
		public function ScatterLine( json:Object )
		{
			this.style = {
				values:			[],
				width:			2,
				colour:			'#3030d0',
				text:			'',		// <-- default not display a key
				'dot-size':		5,
				'font-size':	12,
				tip:			'[#x#,#y#] #size#'
			};
			
			object_helper.merge_2( json, style );
			
			this.line_width = style.width;
			this.colour		= string.Utils.get_colour( style.colour );
			this.key		= style.text;
			this.font_size	= style['font-size'];
			this.circle_size = style['dot-size'];
			
			for each( var val:Object in style.values )
			{
				if( val['dot-size'] == null )
					val['dot-size'] = style['dot-size'];
			}
			
			this.values = style.values;

			this.add_values();
		}
		

		
		// Draw points...
		public override function resize( sc:ScreenCoords ): void {
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				var e:PointScatter = this.getChildAt(i) as PointScatter;
				e.resize( sc, this.axis );
			}
		}
		
	}
}