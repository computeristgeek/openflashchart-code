package charts {

	import flash.events.Event;
	import flash.events.MouseEvent;
	import charts.series.Element;
	import string.Utils;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	
	import charts.series.dots.DefaultDotProperties;
	import charts.series.dots.dot_factory;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import charts.series.dots.PointDotBase;
	
	public class Line extends Base
	{
		// JSON style:
		protected var style:Object;
		private var props:Properties;
		private var on_show:Properties;
	
		private var on_show_timer:Timer;
		private var on_show_start:Boolean;
		
		public function Line( json:Object ) {
		
			
			this.style = {
				values: 		[],
				width:			2,
				colour: 		'#3030d0',
				text: 			'',		// <-- default not display a key
				'font-size': 	12,
				tip:			'#val#',
				'line-style':	new LineStyle( json['line-style'] ),
				loop:			false,
				axis:			'left'
				// HACK: fix this (remove the merge below)
			};
			
			// hack: keep this incase the merge kills it, we'll
			// remove the merge later (and this hack)
			var tmp:Object = json['dot-style'];
			
			object_helper.merge_2( json, this.style );
			
			this.props = new DefaultDotProperties( tmp, this.style.colour, this.style.axis);
			
			//
			//
			//
			var on_show_root:Properties = new Properties( {
				type:		"pop-up",
				cascade:	3,
				delay:		0
				});
			this.on_show = new Properties(json['on-show'], on_show_root);
			this.on_show_start = true;
			//
			//
			//
			
			
			
			this.style.colour = string.Utils.get_colour( this.style.colour );
			
			this.key		= this.style.text;
			this.font_size	= this.style['font-size']
			
			this.values = this.style.values;
			this.add_values();

			//
			// this allows the dots to erase part of the line
			//
			this.blendMode = BlendMode.LAYER;
			
		}
		
		//
		// called from the Base object
		//
		protected override function get_element( index:Number, value:Object ): Element {

			if ( value is Number )
				value = { value:value };
				
			var tmp:Properties = new Properties(value, this.props);
				
			// Minor hack, replace all #key# with this key text,
			// we do this *after* the merge.
			tmp.set( 'tip', tmp.get('tip').replace('#key#', this.key) );
			
			// attach the animation bits:
			tmp.set('on-show', this.on_show);
				
			return dot_factory.make( index, tmp );
		}
		
		
		// Draw lines...
		public override function resize( sc:ScreenCoordsBase ): void {
			this.x = this.y = 0;

			this.move_dots(sc);
			
			if ( this.on_show_start )
				this.start_on_show_timer();
			else
				this.draw_line();
			
		}
		
		private function start_on_show_timer(): void {
			this.on_show_start = false;
			this.on_show_timer = new Timer(1000 / 60);	// <-- 60 frames a second = 1000ms / 60
			this.on_show_timer.addEventListener("timer", timedFunction);
			// Start the timer
			this.on_show_timer.start();
		}
		
		private function timedFunction(eventArgs:TimerEvent): void {
			if ( this.still_animating() ) {
				this.draw_line();
			}
			else {
				tr.ace( 'Line.as : on show animation stop' );
				this.on_show_timer.stop();
			}
		}
		
		private function still_animating(): Boolean {
			var i:Number;
			var tmp:Sprite;
		
			for ( i=0; i < this.numChildren; i++ ) {

				tmp = this.getChildAt(i) as Sprite;
				
				// filter out the line masks
				if( tmp is PointDotBase )
				{
					var e:PointDotBase = tmp as PointDotBase;
					if ( e.is_tweening() )
						return true;
				}
			}
			return false;
		}
		
		private function draw_line(): void {
			
			this.graphics.clear();
			this.graphics.lineStyle( this.style.width, this.style.colour );
			
			if( this.style['line-style'].style != 'solid' )
				this.dash_line();
			else
				this.solid_line();
		
		}
		
		public function move_dots( sc:ScreenCoordsBase ): void {
			
			var i:Number;
			var tmp:Sprite;
		
			for ( i=0; i < this.numChildren; i++ ) {

				tmp = this.getChildAt(i) as Sprite;
				
				// filter out the line masks
				if( tmp is Element )
				{
					var e:Element = tmp as Element;
					
					// tell the point where it is on the screen
					// we will use this info to place the tooltip
					e.resize( sc );
				}
			}
		}
		
		public function solid_line(): void {
			
			var first:Boolean = true;
			var i:Number;
			var tmp:Sprite;
			var x:Number;
			var y:Number;
			
			for ( i=0; i < this.numChildren; i++ ) {

				tmp = this.getChildAt(i) as Sprite;
				
				// filter out the line masks
				if( tmp is Element )
				{
					var e:Element = tmp as Element;
					
					if( first )
					{
						this.graphics.moveTo(e.x, e.y);
						x = e.x;
						y = e.y;
						first = false;
					}
					else
						this.graphics.lineTo(e.x, e.y);
				}
			}
			
			if ( this.style.loop ) {
				// close the line loop (radar charts)
				this.graphics.lineTo(x, y);
			}
		}
		
		// Dashed lines by Arseni
		public function dash_line(): void {
			
			var first:Boolean = true;
			
			var prev_x:int = 0;
			var prev_y:int = 0;
			var on_len_left:Number = 0;
			var off_len_left:Number = 0;
			var on_len:Number = this.style['line-style'].on; //Stroke Length
			var off_len:Number = this.style['line-style'].off; //Space Length
			var now_on:Boolean = true;
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {				
				var tmp:Sprite = this.getChildAt(i) as Sprite;				
				//
				// filter out the line masks
				//
				if( tmp is Element )
				{
					var e:Element = tmp as Element;
					
					if( first )
					{
						this.graphics.moveTo(e.x, e.y);
						on_len_left = on_len;
						off_len_left = off_len;
						now_on = true;
						first = false;
						prev_x = e.x;
						prev_y = e.y;
						var x_tmp_1:Number = prev_x;
						var x_tmp_2:Number;
						var y_tmp_1:Number = prev_y;
						var y_tmp_2:Number;						
					}
					else {
						var part_len:Number = Math.sqrt((e.x - prev_x) * (e.x - prev_x) + (e.y - prev_y) * (e.y - prev_y) );
						var sinus:Number = ((e.y - prev_y) / part_len); 
						var cosinus:Number = ((e.x - prev_x) / part_len); 
						var part_len_left:Number = part_len;
						var inside_part:Boolean = true;
							
						while (inside_part) {
							//Draw Lines And spaces one by one in loop
							if ( now_on ) {
								//Draw line
								//If whole stroke fits
								if (  on_len_left < part_len_left ) {
									//Fits - draw whole stroke
									x_tmp_2 = x_tmp_1 + on_len_left * cosinus;
									y_tmp_2 = y_tmp_1 + on_len_left * sinus;
									x_tmp_1 = x_tmp_2;
									y_tmp_1 = y_tmp_2;
									part_len_left = part_len_left - on_len_left;
									now_on = false;
									off_len_left = off_len;															
								} else {
									//Does not fit - draw part of the stroke
									x_tmp_2 = e.x;
									y_tmp_2 = e.y;
									x_tmp_1 = x_tmp_2;
									y_tmp_1 = y_tmp_2;
									on_len_left = on_len_left - part_len_left;
									inside_part = false;									
								}
								this.graphics.lineTo(x_tmp_2, y_tmp_2);								
							} else {
								//Draw space
								//If whole space fits
								if (  off_len_left < part_len_left ) {
									//Fits - draw whole space
									x_tmp_2 = x_tmp_1 + off_len_left * cosinus;
									y_tmp_2 = y_tmp_1 + off_len_left * sinus;
									x_tmp_1 = x_tmp_2;
									y_tmp_1 = y_tmp_2;
									part_len_left = part_len_left - off_len_left;								
									now_on = true;
									on_len_left = on_len;
								} else {
									//Does not fit - draw part of the space
									x_tmp_2 = e.x;									
									y_tmp_2 = e.y;									
									x_tmp_1 = x_tmp_2;
									y_tmp_1 = y_tmp_2;
									off_len_left = off_len_left - part_len_left;
									inside_part = false;																		
								}
								this.graphics.moveTo(x_tmp_2, y_tmp_2);								
							}
						}
					}
					prev_x = e.x;
					prev_y = e.y;
				}
			}
		}
		
		public override function get_colour(): Number {
			return this.style.colour;
		}
	}
}