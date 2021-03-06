#
# API ref: /php-ofc-library/open-flash-chart.php version 78
# $Id: open_flash_chart.pm,v 1.16 2008/03/27 20:58:19 jvandervort Exp $

package open_flash_chart;

use strict;

# This class manages all functions of the open flash chart api.
package graph;

sub new() {
  # Constructer for the open_flash_chart_api
  # Sets our default variables
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;  #need to bless early so you can use methods in constructor

	$self->{data_sets} = [];
  $self->{data} = [];
  $self->{links} = [];
  $self->{width} = 250;
  $self->{height} = 200;
  $self->{base} = 'js/';
  $self->{x_labels} = [];
  $self->{y_auto} = 1;
  $self->{y_min} = '';
  $self->{y_max} = '';
  $self->{x_min} = '';
  $self->{x_max} = '';
  $self->{y_steps} = '';
  $self->{title} = '';
  $self->{title_style} = '';
  $self->{occurence} = 0;
  $self->{x_offset} = '';

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

  $self->{bg_colour} = ''; # '#ebf4fa';
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

	# Number formatting:
	$self->{y_format}='';
	$self->{num_decimals}='';
	$self->{is_fixed_num_decimals_forced}='';
	$self->{is_decimal_separator_comma}='';
	$self->{is_thousand_separator_disabled}='';
	
  #
  # set some default value incase the user forgets
  # to set them, so at least they see *something*
  # even is it is only the axis and some ticks
  #
  $self->set_y_min( 0 );
  #$self->set_y_max( 20 );
  $self->set_x_axis_steps( 1 );
  $self->y_label_steps( 5 );

  return $self;
}

# Set the unique_id to use for the flash object id.
sub set_unique_id() {
	my ($self) = @_;
  $self->{unique_id} = uniqid();
}

# Get the flash object ID for the last rendered object.
sub get_unique_id() {
	my ($self) = @_;
  return ($self->{unique_id});
}

#
# Set the base path for the swfobject.js
#
# @param base_path a string argument.
#   The path to the swfobject.js file
#
sub set_js_path() {
	my ($self, $path) = @_;
  $self->{js_path} = $path;
}

#
# Set the base path for the open-flash-chart.swf
#
# @param path a string argument.
#   The path to the open-flash-chart.swf file
#
sub set_swf_path() {
	my ($self, $path) = @_;
  $self->{swf_path} = $path;
}

#
# Set the type of output data.
#
# @param type a string argument.
#   The type of data.  Currently only type is js, or nothing.
#
sub set_output_type() {
	my ($self, $type) = @_;
  $self->{output_type} = $type;
}

sub increment_occurence() {
  my ($self) = @_;
  $self->{occurence}++;
}

# returns the next line label for multiple lines.
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

# Format the text to the type of output.
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


# Set the text and style of the title.
#
# @param title a string argument.
#   The text of the title.
# @param style a string.
#   CSS styling of the title.
#
sub set_title() {
	my ($self, $title, $style) = @_;
	$style = '' if !defined($style);
  $self->{title} = $title;
  if( $style ne '' ) {
    $self->{title_style} = $style;
  }
}

#
# Set the width of the chart.
#
# @param width an int argument.
#   The width of the chart frame.
#
sub set_width() {
	my ($self, $width) = @_;
  $self->{width} = $width;
}

#
# Set the height of the chart.
#
# @param height an int argument.
#   The height of the chart frame.
#
sub set_height() {
	my ($self, $height) = @_;
  $self->{height} = $height;
}

#
# Set the base path of the swfobject.
#
# @param base a string argument.
#   The base path of the swfobject.
#
sub set_base() {
	my ($self, $base) = @_;
	$base = 'js/' if !defined($base);
  $self->{base} = $base;
}

# Number formatting:
sub set_y_format() {
	my ($self, $val) = @_;
  $self->{y_format} = $val;
}

sub set_num_decimals() {
	my ($self, $val) = @_;
  $self->{num_decimals} = $val;
}

