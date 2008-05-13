package {
	import flash.text.TextField;
	
	public class YAxisLabelsRight extends YAxisLabelsBase {
		
		public function YAxisLabelsRight( m:MinMax, steps:Number, json:Object ) {
			if ( ( json['show_y2'] != undefined ) && (json['show_y2'] == 'true') )
			{
				var values:Array = make_labels( m, true, steps );
				super( values, steps, json, 'y_label_2_', 'y2');
			}
		}

		// move y axis labels to the correct x pos
		public override function resize( left:Number, box:ScreenCoords ):void {
			var maxWidth:Number = this.get_width();
			var i:Number;
			var tf:TextFieldY;
			
			for( i=0; i<this.numChildren; i++ ) {
				// right align
				tf = this.getChildAt(i) as TextFieldY;
				tf.x = left - tf.width + maxWidth;
			}
			
			// now move it to the correct Y, vertical center align
			for ( i=0; i < this.numChildren; i++ ) {
				tf = this.getChildAt(i) as TextFieldY;
				tf.y = box.get_y_from_val( tf.y_val, true ) - (tf.height/2);
			}
		}
	}
}