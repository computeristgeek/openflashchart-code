package ChartObjects {
	import ChartObjects.Elements.Element;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.BlendMode;
	import string.Utils;
	
	
	public class LineBase extends Base
	{
		// JSON style:
		protected var style:Object;
		
		
		public function LineBase() {}
		
		// Draw lines...
		public override function resize( sc:ScreenCoords ): void {
			this.x = this.y = 0;

			this.graphics.clear();
			this.graphics.lineStyle( this.style.width, this.style.colour );
			
			if( this.style['line-style'].style != 'solid' )
				this.dash_line(sc);
			else
				this.solid_line(sc);
		
		}
		
		public function solid_line( sc:ScreenCoords ): void {
			
			var first:Boolean = true;
			
			for ( var i:Number = 0; i < this.numChildren; i++ ) {
				
				var tmp:Sprite = this.getChildAt(i) as Sprite;
				
				//
				// filter out the line masks
				//
				if( tmp is Element )
				{
					var e:Element = tmp as Element;
					
					tr.ace(e.screen_x);
					
					// tell the point where it is on the screen
					// we will use this info to place the tooltip
					e.resize( sc, 0 );
					if( first )
					{
						this.graphics.moveTo(e.screen_x,e.screen_y);
						first = false;
					}
					else
						this.graphics.lineTo(e.screen_x, e.screen_y);
				}
			}
		}
		
		// Dashed lines by Arseni
		public function dash_line( sc:ScreenCoords ): void {
			
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
					
					// tell the point where it is on the screen
					// we will use this info to place the tooltip
					e.resize( sc, 0 );
					if( first )
					{
						this.graphics.moveTo(e.screen_x, e.screen_y);
						on_len_left = on_len;
						off_len_left = off_len;
						now_on = true;
						first = false;
						prev_x = e.screen_x;
						prev_y = e.screen_y;
						var x_tmp_1:Number = prev_x;
						var x_tmp_2:Number;
						var y_tmp_1:Number = prev_y;
						var y_tmp_2:Number;						
					}
					else {
						var part_len:Number = Math.sqrt((e.screen_x - prev_x) * (e.screen_x - prev_x) + (e.screen_y - prev_y) * (e.screen_y - prev_y) );
						var sinus:Number = ((e.screen_y - prev_y) / part_len); 
						var cosinus:Number = ((e.screen_x - prev_x) / part_len); 
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
									x_tmp_2 = e.screen_x;
									y_tmp_2 = e.screen_y;
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
									x_tmp_2 = e.screen_x;									
									y_tmp_2 = e.screen_y;									
									x_tmp_1 = x_tmp_2;
									y_tmp_1 = y_tmp_2;
									off_len_left = off_len_left - part_len_left;
									inside_part = false;																		
								}
								this.graphics.moveTo(x_tmp_2, y_tmp_2);								
							}
						}
					}
					prev_x = e.screen_x;
					prev_y = e.screen_y;
				}
			}
		}
		
		protected function merge_us_with_value_object( value:Object ): Object {
			
			var default_style:Object = {
				'dot-size':		this.style['dot-size'],
				colour:			this.style.colour,
				'halo-size':	this.style['halo-size'],
				tip:			this.style.tip
			}
			
			if( value is Number )
				default_style.value = value;
			else
				object_helper.merge_2( value, default_style );
			
			// our parent colour is a number, but
			// we may have our own colour:
			if( default_style.colour is String )
				default_style.colour = Utils.get_colour( default_style.colour );
				
			// Minor hack, replace all #key# with this LINEs key text:
			default_style.tip = default_style.tip.replace('#key#', this.style.text);
			
			return default_style;
		}
		
		public override function get_colour(): Number {
			return this.style.colour;
		}
		
		//
		// TODO this is so wrong. We need to query all the Elements
		//      for thier X value
		//
		public override function get_max_x_value():Number {
			
			var c:Number = 0;
			//
			// count the non-mask items:
			//
			for ( var i:Number = 0; i < this.numChildren; i++ )
				if( this.getChildAt(i) is Element )
					c++;
	
			return c;
		}
	}
}