sub set_is_fixed_num_decimals_forced() {
	my ($self, $val) = @_;
  $self->{is_fixed_num_decimals_forced} = $val?'true':'false';
}

sub set_is_decimal_separator_comma() {
	my ($self, $val) = @_;
  $self->{is_decimal_separator_comma} = $val?'true':'false';
}

sub set_is_thousand_separator_disabled() {
	my ($self, $val) = @_;
  $self->{is_thousand_separator_disabled} = $val?'true':'false';
}

#
# Set the data for the chart
# @param an array ref argument.
#   An array of the data to add to the chart.
#
sub set_data() {
  my ($self, $a) = @_;
  push(@{$self->{data}}, join(',', @$a));
}

# UGH, these evil functions are making me fell ill
sub set_links() {
  my ($self, $a) = @_;
  push(@{$self->{links}}, join(',', @$a));
}

# $val is a boolean
sub set_x_offset() {
	my ($self, $val) = @_;
  $self->{x_offset} = $val?'true':'false';
}

#
# Set the tooltip to be displayed on each chart item.\n
# \n
# Replaceable tokens that can be used in the string include: \n
# #val# - The actual value of whatever the mouse is over. \n
# #key# - The key string. \n
# \<br>  - New line. \n
# #x_label# - The X label string. \n
# #x_legend# - The X axis legend text. \n
# Default string is: "#x_label#<br>#val#" \n
#
# @param tip a string argument.
#   A formatted string to show as the tooltip.
#
sub set_tool_tip() {
  my ($self, $tip) = @_;
  $self->{tool_tip} = $self->esc( $tip );
}

#
# Set the x axis labels
#
# @param a an array ref argument.
#   An array of the x axis labels.
#
sub set_x_labels() {
  my ($self, $a) = @_;
  $self->{x_labels} = $a;
}


# Set the look and feel of the x axis labels
#
# @param font_size an int argument.
#   The font size.
# @param colour a string argument.
#   The hex colour value.
# @param orientation an int argument.
#   The orientation of the x-axis text.
#   0 - Horizontal
#   1 - Vertical
#   2 - 45 degrees
# @param step an int argument.
#   Show the label on every $step label.
# @param grid_colour a string argument.
#
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


# Set the background colour.
# @param colour a string argument.
#   The hex colour value.
#
sub set_bg_colour() {
  my ($self, $colour) = @_;
  $self->{bg_colour} = $colour;
}


# Set a background image.
# @param url a string argument.
#   The location of the image.
# @param x a string argument.
#   The x location of the image. 'Right', 'Left', 'Center'
# @param y a string argument.
#   The y location of the image. 'Top', 'Bottom', 'Middle'
#
sub set_bg_image() {
  my ($self, $url, $x, $y) = @_;
  $x = 'center' if !defined($x);
  $y = 'center' if !defined($y);
  $self->{bg_image} = $url;
  $self->{bg_image_x} = $x;
  $self->{bg_image_y} = $y;
}

#
# Attach a set of data (a line, area or bar chart) to the right Y axis.
# @param data_number an int argument.
#   The numbered order the data was attached using set_data.
#
sub attach_to_y_right_axis() {
  my ($self, $data_number) = @_;
  push(@{$self->{y2_lines}}, $data_number);
}


# Set the background colour of the grid portion of the chart.
# @param col a string argument.
#   The hex colour value of the background.
# @param col2 a string argument.
#   The hex colour value of the second colour if you want a gradient.
# @param angle an int argument.
#   The angle in degrees to make the gradient.
#
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

#
# Internal function to build the y label style for y and y2
#
sub _set_y_label_style() {
  my ($self, $size, $colour) = @_;
  $colour = '' if !defined($colour);
  my $tmp = $size;

  if( $colour ne '' ) {
    $tmp .= ','. $colour;
  }
  return $tmp;
}

#
# Set the look and feel of the y axis labels
#
# @param font_size an int argument.
#   The font size.
# @param colour a string argument.
#   The hex colour value.
#
sub set_y_label_style() {
  my ($self, $size, $colour) = @_;
  $colour = '' if !defined($colour);

  $self->{y_label_style} = $self->_set_y_label_style( $size, $colour );
}

