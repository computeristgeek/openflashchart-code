﻿package ChartObjects.Elements {
	import flash.display.Sprite;
	import ChartObjects.Elements.Element;
	import flash.display.BlendMode;
	
	public class PointHollow extends Element {
		
		public var radius:Number;
		private var colour:Number;
		
		public function PointHollow( index:Number, y:Object, size:Number, colour:Number ) {
			this._x = index;
			this._y = Number(y);
			this.is_tip = false;
			this.visible = true;
			
			this.radius = size;
			this.colour = colour;
			
			
			this.graphics.lineStyle( 2, 0, 1 );
			this.graphics.drawCircle( 0, 0, this.radius );

			//
			// HACK: we fill an invisible circle over
			//       the hollow circle so the mouse over
			//       event fires correctly (even when the
			//       mouse is in the hollow part)
			//
			this.graphics.lineStyle( 0, 0, 0 );
			this.graphics.beginFill(0, 0);
			this.graphics.drawCircle( 0, 0, this.radius );
			this.graphics.endFill();
			
			this.attach_events();
			
//			var s:Sprite = new Sprite();
//			s.graphics.lineStyle( 0, 0, 0 );
//			s.graphics.beginFill( 0, 0 );// this.bgColour );
//			s.graphics.drawCircle( 0, 0, this.circle_size - 1 );
			//s.blendMode = BlendMode.NORMAL;
			
			//this.addChild( s );
			
			
			//this.mask = s;

//			this.graphics.lineStyle( 0, 0, 0 );
//			this.graphics.beginFill( this.colour, 1 );// this.bgColour );
//			this.graphics.drawCircle( 0, 0, this.circle_size - 1 );

			//this.blendMode = BlendMode.ALPHA;
		}
		
		public override function set_tip( b:Boolean ):void {
			//this.visible = b;
			if( b )
				this.scaleY = this.scaleX = 1.3;
			else
				this.scaleY = this.scaleX = 1;
		}
		
		public override function make_tooltip( key:String ):void
		{
			super.make_tooltip( key );
			
			var tmp:String = this.tooltip.replace('#val#',NumberUtils.formatNumber( this._y ));
			this.tooltip = tmp;
		}
		
		//
		// is the mouse above, inside or below this point?
		//
		public override function inside( x:Number ):Boolean {
			return (x > (this.x-(this.radius/2))) && (x < (this.x+(this.radius/2)));
		}
	}
}
