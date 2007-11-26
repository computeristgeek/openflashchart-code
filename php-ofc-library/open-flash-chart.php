<?php
class graph
{
	function graph()
	{
		$this->data = array();
		$this->links = array();
		$this->width = 250;
		$this->height = 200;
		$this->base = 'js/';
		$this->x_labels = array();
		$this->y_min = '';
		$this->y_max = '';
		$this->x_min = '';
		$this->x_max = '';
		$this->y_steps = '';
		$this->title = '';
		$this->title_style = '';
		$this->occurence = 0;

		$this->x_tick_size = -1;

		$this->y2_max = '';
		$this->y2_min = '';

		// GRID styles:
		$this->x_axis_colour = '';
		$this->x_axis_3d = '';
		$this->x_grid_colour = '';
		$this->x_axis_steps = 1;
		$this->y_axis_colour = '';
		$this->y_grid_colour = '';
		$this->y2_axis_colour = '';
		
		// AXIS LABEL styles:         
		$this->x_label_style = '';
		$this->y_label_style = '';
		$this->y_label_style_right = '';
	
	
		// AXIS LEGEND styles:
		$this->x_legend = '';
		$this->x_legend_size = 20;
		$this->x_legend_colour = '#000000';
	
		$this->y_legend = '';
		$this->y_legend_right = '';
		//$this->y_legend_size = 20;
		//$this->y_legend_colour = '#000000';
	
		$this->lines = array();
		$this->line_default['type'] = 'line';
		$this->line_default['values'] = '3,#87421F';
		$this->js_line_default = 'so.addVariable("line","3,#87421F");';
		
		$this->bg_colour = '';
		$this->bg_image = '';
	
		$this->inner_bg_colour = '';
		$this->inner_bg_colour_2 = '';
		$this->inner_bg_angle = '';
		
		// PIE chart ------------
		$this->pie = '';
		$this->pie_values = '';
		$this->pie_colours = '';
		$this->pie_labels = '';
		
		$this->tool_tip = '';
		
		// which data lines are attached to the
		// right Y axis?
		$this->y2_lines = array();
		
		//
		// set some default value incase the user forgets
		// to set them, so at least they see *something*
		// even is it is only the axis and some ticks
		//
		$this->set_y_min( 0 );
		$this->set_y_max( 20 );
		$this->set_x_axis_steps( 1 );
		$this->y_label_steps( 5 );
	}

	function increment_occurence()
	{
		$this->occurence++;
	}

	function next_line()
	{
		$line_num = '';
		if( count( $this->lines ) > 0 )
			$line_num = '_'. (count( $this->lines )+1);

		return $line_num;
	}
	
	// escape commas (,)
	function esc( $text )
	{
		// we replace the comma so it is not URL escaped
		// if it is, flash just thinks it is a comma
		// which is no good if we are splitting the
		// string on commas.
		$tmp = str_replace( ',', '#comma#', $text );
		// now we urlescape all dodgy characters (like & % $ etc..)
		return urlencode( $tmp );
	}

	function format_output($output_type,$function,$values)
	{
		if($output_type == 'js')
		{
			$tmp = 'so.addVariable("'. $function .'","'. $values . '");';
		}
		else
		{
			$tmp = '&'. $function .'='. $values .'&';
		}

		return $tmp;
	}
		
	function set_data( $a )
	{
		$this->data[] = implode(',',$a);
	}

	function set_tool_tip( $tip )
	{
		$this->tool_tip = $this->esc( $tip );
	}

	function set_x_labels( $a )
	{
		$this->x_labels = $a;
	}

	function set_x_label_style( $size, $colour='', $orientation=0, $step=-1, $grid_colour='' )
	{
		$this->x_label_style = $size;
		
		if( strlen( $colour ) > 0 )
			$this->x_label_style .= ','. $colour;

		if( $orientation > -1 )
			$this->x_label_style .= ','. $orientation;

		if( $step > 0 )
			$this->x_label_style .= ','. $step;

		if( strlen( $grid_colour ) > 0 )
			$this->x_label_style .= ','. $grid_colour;
	}

	function set_bg_colour( $colour )
	{
		$this->bg_colour = $colour;
	}

