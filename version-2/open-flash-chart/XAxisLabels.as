package {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.DisplayObject;
	
	public class XAxisLabels extends Sprite {
		public var labels:Array;
		// JSON style:
		private var style:Object;
		
		//
		[Embed(systemFont='Arial', fontName='spArial', mimeType='application/x-font')]
		public static var ArialFont:Class;

		function XAxisLabels( json:Object, minmax:MinMax ) {
			
			var style:XLabelStyle = new XLabelStyle( json.x_labels );
			
			
			this.style = {
				rotate:		'diag'
			};
			
			this.labels = new Array();

			if( ( json.x_axis != null ) && ( json.x_axis.labels != null ) )
			{
				// what if there are more values than labels?
				for each( var s:String in json.x_axis.labels )
					this.add( s, style );
				
				//
				// alter the MinMax object:
				//
				minmax.set_x_max( json.x_axis.labels.length );
			}
			else
			{
				// they *may* have used x_min and x_max to set
				// the X Axis labels
				if( style.show_labels )
					for( var i:Number=minmax.x_min; i<=minmax.x_max; i++ )
						this.add( NumberUtils.formatNumber( i ), style );
			}
		}
		
		public function add( label:String, style:XLabelStyle ) : void
		{
			this.labels.push( label );
			
			var l:TextField = this.make_label(label, style);
			
			//
			// some labels will be invisible due to the step
			// value, but we want to make them all because
			// AJAX may del() a point and all the labels will
			// move around, some will become visible...
			//
			if ( ( (this.labels.length - 1) % style.step ) == 0 )
				l.visible = true;
			else
				l.visible = false;
				
			this.addChild( l );
		}
		
		public function get( i:Number ) : String
		{
			if( i<this.labels.length )
				return this.labels[i];
			else
				return '';
		}
		
		//
		// I don't think we'll use this any more
		// used to be called by various JS functions
		//
		public function del() : void
		{
			this.labels.shift();

			// delete all the MovieClips, and recreate them
			// we have to do this because of the 'step' value
			//
			// I expect there is a better way of doing this...
			//
//			for( var i:Number=0; i<this.mcs.length; i++ )
//				removeMovieClip(this.mcs[i]._name);
				
//			this.mcs = [];
			
			// now we have deleted all the labels, re-create them
			// note we use the step value so only create *some*
//			for( var i:Number=0; i<this.labels.length; i++ )
//				if( ( i % style.step ) == 0 )
//					this.show_label( this.labels[i], 'x_label_'+i );
				
		}
		
		public function make_label( label:String, style:XLabelStyle ):TextField {
			// we create the text in its own movie clip, so when
			// we rotate it, we can move the regestration point
			
			var title:TextField = new TextField();
            title.x = 0;
			title.y = 0;
			
			//this.css.parseCSS(this.style);
			//title.styleSheet = this.css;
			title.text = label;
			
			var fmt:TextFormat = new TextFormat();
			fmt.color = style.colour;
		
			if( this.style.rotate != 0 )
			{
				// so we can rotate the text
				fmt.font = "spArial";
				title.embedFonts = true;
			}
			else
			{
				fmt.font = "Verdana";
			}

			
			fmt.size = style.size;
			fmt.align = "left";
			title.setTextFormat(fmt);
			title.autoSize = "left";
			
			if( this.style.rotate == 'vertical' )
			{
				title.rotation = 270;
			}
			else if( this.style.rotate == 'diag' )
			{
				title.rotation = -45;
			}
			else
			{
				title.x = -(title.width/2);
			}
			// we don't know the x & y locations yet...
			
			return title;
		}
		
		public function count() : Number
		{
			return this.labels.length;
		}
		
		public function get_height() : Number
		{
			var height:Number = 0;
			for( var pos:Number=0; pos < this.numChildren; pos++ )
			{
				var child:DisplayObject = this.getChildAt(pos);
				height = Math.max( height, child.height );
			}
			
			return height;
		}
		
		public function resize( sc:ScreenCoords, yPos:Number ) : void//, b:Box )
		{
			var i:Number = 0;
			
			for( var pos:Number=0; pos < this.numChildren; pos++ )
			{
				var child:DisplayObject = this.getChildAt(pos);
				child.x = sc.get_x_tick_pos(pos) - (child.width / 2);
				child.y = yPos;
				
				if( this.style.rotate == 'vertical' )
					child.y += child.height;
				
				if( this.style.rotate == 'diag' )
					child.y += child.height;

//				i+=this.style.step;
			}
		}
		
		//
		// to help Box calculate the correct width:
		//
		public function last_label_width() : Number
		{
			// is the last label shown?
//			if( ( (this.labels.length-1) % style.step ) != 0 )
//				return 0;
				
			// get the width of the right most label
			// because it may stick out past the end of the graph
			// and we don't want to truncate it.
//			return this.mcs[(this.mcs.length-1)]._width;
			if ( this.numChildren > 0 )
				return this.getChildAt(this.numChildren - 1).width;
			else
				return 0;
		}
		
		// see above comments
		public function first_label_width() : Number
		{
			if( this.numChildren>0 )
				return this.getChildAt(0).width;
			else
				return 0;
		}
	}
}