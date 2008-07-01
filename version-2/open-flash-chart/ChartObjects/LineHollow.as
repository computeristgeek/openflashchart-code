package ChartObjects {
	//import caurina.transitions.Tweener;

	import flash.display.Sprite;
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
			//
			// so the mask child can punch a hole through the line
			//
			this.blendMode = BlendMode.LAYER;
			
			this.style = {
				values: 		[],
				width:			2,
				colour:			'#80a033',
				text:			'',
				'font-size':	10,
				'dot-size':		6,
				'halo-size':	2
			};
			
			this.style = object_helper.merge( json, this.style );
			
			this.style.colour = string.Utils.get_colour( this.style.colour );
			this.values = style.values;
			
			this.key = style.text;
			this.font_size = style['font-size'];
			
			
//			this.axis = which_axis_am_i_attached_to(data, num);
//			tr.ace( name );
//			tr.ace( 'axis : ' + this.axis );

			this.make();
			
			
			
			//
			// this allows the dots to erase part of the line
			//
//			this.blendMode = BlendMode.LAYER;
			//this.blendMode = BlendMode.ALPHA;
			
			

		}
		
		//
		// called from the base object
		//
		protected override function get_element( x:Number, value:Object ): ChartObjects.Elements.Element {
			
			var style:Object = {
				value:			Number(value),
				'dot-size':		this.style['dot-size'],
				colour:			this.style.colour,
				'halo-size':	this.style['halo-size'],
				width:			this.style.width
			}
			
			return new ChartObjects.Elements.PointHollow( x, style );
		}
			
	}
}