	function set_bg_image( $url, $x='center', $y='center' )
	{
		$this->bg_image = $url;
		$this->bg_image_x = $x;
		$this->bg_image_y = $y;
	}

	function attach_to_y_right_axis( $data_number )
	{
		$this->y2_lines[] = $data_number;
	}
	
	function set_inner_background( $col, $col2='', $angle=-1 )
	{
		$this->inner_bg_colour = $col;
		
		if( strlen($col2) > 0 )
			$this->inner_bg_colour_2 = $col2;
		
		if( $angle != -1 )
			$this->inner_bg_angle = $angle;
	}

	function _set_y_label_style( $size, $colour )
	{
		$tmp = $size;
		
		if( strlen( $colour ) > 0 )
			$tmp .= ','. $colour;
		return $tmp;
	}
	
	function set_y_label_style( $size, $colour='' )
	{
		$this->y_label_style = $this->_set_y_label_style( $size, $colour );
	}
	
	function set_y_right_label_style( $size, $colour='' )
	{
		$this->y_label_style_right = $this->_set_y_label_style( $size, $colour );
	}

	function set_x_max( $max )
	{
		$this->x_max = intval( $max );
	}

	function set_x_min( $min )
	{
		$this->x_min = intval( $min );
	}
	
	function set_y_max( $max )
	{
		$this->y_max = intval( $max );
	}

	function set_y_min( $min )
	{
		$this->y_min = intval( $min );
	}

	function set_y_right_max( $max )
	{
		$this->y2_max = intval($max);
	}

	function set_y_right_min( $min )
	{
		$this->y2_min = intval($min);
	}

	function y_label_steps( $val )
	{
		 $this->y_steps = intval( $val );
	}
	
	function title( $title, $style='' )
	{
		 $this->title = $this->esc( $title );
		 if( strlen( $style ) > 0 )
				 $this->title_style = $style;
	}

	function set_x_legend( $text, $size=-1, $colour='' )
	{
		$this->x_legend = $this->esc( $text );
		if( $size > -1 )
			$this->x_legend_size = $size;
		
		if( strlen( $colour )>0 )
			$this->x_legend_colour = $colour;
	}

	function set_x_tick_size( $size )
	{
		if( $size > 0 )
				$this->x_tick_size = $size;
	}
	
	function set_x_axis_steps( $steps )
	{
		if ( $steps > 0 )
			$this->x_axis_steps = $steps;
	}

	function set_x_axis_3d( $size )
	{
		if( $size > 0 )
			$this->x_axis_3d = intval($size);
	}
	
	// PRIVATE METHOD
	function _set_y_legend( $text, $size, $colour )
	{
		$tmp = $text;
	
		if( $size > -1 )
			$tmp .= ','. $size;

		if( strlen( $colour )>0 )
			$tmp .= ','. $colour;

		return $tmp;
		}

	function set_y_legend( $text, $size=-1, $colour='' )
	{
		$this->y_legend = $this->_set_y_legend( $text, $size, $colour );
	}
	
	function set_y_right_legend( $text, $size=-1, $colour='' )
	{
		$this->y_legend_right = $this->_set_y_legend( $text, $size, $colour );
	}

	function x_axis_colour( $axis, $grid='' )
	{
		$this->x_axis_colour = $axis;
		$this->x_grid_colour = $grid;
	}

	function y_axis_colour( $axis, $grid='' )
	{
		$this->y_axis_colour = $axis;

		if( strlen( $grid ) > 0 )
			$this->y_grid_colour = $grid;
	}

	function y_right_axis_colour( $colour )
	{
		 $this->y2_axis_colour = $colour;
	}

	function line( $width, $colour='', $text='', $size=-1, $circles=-1 )
	{
		$type = 'line'. $this->next_line();

		$description = '';
		if( $width > 0 )
		{
			$description .= $width;
			$description .= ','. $colour;
		}

		if( strlen( $text ) > 0 )
		{
			$description.= ','. $text;
			$description .= ','. $size;
		}

		if( $circles > 0 ) 
			$description .= ','. $circles;

		$this->lines[$type] = $description;
	}

