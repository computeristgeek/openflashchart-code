package open_flash_chart;

use strict;

package graph;

sub new() {
  # setup object constructor
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;  #need to bless early so you can use methods in constructor

  $self->{data} = [];
  $self->{links} = [];
  $self->{width} = 250;
  $self->{height} = 200;
  $self->{base} = 'js/';
  $self->{x_labels} = [];
  $self->{y_min} = '';
  $self->{y_max} = '';
  $self->{x_min} = '';
  $self->{x_max} = '';
  $self->{y_steps} = '';
  $self->{title} = '';
  $self->{title_style} = '';
  $self->{occurence} = 0;

  $self->{x_tick_size} = -1;

  $self->{y2_max} = '';
  $self->{y2_min} = '';

  # GRID styles:
  $self->{x_axis_colour} = '';
  $self->{x_axis_3d} = '';
  $self->{x_grid_colour} = '';
  $self->{x_axis_steps} = 1;
  $self->{y_axis_colour} = '';
  $self->{y_grid_colour} = '';
  $self->{y2_axis_colour} = '';

  # AXIS LABEL styles:
  $self->{x_label_style} = '';
  $self->{y_label_style} = '';
  $self->{y_label_style_right} = '';


  # AXIS LEGEND styles:
  $self->{x_legend} = '';
  $self->{x_legend_size} = 20;
  $self->{x_legend_colour} = '#000000';

  $self->{y_legend} = '';
  $self->{y_legend_right} = '';
  #$self->{y_legend_size = 20;
  #$self->{y_legend_colour = '#000000';

  $self->{lines} = [];
  $self->{line_default} = {};
  $self->{line_default}->{type} = 'line';
  $self->{line_default}->{values} = '3,#87421F';
  $self->{js_line_default} = 'so.addVariable("line","3,#87421F");';

  $self->{bg_colour} = '';
  $self->{bg_image} = '';

  $self->{inner_bg_colour} = '';
  $self->{inner_bg_colour_2} = '';
  $self->{inner_bg_angle} = '';

  # PIE chart ------------
  $self->{pie} = '';
  $self->{pie_values} = '';
  $self->{pie_colours} = '';
  $self->{pie_labels} = '';

  $self->{tool_tip} = '';

  # which data lines are attached to the
  # right Y axis?
  $self->{y2_lines} = [];

  #
  # set some default value incase the user forgets
  # to set them, so at least they see *something*
  # even is it is only the axis and some ticks
  #
  $self->set_y_min( 0 );
  $self->set_y_max( 20 );
  $self->set_x_axis_steps( 1 );
  $self->y_label_steps( 5 );

  return $self;
}

sub increment_occurence() {
  my ($self) = @_;
  $self->{occurence}++;
}

sub next_line() {
  my ($self) = @_;
  my $line_num = '';
  my $line_count = scalar( @{$self->{lines}} );
  if( $line_count > 0 ) {
    $line_num = '_'. ($line_count+1);
  }

  return $line_num;
}

# escape commas (,)
sub esc() {
  my ($self, $text) = @_;
  # we replace the comma so it is not URL escaped
  # if it is, flash just thinks it is a comma
  # which is no good if we are splitting the
  # string on commas.
  $text =~ s/,/#comma#/g;
  # now we urlescape all dodgy characters (like & % $ etc..)
  return url_escape( $text );
}

sub format_output() {
  my ($self, $output_type, $function, $values) = @_;
  my $tmp='';
  if($output_type eq 'js') {
    $tmp = 'so.addVariable("'. $function .'","'. $values . '");';
  } else {
    $tmp = '&'. $function .'='. $values .'&';
  }
  return $tmp;
}

# set_data expects ->(array reference)
sub set_data() {
  my ($self, $a) = @_;
  push(@{$self->{data}}, join(',', @$a));
}

# set_links expects ->(array reference)
sub set_links() {
  my ($self, $a) = @_;
  push(@{$self->{links}}, join(',', @$a));
}

sub set_tool_tip() {
  my ($self, $tip) = @_;
  $self->{tool_tip} = $self->esc( $tip );
}

sub set_x_labels() {
  my ($self, $a) = @_;
  $self->{x_labels} = $a;
}