#
# Set the look and feel of the right y axis labels
#
# @param font_size an int argument.
#   The font size.
# @param colour a string argument.
#   The hex colour value.
#
sub set_y_right_label_style() {
  my ($self, $size, $colour) = @_;
  $colour = '' if !defined($colour);
  $self->{y_label_style_right} = $self->_set_y_label_style( $size, $colour );
}

sub set_x_max() {
  my ($self, $max) = @_;
  $self->{x_max} = $max ;
}

sub set_x_min() {
  my ($self, $min) = @_;
  $self->{x_min} = $min;
}

#
# Set the maximum value of the y axis.
#
# @param max a number argument.
#   The maximum value.
#
sub set_y_max() {
  my ($self, $max) = @_;
  $self->{y_auto} = 0;
  $self->{y_max} = $max;
}

#
# Set the minimum value of the y axis.
#
# @param min an number argument.
#   The minimum value.
#
sub set_y_min() {
  my ($self, $min) = @_;
  $self->{y_min} = $min;
}

#
# Set the maximum value of the right y axis.
#
# @param max an number argument.
#   The maximum value.
#
sub set_y_right_max() {
  my ($self, $max) = @_;
  $self->{y2_max} = $max;
}

#
# Set the minimum value of the right y axis.
#
# @param min an number argument.
#   The minimum value.
#
sub set_y_right_min() {
  my ($self, $min) = @_;
  $self->{y2_min} = $min;
}

#
# Show the y label on every $step label.
#
# @param val an int argument.
#   Show the label on every $step label.
#
sub y_label_steps() {
  my ($self, $val) = @_;
  $self->{y_steps} = $val;
}

sub title() {
  my ($self, $title, $style) = @_;
  $style = '' if !defined($style);
  $self->{title} = $self->esc( $title );
  if( $style ne '' ) {
    $self->{title_style} = $style;
  }
}

#
# Set the parameters of the x legend.
#
# @param text a string argument.
#   The text of the x legend.
# @param font_size an int argument.
#   The font size of the x legend text.
# @param colour a string argument
#   The hex value of the font colour.
#
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

#
# Set the size of the x label ticks.
#
# @param size an int argument.
#   The size of the ticks in pixels.
#
sub set_x_tick_size() {
  my ($self, $size) = @_;
  if( $size > 0 ) {
    $self->{x_tick_size} = $size;
  }
}

#
# Set how often you would like to show a tick on the x axis.
#
# @param steps an int argument.
#   Show a tick ever $steps.
#
sub set_x_axis_steps() {
  my ($self, $steps) = @_;
  if ( $steps > 0 ) {
    $self->{x_axis_steps} = $steps;
  }
}

#
# Set the depth in pixels of the 3D X axis slab.
#
# @param size an int argument.
#   The depth in pixels of the 3D X axis.
#
sub set_x_axis_3d() {
  my ($self, $size) = @_;
  if( $size > 0 ) {
    $self->{x_axis_3d} = int($size);
  }
}

# The private method of building the y legend output.
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

#
# Set the parameters of the y legend.
#
# @param text a string argument.
#   The text of the y legend.
# @param font_size an int argument.
#   The font size of the y legend text.
# @param colour a string argument
#   The hex colour value of the font colour.
#
sub set_y_legend() {
  my ($self, $text, $size, $colour) = @_;
  $size = -1 if !defined($size);
  $colour = '' if !defined($colour);

  $self->{y_legend} = $self->_set_y_legend( $text, $size, $colour );
}

#
# Set the parameters of the right y legend.
#
# @param text a string argument.
#   The text of the right y legend.
# @param font_size an int argument.
#   The font size of the right y legend text.
# @param colour a string argument
#   The hex value of the font colour.
#
sub set_y_right_legend() {
  my ($self, $text, $size, $colour) = @_;
  $self->{y_legend_right} = $self->_set_y_legend( $text, $size, $colour );
}