	function line_dot( $width, $dot_size, $colour, $text='', $font_size='' )
	{
		$type = 'line_dot'. $this->next_line();

		$description = "$width,$colour,$text";

		if( strlen( $font_size ) > 0 )
			$description .= ",$font_size,$dot_size";

		$this->lines[$type] = $description;
	}

	function line_hollow( $width, $dot_size, $colour, $text='', $font_size='' )
	{
		$type = 'line_hollow'. $this->next_line();

		$description = "$width,$colour,$text";

		if( strlen( $font_size ) > 0 )
			$description .= ",$font_size,$dot_size";

		$this->lines[$type] = $description;
	}

	function area_hollow( $width, $dot_size, $colour, $alpha, $text='', $font_size='', $fill_colour='' )
	{
		$type = 'area_hollow'. $this->next_line();

		$description = "$width,$dot_size,$colour,$alpha";

		if( strlen( $text ) > 0 )
			$description .= ",$text,$font_size";
	
		if( strlen( $fill_colour ) > 0 )
			$description .= ','. $fill_colour;

		$this->lines[$type] = $description;
	}


	function bar( $alpha, $colour='', $text='', $size=-1 )
	{
		$type = 'bar'. $this->next_line();

		$description = $alpha .','. $colour .','. $text .','. $size;

		$this->lines[$type] = $description;
	}

	function bar_filled( $alpha, $colour, $colour_outline, $text='', $size=-1 )
	{
		$type = 'filled_bar'. $this->next_line();

		$description = "$alpha,$colour,$colour_outline,$text,$size";

		$this->lines[$type] = $description;
	}

	function bar_sketch( $alpha, $offset, $colour, $colour_outline, $text='', $size=-1 )
	{
		$type = 'bar_sketch'. $this->next_line();

		$description = "$alpha,$offset,$colour,$colour_outline,$text,$size";

		$this->lines[$type] = $description;
	}
	
	function bar_3D( $alpha, $colour='', $text='', $size=-1 )
	{
		$type = 'bar_3d'. $this->next_line();

		$description = $alpha .','. $colour .','. $text .','. $size;

		$this->lines[$type] = $description;
	}
	
	function bar_glass( $alpha, $colour, $outline_colour, $text='', $size=-1 )
	{
		$type = 'bar_glass'. $this->next_line();

		$description = $alpha .','. $colour .','. $outline_colour .','. $text .','. $size;

		$this->lines[$type] = $description;
	}

	function bar_fade( $alpha, $colour='', $text='', $size=-1 )
	{
		$type = 'bar_fade'. $this->next_line();

		$description = $alpha .','. $colour .','. $text .','. $size;

		$this->lines[$type] = $description;
	}
	
	function candle( $data, $alpha, $line_width, $colour, $text='', $size=-1 )
	{
		$type = 'candle'. $this->next_line();

		$description = $alpha .','. $line_width .','. $colour .','. $text .','. $size;

		$this->lines[$type] = $description;
		
		$a = array();
		foreach( $data as $can )
			$a[] = $can->toString();
			
		$this->data[] = implode(',',$a);
	}
	
	function hlc( $data, $alpha, $line_width, $colour, $text='', $size=-1 )
	{
		$type = 'hlc'. $this->next_line();

		$description = $alpha .','. $line_width .','. $colour .','. $text .','. $size;

		$this->lines[$type] = $description;
		
		$a = array();
		foreach( $data as $can )
			$a[] = $can->toString();
			
		$this->data[] = implode(',',$a);
	}

	function scatter( $data, $line_width, $colour, $text='', $size=-1 )
	{
		$type = 'scatter'. $this->next_line();

		$description = $line_width .','. $colour .','. $text .','. $size;

		$this->lines[$type] = $description;
		
		$a = array();
		foreach( $data as $can )
			$a[] = $can->toString();
			
		$this->data[] = implode(',',$a);
	}


	//
	// Patch by, Jeremy Miller (14th Nov, 2007)
	//
	function pie( $alpha, $line_colour, $label_colour, $gradient = true, $border_size = false )
	{
		$this->pie = $alpha.','.$line_colour.','.$label_colour;
		if( !$gradient )
		{
			$this->pie .= ','.!$gradient;
		}
		if ($border_size)
		{
			if ($gradient === false)
			{
				$this->pie .= ',';
			}
			$this->pie .= ','.$border_size;
		}
	}

