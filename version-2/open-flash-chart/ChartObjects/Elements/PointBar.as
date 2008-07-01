package ChartObjects.Elements {
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.flashdevelop.utils.FlashConnect;
	
	public class PointBar extends PointBarBase {
	
		public function PointBar( index:Number, style:Object, group:Number ) {
			
			super(index, style, style.colour, group);
			
			//
			// TODO: hack!!
			//
			this.tooltip_template = style.tip;
			//
			//
			//
		}
		
		
		//
		// dirty hack, this will be moved to element when all the objects
		// support tooltips correctly
		//
		public override function make_tooltip( key:String ):void {
		
			var tmp:String = this.tooltip_template;
			
//			if ( tmp == "_default" ) { tmp = this.tooltip_template; }
			tmp = tmp.replace('#top#', NumberUtils.formatNumber( this.top ));
			tmp = tmp.replace('#bottom#', NumberUtils.formatNumber( this.bottom ));
			tmp = tmp.replace('#val#', NumberUtils.formatNumber( this.top - this.bottom ));
			this.tooltip = tmp;
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
		
	}
}