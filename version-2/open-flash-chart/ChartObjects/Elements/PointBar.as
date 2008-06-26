package ChartObjects.Elements {
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.flashdevelop.utils.FlashConnect;
	
	public class PointBar extends PointBarBase {
	
		public function PointBar( index:Number, value:Object, colour:Number, group:Number ) {
			super(index, value, colour, group);
		}
		
		public override function resize( sc:ScreenCoords, axis:Number ):void {
			
			var h:Object = this.resize_helper( sc, axis );
			
			this.graphics.clear();
			this.graphics.beginFill( this.colour, 1.0 );
			this.graphics.moveTo( 0, 0 );
			this.graphics.lineTo( h.width, 0 );
			this.graphics.lineTo( h.width, h.height );
			this.graphics.lineTo( 0, h.height );
			this.graphics.lineTo( 0, 0 );
			this.graphics.endFill();
		}
		
		public override function make_tooltip( key:String ):void {
			
			super.make_tooltip( key );
			this.tooltip = this.tooltip.replace('#val#',NumberUtils.formatNumber( this.top ));
		}
	}
}