sub set_x_label_style() {
  my ($self, $size, $colour, $orientation, $step, $grid_colour) = @_;
  $colour = '' if !defined($colour);
  $orientation = 0 if !defined($orientation);
  $step = -1 if !defined($step);
  $grid_colour = '' if !defined($grid_colour);

  $self->{x_label_style} = $size;

  if( $colour ne '' ) {
    $self->{x_label_style} .= ','. $colour;
  }

  if( $orientation > -1 ) {
    $self->{x_label_style} .= ','. $orientation;
  }

  if( $step > 0 ) {
    $self->{x_label_style} .= ','. $step;
  }

  if( $grid_colour ne '' ) {
    $self->{x_label_style} .= ','. $grid_colour;
  }
}

sub set_bg_colour() {
  my ($self, $colour) = @_;
  $self->{bg_colour} = $colour;
}

sub set_bg_image() {
  my ($self, $url, $x, $y) = @_;
  $x = 'center' if !defined($x);
  $y = 'center' if !defined($y);
  $self->{bg_image} = $url;
  $self->{bg_image_x} = $x;
  $self->{bg_image_y} = $y;
}

sub attach_to_y_right_axis() {
  my ($self, $data_number) = @_;
  push(@{$self->{y2_lines}}, $data_number);
}

sub set_inner_background() {
  my ($self, $col, $col2, $angle) = @_;
  $col2 = '' if !defined($col2);
  $angle = -1 if !defined($angle);
  $self->{inner_bg_colour} = $col;

  if( $col2 ne '' ) {
    $self->{inner_bg_colour_2} = $col2;
  }

  if( $angle != -1 ) {
    $self->{inner_bg_angle} = $angle;
  }
}

sub _set_y_label_style() {
  my ($self, $size, $colour) = @_;
  $colour = '' if !defined($colour);
  my $tmp = $size;

  if( $colour ne '' ) {
    $tmp .= ','. $colour;
  }
  return $tmp;
}

sub set_y_label_style() {
  my ($self, $size, $colour) = @_;
  $colour = '' if !defined($colour);

  $self->{y_label_style} = $self->_set_y_label_style( $size, $colour );
}

sub set_y_right_label_style() {
  my ($self, $size, $colour) = @_;
  $colour = '' if !defined($colour);
  $self->{y_label_style_right} = $self->_set_y_label_style( $size, $colour );
}

sub set_x_max() {
  my ($self, $max) = @_;
  $self->{x_max} = int( $max );
}

sub set_x_min() {
  my ($self, $min) = @_;
  $self->{x_min} = int( $min );
}

sub set_y_max() {
  my ($self, $max) = @_;
  $self->{y_max} = int( $max );
}

sub set_y_min() {
  my ($self, $min) = @_;
  $self->{y_min} = int( $min );
}

sub set_y_right_max() {
  my ($self, $max) = @_;
  $self->{y2_max} = int( $max );
}

sub set_y_right_min() {
  my ($self, $min) = @_;
  $self->{y2_min} = int( $min );
}

sub y_label_steps() {
  my ($self, $val) = @_;
  $self->{y_steps} = int( $val );
}

sub title() {
  my ($self, $title, $style) = @_;
  $style = '' if !defined($style);
  $self->{title} = $self->esc( $title );
  if( $style ne '' ) {
    $self->{title_style} = $style;
  }
}

sub set_x_legend() {
  my ($self, $text, $size, $colour) = @_;
  $size = -1 if !defined($size);
  $colour = '' if !defined($colour);

  $self->{x_legend} = $self->esc( $text );
  if( $size > -1 ) {
    $self->{x_legend_size} = $size;
  }

  if( $colour ne '' ) {
    $self->{x_legend_colour} = $colour;
  }
}

sub set_x_tick_size() {
  my ($self, $size) = @_;
  if( $size > 0 ) {
    $self->{x_tick_size} = $size;
  }
}

sub set_x_axis_steps() {
  my ($self, $steps) = @_;
  if ( $steps > 0 ) {
    $self->{x_axis_steps} = $steps;
  }
}

sub set_x_axis_3d() {
  my ($self, $size) = @_;
  if( $size > 0 ) {
    $self->{x_axis_3d} = int($size);
  }
}

# PRIVATE METHOD
sub _set_y_legend() {
  my ($self, $text, $size, $colour) = @_;
  $colour = '' if !defined($colour);

  my $tmp = $text;

  if( $size > -1 ) {
    $tmp .= ','. $size;
  }

  if( $colour ne '' ) {
    $tmp .= ','. $colour;
  }

  return $tmp;
}