#
# Set the colour of the x axis line and grid.
#
# @param axis a string argument.
#   The hex colour value of the x axis line.
# @param grid a string argument.
#   The hex colour value of the x axis grid.
#
sub x_axis_colour() {
  my ($self, $axis, $grid) = @_;
  $grid = '' if !defined($grid);
  $self->{x_axis_colour} = $axis;
  $self->{x_grid_colour} = $grid;
}

#
# Set the colour of the y axis line and grid.
#
# @param axis a string argument.
#   The hex colour value of the y axis line.
# @param grid a string argument.
#   The hex colour value of the y axis grid.
#
sub y_axis_colour() {
  my ($self, $axis, $grid) = @_;
  $grid = '' if !defined($grid);
  $self->{y_axis_colour} = $axis;

  if( $grid ne '' ) {
    $self->{y_grid_colour} = $grid;
  }
}

#
# Set the colour of the right y axis line.
#
# @param colour a string argument.
#   The hex colour value of the right y axis line.
#
sub y_right_axis_colour() {
  my ($self, $colour) = @_;

  $self->{y2_axis_colour} = $colour;
}

#
# Draw a line without markers on values.
#
# @param width an int argument.
#   The width of the line in pixels.
# @param colour a string argument.
#   The hex colour value of the line.
# @param text a string argument.
#   The label of the line.
# @param font_size an int argument.
#   Font size of the label
# @param circles an int argument
#   Need to find out.
#
sub line() {
  my ($self, $line_width, $colour, $text, $font_size, $circles) = @_;
  $colour = '' if !defined($colour);
  $text = '' if !defined($text);
  $font_size = -1 if !defined($font_size);
  $circles = -1 if !defined($circles);

  my $type = 'line'. $self->next_line();

  my $description = '';
  if( $line_width > 0 ) {
    $description .= $line_width;
    $description .= ','. $colour;
  }

  if( $text ne '' ) {
    $description.= ','. $text;
    $description .= ','. $font_size;
  }

  if( $circles > 0 )  {
    $description .= ','. $circles;
  }

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});
}

#
# Draw a line with solid dot markers on values.
#
# @param width an int argument.
#   The width of the line in pixels.
# @param dot_size an int argument.
#   Size in pixels of the dot.
# @param colour a string argument.
#   The hex colour value of the line.
# @param text a string argument.
#   The label of the line.
# @param font_size an int argument.
#   Font size of the label.
#
sub line_dot() {
  my ($self, $line_width, $dot_size, $colour, $text, $font_size) = @_;
  $text = '' if !defined($text);
  $font_size = '' if !defined($font_size);

  my $type = 'line_dot'. $self->next_line();

  my $description = "$line_width,$colour,$text";

  if( $font_size ne '') {
    $description .= ",$font_size,$dot_size";
  }

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});
}

#
# Draw a line with hollow dot markers on values.
#
# @param width an int argument.
#   The width of the line in pixels.
# @param dot_size an int argument.
#   Size in pixels of the dot.
# @param colour a string argument.
#   The hex colour value of the line.
# @param text a string argument.
#   The label of the line.
# @param font_size an int argument.
#   Font size of the label.
#
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

#
# Draw an area chart.
#
# @param width an int argument.
#   The width of the line in pixels.
# @param dot_size an int argument.
#   Size in pixels of the dot.
# @param colour a string argument.
#   The hex colour value of the line.
# @param alpha an int argument.
#   The percentage of transparency of the fill colour.
# @param text a string argument.
#   The label of the line.
# @param font_size an int argument.
#   Font size of the label.
# @param fill_colour a string argument.
#   The hex colour value of the fill colour.
#
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

#
# Draw a bar chart.
#
# @param alpha an int argument.
#   The percentage of transparency of the bar colour.
# @param colour a string argument.
#   The hex colour value of the line.
# @param text a string argument.
#   The label of the line.
# @param font_size an int argument.
#   Font size of the label.
#
sub bar() {
  my ($self, $alpha, $colour, $text, $size) = @_;
  $colour = '' if !defined($colour);
  $text = '' if !defined($text);
  $size = -1 if !defined($size);

  my $type = 'bar'. $self->next_line();

  my $description = $alpha .','. $colour .','. $text .','. $size;

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});
}

