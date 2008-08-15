package ChartObjects {
	import ChartObjects.Elements.PieLabel;
	import flash.external.ExternalInterface;
//	import mx.transitions.Tween;
//	import mx.transitions.easing.*;

	import string.Utils;
	import ChartObjects.Elements.Element;
	import ChartObjects.Elements.PieSliceContainer;
	import global.Global;
	
	import flash.display.Sprite;

	public class Pie extends Base
	{
		
		private var labels:Array;
		private var links:Array;
		private var colours:Array;
		private var slice_alpha:Number;
		private var gradientFill:String = 'true'; //toggle gradients
		private var border_width:Number = 1;
		private var label_line:Number;
		private var easing:Function;
		
//		private var style:Css;

		public var style:Object;
		public var total_value:Number = 0;
		
		public function Pie( json:Object )
		{
			this.labels = new Array();
			this.links = new Array();
			this.colours = new Array();
			
			this.style = {
				alpha:			0.5,
				'start-angle':	90,
				colour:			0x900000,
				'gradient-fill':1,
				stroke:			1,
				colours:		["#900000", "#009000"],
				animate:		1,
				tip:			'#val# of #total#'	// #percent#
			}
			
			object_helper.merge_2( json, this.style );
			
			
			for each( var colour:String in this.style.colours )
				this.colours.push( string.Utils.get_colour( colour ) );
			
			this.label_line = 10;

			this.values = json.values;
			this.add_values();
		}
		
		
		//
		// Pie chart make is quite different to a normal make
		//
		public override function add_values():void {
//			this.Elements= new Array();
			
			//
			// Warning: this is our global singleton
			//
			var g:Global = Global.getInstance();
			
			var total:Number = 0;
			var slice_start:Number = this.style['start-angle'];
			var i:Number;
			var val:Object;
			
			for each ( val in this.values ) {
				if( val is Number )
					total += val;
				else
					total += val.value;
			}
			this.total_value = total;
			
			i = 0;
			for each ( val in this.values ) {
				
				var value:Number = val is Number ? val as Number : val.value;
				var slice_angle:Number = value*360/total;
				
				if( slice_angle >= 0 )
				{
					var label:String = val is Number ? val.toString() : val.text;
					
					var t:String = this.style.tip.replace('#total#', NumberUtils.formatNumber( this.total_value ));
					t = t.replace('#percent#', NumberUtils.formatNumber( value / this.total_value * 100 ) + '%');
				
					var tmp:PieSliceContainer = new PieSliceContainer(
						slice_start,
						slice_angle,
						value,
						t,
						this.colours[(i % this.colours.length)],
						label,
						(this.style.animate==1) );
					
					this.addChild( tmp );

					// TODO: fix this and remove
					// tmp.make_tooltip( this.key );
				}
				i++;
				slice_start += slice_angle;
			}
		}
		
		public override function inside( x:Number, y:Number ): Object {
			var shortest:Number = Number.MAX_VALUE;
			var closest:Element = null;
			
			for ( var i:Number = 0; i < this.numChildren; i++ )
			{
				var slice:PieSliceContainer = this.getChildAt(i) as PieSliceContainer;
				if( slice.is_over() )
					closest = slice.get_slice();
			}
			
			if(closest!=null) tr.ace( closest );
			
			return { element:closest, distance_x:0, distance_y:0 };
		}
		
		public override function closest( x:Number, y:Number ): Object {
			// PIE charts don't do closest to mouse tooltips
			return { Element:null, distance_x:0, distance_y:0 };
		}
		
		
		public override function resize( sc:ScreenCoords ): void {

			var radius:Number = ( Math.min( sc.width, sc.height ) / 2.0 );
		
			var pie:PieSliceContainer;
			//
			// loop over the lables and make sure they are on the screen,
			// reduce the radius until they fit
			//
			var i:Number = 0;
			var outside:Boolean;
			do
			{
				outside = false;
				
				for ( i = 0; i < this.numChildren; i++ )
				{
					pie = this.getChildAt(i) as PieSliceContainer;
					if( !pie.is_label_on_screen(sc, radius) )
						outside = true;
				}
				radius -= 1;
			}
			while ( outside && radius > 10 );
			
			for ( i = 0; i < this.numChildren; i++ )
			{
				pie = this.getChildAt(i) as PieSliceContainer;
				pie.pie_resize(sc, radius);
			}
		}
		
		
		public override function toString():String {
			return "Pie with "+ this.numChildren +" children";
		}
	}
}