sub set_y_legend() {
  my ($self, $text, $size, $colour) = @_;
  $size = -1 if !defined($size);
  $colour = '' if !defined($colour);

  $self->{y_legend} = $self->_set_y_legend( $text, $size, $colour );
}

sub set_y_right_legend() {
  my ($self, $text, $size, $colour) = @_;
  $self->{y_legend_right} = $self->_set_y_legend( $text, $size, $colour );
}

sub x_axis_colour() {
  my ($self, $axis, $grid) = @_;
  $grid = '' if !defined($grid);
  $self->{x_axis_colour} = $axis;
  $self->{x_grid_colour} = $grid;
}

sub y_axis_colour() {
  my ($self, $axis, $grid) = @_;
  $grid = '' if !defined($grid);
  $self->{y_axis_colour} = $axis;

  if( $grid ne '' ) {
    $self->{y_grid_colour} = $grid;
  }
}

sub y_right_axis_colour() {
  my ($self, $colour) = @_;

  $self->{y2_axis_colour} = $colour;
}

sub line() {
  my ($self, $width, $colour, $text, $size, $circles) = @_;
  $colour = '' if !defined($colour);
  $text = '' if !defined($text);
  $size = -1 if !defined($size);
  $circles = -1 if !defined($circles);

  my $type = 'line'. $self->next_line();

  my $description = '';
  if( $width > 0 ) {
    $description .= $width;
    $description .= ','. $colour;
  }

  if( $text ne '' ) {
    $description.= ','. $text;
    $description .= ','. $size;
  }

  if( $circles > 0 )  {
    $description .= ','. $circles;
  }

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});
}

sub line_dot() {
  my ($self, $width, $dot_size, $colour, $text, $font_size) = @_;
  $text = '' if !defined($text);
  $font_size = '' if !defined($font_size);

  my $type = 'line_dot'. $self->next_line();

  my $description = "$width,$colour,$text";

  if( $font_size ne '') {
    $description .= ",$font_size,$dot_size";
  }

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});
}

sub line_hollow() {
  my ($self, $width, $dot_size, $colour, $text, $font_size) = @_;
  $text = '' if !defined($text);
  $font_size = '' if !defined($font_size);

  my $type = 'line_hollow'. $self->next_line();

  my $description = "$width,$colour,$text";

  if( $font_size ne '' ) {
    $description .= ",$font_size,$dot_size";
  }

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});
}

sub area_hollow() {
  my ($self, $width, $dot_size, $colour, $alpha, $text, $font_size, $fill_colour) = @_;
  $text = '' if !defined($text);
  $font_size = '' if !defined($font_size);
  $fill_colour = '' if !defined($fill_colour);

  my $type = 'area_hollow'. $self->next_line();

  my $description = "$width,$dot_size,$colour,$alpha";

  if( $text ne '') {
    $description .= ",$text,$font_size";
  }

  if( $fill_colour ne '' ) {
    $description .= ','. $fill_colour;
  }

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});
}


sub bar() {
  my ($self, $alpha, $colour, $text, $size) = @_;
  $colour = '' if !defined($colour);
  $text = '' if !defined($text);
  $size = -1 if !defined($size);

  my $type = 'bar'. $self->next_line();

  my $description = $alpha .','. $colour .','. $text .','. $size;

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});
}

sub bar_filled() {
  my ($self, $alpha, $colour, $colour_outline, $text, $size ) = @_;
  $text = '' if !defined($text);
  $size = -1 if !defined($size);

  my $type = 'filled_bar'. $self->next_line();

  my $description = "$alpha,$colour,$colour_outline,$text,$size";

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});
}

sub bar_sketch() {
  my ($self, $alpha, $offset, $colour, $colour_outline, $text, $size ) = @_;
  $text = '' if !defined($text);
  $size = -1 if !defined($size);

  my $type = 'bar_sketch'. $self->next_line();

  my $description = "$alpha,$offset,$colour,$colour_outline,$text,$size";

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});
}

sub bar_3D() {
  my ($self, $alpha, $colour, $text, $size) = @_;
  $colour = '' if !defined($colour);
  $text = '' if !defined($text);
  $size = -1 if !defined($size);

  my $type = 'bar_3d'. $self->next_line();

  my $description = $alpha .','. $colour .','. $text .','. $size;

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});
}