#
# Draw a bar chart with an outline.
#
# @param alpha an int argument.
#   The percentage of transparency of the bar colour.
# @param colour a string argument.
#   The hex colour value of the line.
# @param colour_outline a strng argument.
#   The hex colour value of the outline.
# @param text a string argument.
#   The label of the line.
# @param font_size an int argument.
#   Font size of the label.
#
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

#
# Draw a 3D bar chart.
#
# @param alpha an int argument.
#   The percentage of transparency of the bar colour.
# @param colour a string argument.
#   The hex colour value of the line.
# @param text a string argument.
#   The label of the line.
# @param font_size an int argument.
#   Font size of the label.
#
sub bar_3D() {
  my ($self, $alpha, $colour, $text, $size) = @_;
  $colour = '' if !defined($colour);
  $text = '' if !defined($text);
  $size = -1 if !defined($size);

  my $type = 'bar_3d'. $self->next_line();

  my $description = $alpha .','. $colour .','. $text .','. $size;

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});
}

#
# Draw a 3D bar chart that looks like glass.
#
# @param alpha an int argument.
#   The percentage of transparency of the bar colour.
# @param colour a string argument.
#   The hex colour value of the line.
# @param outline_colour a string argument.
#   The hex colour value of the outline.
# @param text a string argument.
#   The label of the line.
# @param font_size an int argument.
#   Font size of the label.
#
sub bar_glass() {
  my ($self, $alpha, $colour, $outline_colour, $text, $size) = @_;
  $text = '' if !defined($text);
  $size = -1 if !defined($size);

  my $type = 'bar_glass'. $self->next_line();

  my $description = $alpha .','. $colour .','. $outline_colour .','. $text .','. $size;

  push(@{$self->{lines}}, {'type'=>$type, 'description'=>$description});
}

#
# Draw a faded bar chart.
#
# @param alpha an int argument.
#   The percentage of transparency of the bar colour.
# @param colour a string argument.
#   The hex colour value of the line.
# @param text a string argument.
#   The label of the line.
# @param font_size an int argument.
#   Font size of the label.
#
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

#
# Draw a pie chart.
#
# @param alpha an int argument.
#   The percentage of transparency of the pie colour.
# @param line_colour a string argument.
#   The hex colour value of the outline.
# @param label_colour a string argument.
#   The hex colour value of the label.
# @param gradient a boolean argument.
#   Use a gradient true or false.
# @param border_size an int argument.
#   Size of the border in pixels.
#
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

#
# Set the values of the pie chart.
# Takes actual values and converts to 100%
#
# @param values an array argument.
#   An array ref of the values for the pie chart.
# @param labels an array argument.
#   An array ref of the labels for the pie pieces.
# @param links an array argument.
#   An array ref of the links to the pie pieces.
#
sub pie_values() {
  my ($self, $values, $labels, $links ) = @_;

  my @l_values = @$values if defined($values) || ();
  my @l_labels = @$labels if defined($labels) || ();
  my @l_links = @$links if defined($links) || ();
  
  while ( @l_labels < @l_values ) {
 		push(@l_labels, '');
  }
  while ( @l_links < @l_values ) {
 		push(@l_links, '');
  }

  #php divergence here.
  #make sure all labels are shown ie no zero values
  #make sure you add up to 100% exactly
  my $total=0;
  for my $v ( @l_values ) {
    $total=$total + $v;
  }
  my $pie_total = 0;
  my $biggest_pie_slice = 0;
  my $too_small_value = 0;
  my $too_small_label = '';
  for ( my $i=0; $i < @l_values; $i++) {
    $l_values[$i] = sprintf("%.1f", ($l_values[$i] / $total) * 100.0);
    # you can't have a zero pie slice
    if ( $l_values[$i] == 0.0 ) {
    	splice(@l_values, $i, 1);
    	splice(@l_labels, $i, 1);
    	splice(@l_links, $i, 1);
    	$i--;
    	next;
    } elsif ($l_values[$i] < 3.0) {
    	$pie_total += $l_values[$i];
    	$too_small_value = $too_small_value + $l_values[$i];
   		$too_small_label = $l_labels[$i] . '/' . $too_small_label;
    	splice(@l_values, $i, 1);
    	splice(@l_labels, $i, 1);
    	splice(@l_links, $i, 1);
    	$i--;
    	next;
    }
    
    $pie_total += $l_values[$i];
    if ( $l_values[$i] > $l_values[$biggest_pie_slice] ) {
      $biggest_pie_slice = $i;
    }
  }
  
  #adjust for rounding errors, and fill to 100% on biggest pie slice
  $l_values[$biggest_pie_slice] += (100.0 - $pie_total);

	#get rid of the tailing / from the too small label
	$too_small_label =~ s/\/$//;
	if (length($too_small_label) > 20 ) {
		$too_small_label = substr($too_small_label,0,25) . "...";
	}

	if ( $too_small_value > 0 ) {
		push(@l_values, $too_small_value);
		$too_small_label =~ s/ $//;
		push(@l_labels, $too_small_label);
		push(@l_links,'');
	}

  $self->{pie_values} = join(',',@l_values);
  $self->{pie_labels} = join(',',@l_labels);
  $self->{pie_links}  = join(',',@l_links);
}

