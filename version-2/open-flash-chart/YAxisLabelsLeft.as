package {
	import flash.text.TextField;
	
	public class YAxisLabelsLeft extends YAxisLabelsBase {

		public function YAxisLabelsLeft( m:MinMax, steps:Number, json:Object ) {
			
			var values:Array;
			var ok:Boolean = false;
			
			if( json.y_axis )
			{
				if( json.y_axis.labels )
				{
					values = [];
					var i:Number = 0;
					for each( var s:String in json.y_axis.labels )
					{
						values.push( { val:s, pos:i } );
						i++;
					}
					
					//
					// alter the MinMax object:
					//
					m.set_y_max( values.length - 1 );
					ok = true;
				}
			}
			
			if( !ok )
			{
				values = make_labels( m, false, steps );
			}
			
			
			super(values,steps,json,'y_label_','y');
		}

		// move y axis labels to the correct x pos
		public override function resize( left:Number, sc:ScreenCoords ):void {
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
				tf.y = sc.get_y_from_val( tf.y_val, false ) - (tf.height/2);
			}
		}
	}
}