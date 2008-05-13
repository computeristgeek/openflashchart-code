package ChartObjects.Elements {
	public class PieSliceContainer extends Element {
		
		//
		// this holds the slice and the text.
		// we want to rotate the slice, but not the text, so
		// this container holds both
		//
		public function PieSliceContainer( slice_start:Number, slice_angle:Number, colour:Number, label:String, animate:Boolean )
		{
			this.addChild( new PieSlice( slice_start, slice_angle, colour, animate ) );
			this.addChild( new PieLabel( label ) );
		}
		
		public function is_over():Boolean {
			var tmp:PieSlice = this.getChildAt(0) as PieSlice;
			return tmp.is_over;
		}
		
		public function get_slice():Element {
			return this.getChildAt(0) as Element;
		}
		
		//
		// because we hold the slice inside this element, pass
		// along the tooltip info:
		//
		public override function make_tooltip( key:String ):void
		{
			var tmp:PieSlice = this.getChildAt(0) as PieSlice;
			tmp.make_tooltip( key );
		}
		
		//
		// the axis makes no sense here:
		//
		public override function resize( sc:ScreenCoords, axis:Number ): void {
			var p:PieSlice = this.getChildAt(0) as PieSlice;
			p.resize( sc, 0 );

			var l:PieLabel = this.getChildAt(1) as PieLabel;
			l.move_label( p.rad + 10, p.x, p.y, p.angle+(p.slice_angle/2) );
		}
		
		public override function get_tooltip():String {
			var p:PieSlice = this.getChildAt(0) as PieSlice;
			return p.get_tooltip();
		}
	}
}