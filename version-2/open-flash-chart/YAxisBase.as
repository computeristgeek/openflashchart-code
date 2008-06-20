package {
	import flash.display.Sprite;
	import string.Utils;
	
	public class YAxisBase extends Sprite {
		protected var _width:Number=0;
		protected var minmax:MinMax;
		protected var steps:Number;
		
		protected var stroke:Number;
		protected var tick_length:Number;
		protected var colour:Number;
		public var offset:Boolean;
		protected var grid_colour:Number;
		
		protected var style:Object;
		
		// TODO: remove when we sort out the labels problem
		public var labels:Object;
		
		function YAxisBase( json:Object, minmax:MinMax, name:String, style:Object )
		{
			
			this.style = style;
			
			if( json[name] )
				object_helper.merge_2( json[name], style );
				
						
			this.colour = Utils.get_colour( style.colour );
			this.grid_colour = Utils.get_colour( style['grid-colour'] );
			this.stroke = style.stroke;
			this.tick_length = style['tick-length'];
			
			this.offset = style.offset;

			this.minmax = minmax;
			
			this._width = this.stroke + this.tick_length;// Math.max( this.ticks.small, this.ticks.big );
		}
		
		public function resize( sc:ScreenCoords ):void {
		}
		
		public function get_width():Number {
			return this._width;
		}
		
	}
}