	function pie_values( $values, $labels, $links )
	{
		$this->pie_values = implode(',',$values);
		$this->pie_labels = implode(',',$labels);
		$this->pie_links  = implode(",",$links);
	}


	function pie_slice_colours( $colours )
	{
		$this->pie_colours = implode(',',$colours);
	}
	
	function set_width( $width )
	{
		$this->width = $width;
	}
	
	function set_height( $height )
	{
		$this->height = $height;
	}
	
	function set_base( $base='js/' )
	{
		$this->base = $base;
	}
	
	function render($output_type = '')
	{
		$tmp = array();

		if($output_type == 'js')
		{
			$this->increment_occurence();
		
			$tmp[] = '<div id="my_chart' . $this->occurence . '"></div>';
			$tmp[] = '<script type="text/javascript" src="' . $this->base . 'swfobject.js"></script>';
			$tmp[] = '<script type="text/javascript">';
			$tmp[] = 'var so = new SWFObject("open-flash-chart.swf", "ofc", "'. $this->width . '", "' . $this->height . '", "9", "#FFFFFF");';
			$tmp[] = 'so.addVariable("variables","true");';
		}

		if( strlen( $this->title ) > 0 )
		{
			$values = $this->title;
			$values .= ','. $this->title_style;
			$tmp[] = $this->format_output($output_type,'title',$values);
		}

		if( strlen( $this->x_legend ) > 0 )
		{
			$values = $this->x_legend;
			$values .= ','. $this->x_legend_size;
			$values .= ','. $this->x_legend_colour;
			$tmp[] = $this->format_output($output_type,'x_legend',$values);
		}
	
		if( strlen( $this->x_label_style ) > 0 )
			$tmp[] = $this->format_output($output_type,'x_label_style',$this->x_label_style);
	
		if( $this->x_tick_size > 0 )
			$tmp[] = $this->format_output($output_type,'x_ticks',$this->x_tick_size);

		if( $this->x_axis_steps > 0 )
			$tmp[] = $this->format_output($output_type,'x_axis_steps',$this->x_axis_steps);

		if( strlen( $this->x_axis_3d ) > 0 )
			$tmp[] = $this->format_output($output_type,'x_axis_3d',$this->x_axis_3d);
		
		if( strlen( $this->y_legend ) > 0 )
			$tmp[] = $this->format_output($output_type,'y_legend',$this->y_legend);
		
		if( strlen( $this->y_legend_right ) > 0 )
			$tmp[] = $this->format_output($output_type,'y2_legend',$this->y_legend_right);

		if( strlen( $this->y_label_style ) > 0 )
			$tmp[] = $this->format_output($output_type,'y_label_style',$this->y_label_style);

		$values = '5,10,'. $this->y_steps;
		$tmp[] = $this->format_output($output_type,'y_ticks',$values);

		if( count( $this->lines ) == 0 )
		{
			$tmp[] = $this->format_output($output_type,$this->line_default['type'],$this->line_default['values']);	
		}
		else
		{
			foreach( $this->lines as $type=>$description )
				$tmp[] = $this->format_output($output_type,$type,$description);	
		}
	
		$num = 1;
		foreach( $this->data as $data )
		{
			if( $num==1 )
			{
				$tmp[] = $this->format_output($output_type, 'values', $data);
			}
			else
			{
				$tmp[] = $this->format_output($output_type,'values_'. $num, $data);
			}
		
			$num++;
		}

		if( count( $this->y2_lines ) > 0 )
		{
			$tmp[] = $this->format_output($output_type,'y2_lines',implode( ',', $this->y2_lines ));
			//
			// Should this be an option? I think so...
			//
			$tmp[] = $this->format_output($output_type,'show_y2','true');
		}

		if( count( $this->x_labels ) > 0 )
			$tmp[] = $this->format_output($output_type,'x_labels',implode(',',$this->x_labels));
		else
		{
			if( strlen($this->x_min) > 0 )
				$tmp[] = $this->format_output($output_type,'x_min',$this->x_min);
				
			if( strlen($this->x_max) > 0 )
				$tmp[] = $this->format_output($output_type,'x_max',$this->x_max);			
		}
		
		$tmp[] = $this->format_output($output_type,'y_min',$this->y_min);
		$tmp[] = $this->format_output($output_type,'y_max',$this->y_max);

		if( strlen($this->y2_min) > 0 )
			$tmp[] = $this->format_output($output_type,'y2_min',$this->y2_min);
			
		if( strlen($this->y2_max) > 0 )
			$tmp[] = $this->format_output($output_type,'y2_max',$this->y2_max);
		
		if( strlen( $this->bg_colour ) > 0 )
			$tmp[] = $this->format_output($output_type,'bg_colour',$this->bg_colour);

		if( strlen( $this->bg_image ) > 0 )
		{
			$tmp[] = $this->format_output($output_type,'bg_image',$this->bg_image);
			$tmp[] = $this->format_output($output_type,'bg_image_x',$this->bg_image_x);
			$tmp[] = $this->format_output($output_type,'bg_image_y',$this->bg_image_y);
		}

		if( strlen( $this->x_axis_colour ) > 0 )
		{
			$tmp[] = $this->format_output($output_type,'x_axis_colour',$this->x_axis_colour);
			$tmp[] = $this->format_output($output_type,'x_grid_colour',$this->x_grid_colour);
		}

		if( strlen( $this->y_axis_colour ) > 0 )
			$tmp[] = $this->format_output($output_type,'y_axis_colour',$this->y_axis_colour);

		if( strlen( $this->y_grid_colour ) > 0 )
			$tmp[] = $this->format_output($output_type,'y_grid_colour',$this->y_grid_colour);
  
		if( strlen( $this->y2_axis_colour ) > 0 )
			$tmp[] = $this->format_output($output_type,'y2_axis_colour',$this->y2_axis_colour);

		if( strlen( $this->inner_bg_colour ) > 0 )
		{
			$values = $this->inner_bg_colour;
			if( strlen( $this->inner_bg_colour_2 ) > 0 )
			{
				$values .= ','. $this->inner_bg_colour_2;
				$values .= ','. $this->inner_bg_angle;
			}
			$tmp[] = $this->format_output($output_type,'inner_background',$values);
		}
	
		if( strlen( $this->pie ) > 0 )
		{
			$tmp[] = $this->format_output($output_type,'pie',$this->pie);
			$tmp[] = $this->format_output($output_type,'values',$this->pie_values);
			$tmp[] = $this->format_output($output_type,'pie_labels',$this->pie_labels);
			$tmp[] = $this->format_output($output_type,'colours',$this->pie_colours);
			$tmp[] = $this->format_output($output_type,'links',$this->pie_links);
		}

		if( strlen( $this->tool_tip ) > 0 )
			$tmp[] = $this->format_output($output_type,'tool_tip',$this->tool_tip);

		if($output_type == 'js')
		{
			$tmp[] = 'so.write("my_chart' . $this->occurence . '");';
			$tmp[] = '</script>';
		}

		return implode("\r\n",$tmp);
	}
}

class candle
{
	var $out;
	
	function candle( $high, $open, $close, $low )
	{
		$this->out = array();
		$this->out[] = $high;
		$this->out[] = $open;
		$this->out[] = $close;
		$this->out[] = $low;
	}
	
	function toString()
	{
		return '['. implode( ',', $this->out ) .']';
	}
}

class hlc
{
	var $out;
	
	function hlc( $high, $low, $close )
	{
		$this->out = array();
		$this->out[] = $high;
		$this->out[] = $low;
		$this->out[] = $close;
	}
	
	function toString()
	{
		return '['. implode( ',', $this->out ) .']';
	}
}

class point
{
	var $out;
	
	function point( $x, $y, $size_px )
	{
		$this->out = array();
		$this->out[] = $x;
		$this->out[] = $y;
		$this->out[] = $size_px;
	}
	
	function toString()
	{
		return '['. implode( ',', $this->out ) .']';
	}
}

?>
