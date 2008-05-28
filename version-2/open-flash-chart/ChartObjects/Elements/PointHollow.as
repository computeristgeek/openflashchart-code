package ChartObjects.Elements {
	import ChartObjects.Elements.PointDotBase;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	
	public class PointHollow extends PointDotBase {
		
		public function PointHollow( index:Number, val:Object, size:Number, colour:Number ) {
			this._x = index;
			this._y = val.val;
			this.is_tip = false;
			this.visible = true;
			
			this.radius = size;
			this.colour = colour;
			
			this.graphics.lineStyle( 0, 0, 0 );
			this.graphics.beginFill( this.colour, 1 );
			this.graphics.drawCircle( 0, 0, this.radius );
			//
			// punch out the hollow circle:
			//
			this.graphics.drawCircle( 0, 0, this.radius-val.width );
			this.graphics.endFill();
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
			
			
			var s:Sprite = new Sprite();
			s.graphics.lineStyle( 0, 0, 0 );
			s.graphics.beginFill( 0, 1 );
			s.graphics.drawCircle( 0, 0, this.radius+2 );
			s.blendMode = BlendMode.ERASE;
			
			this.line_mask = s;
		}
	}
}