sub bar_glass() {
  my ($self, $alpha, $colour, $outline_colour, $text, $size) = @_;
  $text = '' if !defined($text);
  $size = -1 if !defined($size);

  my $type = 'bar_glass'. $self->next_line();

  my $description = $alpha .','. $colour .','. $outline_colour .','. $text .','. $size;

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});
}

sub bar_fade() {
  my ($self, $alpha, $colour, $text, $size) = @_;
  $colour = '' if !defined($colour);
  $text = '' if !defined($text);
  $size = -1 if !defined($size);

  my $type = 'bar_fade'. $self->next_line();

  my $description = $alpha .','. $colour .','. $text .','. $size;

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});
}

sub candle() {
  my ($self, $data, $alpha, $line_width, $colour, $text, $size) = @_;
  $text = '' if !defined($text);
  $size = -1 if !defined($size);

  my $type = 'candle'. $self->next_line();

  my $description = $alpha .','. $line_width .','. $colour .','. $text .','. $size;

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});

  my $a = [];
  for my $can ( @$data ) {
    push(@$a, $can->toString());
  }

  push(@{$self->{data}}, join(',',@$a));
}

sub hlc() {
  my ($self, $data, $alpha, $line_width, $colour, $text, $size) = @_;
  $text = '' if !defined($text);
  $size = -1 if !defined($size);

  my $type = 'hlc'. $self->next_line();

  my $description = $alpha .','. $line_width .','. $colour .','. $text .','. $size;

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});

  my $a = [];
  for my $can ( @$data ) {
    push(@$a, $can->toString());
  }

  push(@{$self->{data}}, join(',',@$a));
}

sub scatter() {
  my ($self, $data, $line_width, $colour, $text, $size) = @_;
  $text = '' if !defined($text);
  $size = -1 if !defined($size);

  my $type = 'scatter'. $self->next_line();

  my $description = $line_width .','. $colour .','. $text .','. $size;

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});

  my $a = [];
  for my $can ( @$data ) {
    push(@$a, $can->toString());
  }

  push(@{$self->{data}}, join(',',@$a));
}

# pie expects ->(scalar, scalar, scalar, scalar, scalar)
sub pie() {
  my ($self, $alpha, $line_colour, $label_colour, $gradient, $border_size) = @_;
  $gradient = 'true' if !defined($gradient);
  $border_size = 'false' if !defined($border_size);

  $self->{pie} = $alpha.','.$line_colour.','.$label_colour;
  if( $gradient eq 'false' ) {
    $self->{pie} .= ','.!$gradient;
  }
  if ($border_size eq 'true') {
    if ($gradient eq 'false') {
      $self->{pie} .= ',';
    }
    $self->{pie} .= ','.$border_size;
  }
}

# pie_values expects ->(array ref, array ref, array ref)
sub pie_values() {
  my ($self, $values, $labels, $links ) = @_;
  $links = [] if !defined($links);

  #somewhat of a php divergence here.
  #make sure all labels are shown ie no zero values
  #make sure you add up to 100% exactly
  my $total=0;
  for my $v ( @$values ) {
    $total=$total + $v;
  }
  my $pie_total = 0;
  my $biggest_pie_slice = 0;
  for ( my $i=0; $i < @$values; $i++) {
    $values->[$i] = sprintf("%.1f", ($values->[$i] / $total) * 100.0);
    # you can't have a zero pie slice
    if ( $values->[$i] < 0.1 ) {
      $values->[$i] += 0.1;
    }
    $pie_total += $values->[$i];
    if ( $values->[$i] > $values->[$biggest_pie_slice] ) {
      $biggest_pie_slice = $i;
    }
  }
  #adjust for rounding errors, and fill to 100% on biggest pie slice
  $values->[$biggest_pie_slice] += (100.0 - $pie_total);

  $self->{pie_values} = join(',',@$values);
  $self->{pie_labels} = join(',',@$labels);
  $self->{pie_links}  = join(',',@$links);
}

sub pie_slice_colours() {
  my ($self, $colours ) = @_;
  $self->{pie_colours} = join(',',@$colours);
}

sub set_width() {
  my ($self, $width ) = @_;
  $self->{width} = $width;
}

sub set_height() {
  my ($self, $height ) = @_;
  $self->{height} = $height;
}

sub set_base() {
  my ($self,$base) = @_;
  $base = 'js/' if !defined($base);
  $self->{base} = $base;
}

