package {
	import flash.display.Sprite;
	import string.Utils;
	
	public class YAxisBase extends Sprite {
		protected var _width:Number=0;
		protected var ticks:YTicks;
		protected var minmax:MinMax;
		protected var steps:Number;
		
		protected var stroke:Number;
		protected var tick_length:Number;
		protected var colour:Number;
		public var offset:Boolean;
		protected var grid_colour:Number;
		
		// TODO: remove when we sort out the labels problem
		public var labels:Object;
		
		function YAxisBase( y_ticks:YTicks, json:Object, minmax:MinMax, name:String )
		{
			// default values
			var style:Object = {
				stroke:        2,
				'tick-length': 3,
				colour:        '#784016',
				offset:        false,
				'grid-colour': '#F5E1AA',
				'3d':          0,
				steps:         1
			};
			
			if( json[name+'_axis'] )
				object_helper.merge_2( json[name+'_axis'], style );
				
						
			this.colour = Utils.get_colour( style.colour );
			this.grid_colour = Utils.get_colour( style['grid-colour'] );
			this.stroke = style.stroke;
			this.tick_length = style['tick-length'];
			// ticks: thin and wide ticks
			this.ticks = y_ticks;
			
			this.offset = style.offset;
/*
			if( lv[name+'_grid_colour'] != undefined )
				this.grid_colour = Utils.get_colour( lv[name+'_grid_colour'] );
			else
				this.grid_colour = 0xF5E1AA;
			
			if( lv[name+'_axis_colour'] != undefined )
				this.axis_colour = Utils.get_colour( lv[name+'_axis_colour'] );
			else
				this.axis_colour = 0x784016;
*/
			this.minmax = minmax;
			this.steps = y_ticks.steps;
			
			this._width = this.stroke + this.tick_length;// Math.max( this.ticks.small, this.ticks.big );
		}
		
		public function resize( sc:ScreenCoords ):void {
		}
		
		public function get_width():Number {
			return this._width;
		}
		
	}
}