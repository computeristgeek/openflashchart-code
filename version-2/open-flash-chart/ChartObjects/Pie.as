package ChartObjects {
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
		
		public function Pie( json:Object )
		{
			this.labels = new Array();
			this.links = new Array();
			this.colours = new Array();
			
			this.style = {
				alpha: 0.5,
				'start-angle': 90,
				colour: 0x900000,
				'gradient-fill': 1,
				stroke: 1,
				colours: ["#900000", "#009000"],
				animate: 1
			}
			
			object_helper.merge_2( json, this.style );
			
			//this.labels = data['pie_labels'].split(',');
			//this.links = data['links'].split(',');
			
			for each( var colour:String in this.style.colours )
				this.colours.push( string.Utils.get_colour( colour ) );
			
			this.label_line = 10;

			this.values = json.values;
			this.make();
		}
		
		
		//
		// Pie chart make is quite different to a noraml make
		//
		public override function make():void {
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
			
			i = 0;
			for each ( val in this.values ) {
				
				var value:Number = val is Number ? val as Number : val.value;
				var slice_angle:Number = value*360/total;
				
				if( slice_angle >= 0 )
				{
					var label:String = val is Number ? val.toString() : val.text;
					
					var tmp:PieSliceContainer;
					tmp = new PieSliceContainer(
						slice_start,
						slice_angle,
						this.colours[(i % this.colours.length)],
						label,
						(this.style.animate==1) );
					
					tmp.make_tooltip( this.key );
					
					this.addChild( tmp );
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
			
			//NOTE: still have a problem here when max radius pie chart has a label in the 12o'clock position.
			//      it overwrites the title
			//var rad:Number = (Stage.width<(Stage.height-top-60)) ? Stage.width/2 : (Stage.height-top-60)/2;
			
			for ( var i:Number = 0; i < this.numChildren; i++ )
			{
				var pie:PieSliceContainer = this.getChildAt(i) as PieSliceContainer;
				pie.resize(sc,0);
			}
		}
		
		
		public override function toString():String {
			return "Pie with "+ this.numChildren +" children";
		}
	}
}