sub render() {
  my ($self,$output_type) = @_;
  $output_type = '' if !defined($output_type);
  my $tmp = [];
  my $values;

  if($output_type eq 'js') {
    $self->increment_occurence();

    push(@$tmp, '<div id="my_chart' . $self->{occurence} . '"></div>');
    push(@$tmp, '<script type="text/javascript" src="' . $self->{base} . 'swfobject.js"></script>');
    push(@$tmp, '<script type="text/javascript">');
    push(@$tmp, 'var so = new SWFObject("open-flash-chart.swf", "ofc", "'. $self->{width} . '", "' . $self->{height} . '", "9", "#FFFFFF");');
    push(@$tmp, 'so.addVariable("variables","true");');
  }

  if( $self->{title} ne '' ) {
    $values = $self->{title};
    $values .= ','. $self->{title_style};
    push(@$tmp, $self->format_output($output_type,'title',$values));
  }

  if( $self->{x_legend} ne '' ) {
    $values = $self->{x_legend};
    $values .= ','. $self->{x_legend_size};
    $values .= ','. $self->{x_legend_colour};
    push(@$tmp, $self->format_output($output_type,'x_legend',$values));
  }

  if( $self->{x_label_style} ne '') {
    push(@$tmp, $self->format_output($output_type,'x_label_style',$self->{x_label_style}));
  }

  if( $self->{x_tick_size} > 0 ) {
    push(@$tmp, $self->format_output($output_type,'x_ticks',$self->{x_tick_size}));
  }

  if( $self->{x_axis_steps} > 0 ) {
    push(@$tmp, $self->format_output($output_type,'x_axis_steps',$self->{x_axis_steps}));
  }

  if( $self->{x_axis_3d} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'x_axis_3d',$self->{x_axis_3d}));
  }

  if( $self->{y_legend} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'y_legend',$self->{y_legend}));
  }

  if( $self->{y_legend_right} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'y2_legend',$self->{y_legend_right}));
  }

  if( $self->{y_label_style} > 0 ) {
    push (@$tmp, $self->format_output($output_type,'y_label_style',$self->{y_label_style}));
  }

  $values = '5,10,'. $self->{y_steps};
  push(@$tmp, $self->format_output($output_type,'y_ticks',$values));

  if( scalar ( @{$self->{lines}} ) == 0 ) {
    push(@$tmp, $self->format_output($output_type,$self->{line_default}->{type},$self->{line_default}->{values}));
  } else {
    for my $line ( @{$self->{lines}} ) {
      push(@$tmp, $self->format_output($output_type,$line->{type},$line->{description}));
    }
  }

  my $num = 1;
  for my $data ( @{$self->{data}} ) {
    if( $num==1 ) {
      push(@$tmp, $self->format_output($output_type, 'values', $data));
    } else  {
      push(@$tmp, $self->format_output($output_type,'values_'. $num, $data));
    }
    $num++;
  }

  $num = 1;
  for my $link ( @{$self->{links}} ) {
    if( $num==1 ) {
      push(@$tmp, $self->format_output($output_type, 'links', $link));
    } else  {
      push(@$tmp, $self->format_output($output_type,'links_'. $num, $link));
    }
    $num++;
  }

  if( scalar(@{$self->{y2_lines}} ) > 0 ) {
    push(@$tmp, $self->format_output($output_type,'y2_lines',join(',', @{$self->{y2_lines}})));
    #
    # Should this be an option? I think so...
    #
    push(@$tmp, $self->format_output($output_type,'show_y2','true'));
  }

  if( scalar( @{$self->{x_labels}}) > 0 ) {
    push(@$tmp, $self->format_output($output_type,'x_labels', join(',',@{$self->{x_labels}}) ));
  } else {
    if( $self->{x_min} ne '' ) {
      push(@$tmp, $self->format_output($output_type,'x_min',$self->{x_min}));
    }

    if( $self->{x_max} ne '' ) {
      push(@$tmp, $self->format_output($output_type,'x_max',$self->{x_max}));
    }
  }

  push(@$tmp, $self->format_output($output_type,'y_min',$self->{y_min}));
  push(@$tmp, $self->format_output($output_type,'y_max',$self->{y_max}));

  if( $self->{y2_min} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'y2_min',$self->{y2_min}));
  }

  if( $self->{y2_max} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'y2_max',$self->{y2_max}));
  }

  if( $self->{bg_colour} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'bg_colour',$self->{bg_colour}));
  }

  if( $self->{bg_image} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'bg_image',$self->{bg_image}));
    push(@$tmp, $self->format_output($output_type,'bg_image_x',$self->{bg_image_x}));
    push(@$tmp, $self->format_output($output_type,'bg_image_y',$self->{bg_image_y}));
  }

  if( $self->{x_axis_colour} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'x_axis_colour',$self->{x_axis_colour}));
    push(@$tmp, $self->format_output($output_type,'x_grid_colour',$self->{x_grid_colour}));
  }

  if( $self->{y_axis_colour} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'y_axis_colour',$self->{y_axis_colour}));
  }

  if( $self->{y_grid_colour} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'y_grid_colour',$self->{y_grid_colour}));
  }

  if( $self->{y2_axis_colour} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'y2_axis_colour',$self->{y2_axis_colour}));
  }

  if( $self->{inner_bg_colour} ne '' ) {
    my $values = $self->{inner_bg_colour};
    if( $self->{inner_bg_colour_2} ne '') {
      $values .= ','. $self->{inner_bg_colour_2};
      $values .= ','. $self->{inner_bg_angle};
    }
    push(@$tmp, $self->format_output($output_type,'inner_background',$values));
  }

  if( $self->{pie} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'pie',$self->{pie}));
    push(@$tmp, $self->format_output($output_type,'values',$self->{pie_values}));
    push(@$tmp, $self->format_output($output_type,'pie_labels',$self->{pie_labels}));
    push(@$tmp, $self->format_output($output_type,'colours',$self->{pie_colours}));
    push(@$tmp, $self->format_output($output_type,'links',$self->{pie_links}));
  }

  if( $self->{tool_tip} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'tool_tip',$self->{tool_tip}));
  }

  if($output_type eq 'js') {
    push(@$tmp, 'so.write("my_chart' . $self->{occurence} . '");');
    push(@$tmp, '</script>');
  }

  return join("\r\n",@$tmp);
}