#
# Set the pie slice colours.
#
# @param colours an array argument.
#   The hex colour values of the pie pieces.
#
sub pie_slice_colours() {
  my ($self, $colours ) = @_;
  $self->{pie_colours} = join(',',@$colours);
}

#
# Render the output.
#
sub render() {
  my ($self,$output_type) = @_;
  $output_type = $self->{output_type} if !defined($output_type);
  my $tmp = [];
  my $values;

  if($output_type eq 'js') {
    $self->increment_occurence();

    push(@$tmp, '<div id="my_chart' . $self->{occurence} . '"></div>');
    #push(@$tmp, '<script type="text/javascript" src="' . $self->{base} . 'swfobject.js"></script>');
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


  if ( scalar(@{$self->{data_sets}}) == 0 ) {
    #legacy api

    if( scalar(@{$self->{lines}}) == 0 ) {
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
  if ( $self->{y_auto} ) {
    $self->set_auto_y_max();  
  }
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

  if( $self->{y_format} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'y_format',$self->{y_format}));
  }

  if( $self->{num_decimals} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'num_decimals',$self->{num_decimals}));
  }

  if( $self->{is_fixed_num_decimals_forced} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'is_fixed_num_decimals_forced',$self->{is_fixed_num_decimals_forced}));
  }

  if( $self->{is_decimal_separator_comma} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'is_decimal_separator_comma',$self->{is_decimal_separator_comma}));
  }

  if( $self->{is_thousand_separator_disabled} ne '' ) {
    push(@$tmp, $self->format_output($output_type,'is_thousand_separator_disabled',$self->{is_thousand_separator_disabled}));
  }

  my $count = 1;
  for my $set ( @{$self->{data_sets}} ) {
    push(@$tmp, $set->toString( $output_type, $count>1?'_'.$count:'' ));
    $count++;
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


#
# control how the auto y_max works
#
# @param $smooth_rounding an int argument.
#   1 or 0: rounds the y_max to the nearest 10, 50, 100, 200, or 500
# @param $head_room an decimal argument.
#   defines how much extra y scale you want above your highest data point
#   defaults to 0.1 (or 10%) extra space at the top of a chart
sub set_auto_y_max() {
  my ($self, $smooth_rounding, $head_room) = @_;
  
  $smooth_rounding = 1 if !defined($smooth_rounding);
  $head_room = 0.1 if !defined($head_room);

  my $max;
  if ( @{$self->{data_sets}} > 0 ) {
    
    
    
    #use data_sets
    for my $set ( @{$self->{data_sets}} ) {
      #push(@$tmp, $set->toString( $output_type, $count>1?'_'.$count:'' ));
      #$count++;
      for my $pt ( @{$set->{data}} ) {
        
        if ( !defined($max) ) {
          $max = $pt;
        } elsif ( $pt > $max ) {
          $max = $pt;
        }
      }
    }  
  } else {
    #use data
    for my $data ( @{$self->{data}} ) {
      for my $pt ( split(',',$data) ) {
        if ( !defined($max) ) {
          $max = $pt;
        } elsif ( $pt > $max ) {
          $max = $pt;
        }
      }
    }  
  }
 
  $max = $max * (1 + $head_room);
  
  if ( $smooth_rounding ) {
  	# round the max up a bit to a nice round number
  	if ( $max < 100 ) { $max = $max + (-$max % 10) }
  	elsif ( $max < 500 ) { $max = $max + (-$max % 50) }
  	elsif ( $max < 1000 ) { $max = $max + (-$max % 100) }
  	elsif ( $max < 10000 ) { $max = $max + (-$max % 200) }
  	else { $max = $max + (-$max % 500) }
    $max = int($max);
  }  
  
  $self->set_y_max($max);
}


#############################
sub _____NEW_OBJECTS_____(){}
#############################
package dataset;
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};

  $self->{data} = [];
  $self->{links} = [];
  $self->{_key} = 0;

  bless $self, $class;
  return $self;
}
sub key() {
	my ($self, $key, $size) = @_;
  $self->{_key} = 1;
  $self->{key} = graph->esc($key);
  $self->{key_size} = $size;
}

