package ChartObjects.Elements {
	public class PieSliceContainer extends Element {
		
		private var TO_RADIANS:Number = Math.PI / 180;

		//
		// this holds the slice and the text.
		// we want to rotate the slice, but not the text, so
		// this container holds both
		//
		public function PieSliceContainer( slice_start:Number, slice_angle:Number, value:Number, tip:String, colour:Number, label:String, animate:Boolean )
		{
			this.addChild( new PieSlice( slice_start, slice_angle, value, tip, colour, animate ) );
			this.addChild( new PieLabel( label ) );
		}
		
		public function is_over():Boolean {
			var tmp:PieSlice = this.getChildAt(0) as PieSlice;
			return tmp.is_over;
		}
		
		public function get_slice():Element {
			return this.getChildAt(0) as Element;
		}
		
		public function get_label():PieLabel {
			return this.getChildAt(1) as PieLabel;
		}
		
		//
		// because we hold the slice inside this element, pass
		// along the tooltip info:
		//
//		public override function make_tooltip( key:String ):void
//		{
//			var tmp:PieSlice = this.getChildAt(0) as PieSlice;
//			tmp.make_tooltip( key );
//		}
		
		//
		// the axis makes no sense here, let's override with null and write our own.
		//
		public override function resize( sc:ScreenCoords, axis:Number ): void { }
		
		public function is_label_on_screen( sc:ScreenCoords, slice_radius:Number ): Boolean {
			
			var p:PieSlice = this.getChildAt(0) as PieSlice;
			var l:PieLabel = this.getChildAt(1) as PieLabel;
			
			return l.move_label( slice_radius + 10, sc.get_center_x(), sc.get_center_y(), p.angle+(p.slice_angle/2) );
		}
		
		public function pie_resize( sc:ScreenCoords, slice_radius:Number ): void {
			
			// the label is in the correct position -- see is_label_on_screen()
			var p:PieSlice = this.getChildAt(0) as PieSlice;
			p.pie_resize(sc, slice_radius);
		}
		
		public override function get_tooltip():String {
			var p:PieSlice = this.getChildAt(0) as PieSlice;
			return p.get_tooltip();
		}
	}
}