# URL-encode string
sub url_escape {
    my($toencode) = @_;
    $toencode=~s/([^a-zA-Z0-9_\-. ])/uc sprintf("%%%02x",ord($1))/eg;
    $toencode =~ tr/ /+/;    # spaces become pluses
    return $toencode;
}

sub swf_object {
  my ($width, $height, $url) = @_;

  my $html=qq^
  <object
    classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
    codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0"
    width="$width"
    height="$height"
    id="graph_2"
    align="middle">
  <param name="allowScriptAccess" value="sameDomain" />
  <param name="movie" value="open-flash-chart.swf?width=$width&height=$height&data=$url"/>
  <param name="quality" value="high" />
  <param name="bgcolor" value="#FFFFFF" />
  <embed
    src="open-flash-chart.swf?width=$width&height=$height&data=$url"
    quality="high"
    bgcolor="#FFFFFF"
    width="$width"
    height="$height"
    name="open-flash-chart"
    align="middle"
    allowScriptAccess="sameDomain"
    type="application/x-shockwave-flash"
    pluginspage="http://www.macromedia.com/go/getflashplayer"
  />
  </object>
  ^;
  return $html;
}




package candle;
sub new() {
  # setup object constructor
  my ($proto, $high, $open, $close, $low) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};

  $self->{out} = [];
  push(@{$self->{out}}, $high);
  push(@{$self->{out}}, $open);
  push(@{$self->{out}}, $close);
  push(@{$self->{out}}, $low);

  bless $self, $class;
  return $self;
}
sub toString() {
  my ($self) = @_;
  return '['. join(',', @{$self->{out}}) .']';
}


package hlc;
sub new() {
  # setup object constructor
  my ($proto, $high, $low, $close) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};

  $self->{out} = [];
  push(@{$self->{out}}, $high);
  push(@{$self->{out}}, $low);
  push(@{$self->{out}}, $close);

  bless $self, $class;
  return $self;
}
sub toString() {
  my ($self) = @_;
  return '['. join(',', @{$self->{out}}) .']';
}

package point;
sub new() {
  # setup object constructor
  my ($proto, $x, $y, $size_px) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};

  $self->{out} = [];
  push(@{$self->{out}}, $x);
  push(@{$self->{out}}, $y);
  push(@{$self->{out}}, $size_px);

  bless $self, $class;
  return $self;
}
sub toString() {
  my ($self) = @_;
  return '['. join(',', @{$self->{out}}) .']';
}


1;