# add a single data point and link
sub add() {
	my ($self, $data, $link) = @_;
	push(@{$self->{data}}, $data);
	push(@{$self->{links}}, $link);
}

# add all data points and links by array ref
sub add_data() {
	my ($self, $data_array, $links_array) = @_;
	$self->{data} = $data_array;
	$self->{links} = $links_array;
}


# return the variables for this
# data seris (usually overridden
sub _get_variable_list() {
	my ($self) = @_;
	
  my @values;
  if( $self->{_key} ) {
    push(@values, $self->{key});
    push(@values, $self->{key_size});
   }

  return \@values;
}

sub toString() {
	my ($self, $output_type, $set_num) = @_;
	
  my $values = join(',', @{$self->_get_variable_list()} );

  my @tmp;
  if ($output_type eq 'js' ) {
    push(@tmp, 'so.addVariable("'. $self->{var} . $set_num .'","'. $values . '");');

    push(@tmp, 'so.addVariable("values'. $set_num .'","'. join(',', @{$self->{data}}) .'");');

    if( scalar(@{$self->{links}}) > 0 ) {
      push(@tmp, 'so.addVariable("values'. $set_num .'","'. join(',', @{$self->{links}}) .'");');
    }
  } else {
    push(@tmp, '&'. $self->{var}. $set_num .'='. $values .'&');
    push(@tmp, '&values'. $set_num .'='. join(',', @{$self->{data}}) .'&');

    if( scalar(@{$self->{links}}) > 0 ) {
      push(@tmp, '&links'. $set_num .'='. join(',', @{$self->{links}}) .'&');
    }
  }

  return join("\r\n", @tmp);
}

#
# Line Section
#
package line;
our @ISA = qw(dataset);
sub new() {
  # Constructer for the bar
  # Sets our default variables
  my ($proto, $line_width, $colour, $text, $font_size, $circles) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();

  $colour = ''    if !defined($colour);
  $text = ''      if !defined($text);
  $font_size = -1 if !defined($font_size);
  $circles = -1   if !defined($circles);
  
  $self->{line_width} = $line_width;
  $self->{colour} = $colour;
  $self->{text} = $text;
  $self->{font_size} = $font_size;
  $self->{circles} = $circles;

  $self->{var} = 'line';
  return $self;
}
sub _get_variable_list() {
	my ($self) = @_;
	
  my @values;
  push(@values, $self->{line_width});
  push(@values, $self->{colour});
  push(@values, $self->{text});
  push(@values, $self->{font_size});
  push(@values, $self->{circles});

  #if( $self->{_key} ) {
  #  push(@values, $self->{key});
  #  push(@values, $self->{key_size});
  # }

  return \@values;
}

package line_dot;
our @ISA = qw(line);
sub new() {
  # Constructer for the bar
  # Sets our default variables
  my ($proto, $line_width, $dot_size, $colour, $text, $font_size) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new($line_width, $colour, $text, $font_size);
  $self->{dot_size} = $dot_size;
  
  $self->{var} = 'line_dot';
  return $self;
}
sub _get_variable_list() {
	my ($self) = @_;
	
  my @values;
  push(@values, $self->{line_width});
  push(@values, $self->{colour});
  push(@values, $self->{text});
  push(@values, $self->{font_size});
  push(@values, $self->{dot_size});

  if( $self->{_key} ) {
    push(@values, $self->{key});
    push(@values, $self->{key_size});
   }

  return \@values;
}

package line_hollow;
our @ISA = qw(line_dot);
sub new() {
  # Constructer for the bar
  # Sets our default variables
  my ($proto, $line_width, $dot_size, $colour, $text, $font_size) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new($line_width, $dot_size, $colour, $text, $font_size);
  
  $self->{var} = 'line_hollow';
  return $self;
}

#
# Bar Section
#
package bar;
our @ISA = qw(dataset);
sub new() {
  # Constructer for the bar
  # Sets our default variables
  my ($proto, $alpha, $colour) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{alpha} = $alpha;
  $self->{colour} = $colour;

  $self->{var} = 'bar';

  return $self;
}

# return the variables for this
# bar chart
sub _get_variable_list() {
	my ($self) = @_;
	
  my @values;
  push(@values, $self->{alpha});
  push(@values, $self->{colour});

  if( $self->{_key} ) {
    push(@values, $self->{key});
    push(@values, $self->{key_size});
   }

  return \@values;
}

package bar_3d;
our @ISA = qw(bar);
sub new() {
  # Constructer for the bar
  # Sets our default variables
  my ($proto, $alpha, $colour) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new($alpha, $colour);
  $self->{var} = 'bar_3d';
  return $self;
}

package bar_fade;
our @ISA = qw(bar);
sub new() {
  # Constructer for the bar
  # Sets our default variables
  my ($proto, $alpha, $colour) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new($alpha, $colour);
  $self->{var} = 'bar_fade';
  return $self;
}

package bar_outline;
our @ISA = qw(bar);
sub new() {
  # Constructer for the bar
  # Sets our default variables
  my ($proto, $alpha, $colour, $outline_colour) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new($alpha, $colour);
  $self->{var} = 'filled_bar';
  $self->{outline_colour} = $outline_colour;
  return $self;
}
#/ override the base method
sub _get_variable_list() {
	my ($self) = @_;
  my @values;
  push(@values, $self->{alpha});
  push(@values, $self->{colour});
  push(@values, $self->{outline_colour});

  if( $self->{_key} ) {
    push(@values, $self->{key});
    push(@values, $self->{key_size});
  }
  return \@values;
}

package bar_glass;
our @ISA = qw(bar_outline);
sub new() {
  # Constructer for the bar
  # Sets our default variables
  my ($proto, $alpha, $colour) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new($alpha, $colour);
  $self->{var} = 'bar_glass';
  return $self;
}

#
# this has an outline colour and a 'jiggle' parameter
# called offset
#
package bar_sketch;
our @ISA = qw(bar_outline);
sub new() {
  # Constructer for the bar
  # Sets our default variables
  my ($proto, $alpha, $offset, $colour, $outline_colour) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new($alpha, $colour, $outline_colour);
  $self->{var} = 'bar_sketch';
  $self->{offset} = $offset;
  return $self;
}
# override the base method
sub _get_variable_list() {
	my ($self) = @_;
  my @values;
  push(@values, $self->{alpha});
  push(@values, $self->{offset});
  push(@values, $self->{colour});
  push(@values, $self->{outline_colour});

  if( $self->{_key} ) {
    push(@values, $self->{key});
    push(@values, $self->{key_size});
  }

  return \@values;
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
