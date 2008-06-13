
use strict; use warnings;


# This class manages all functions of the open flash chart api.
package chart;
sub new() {
  # Constructer for the open_flash_chart_api
  # Sets our default variables
  my ($proto, $bootstrap) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  
  $self->{'data_load_type'} = 'inline_js'; # or 'url_callback'  not sure if we still need both
  
  $self->{'bootstrap'} = 0; # you can set this to 1 if you want to handle the includes
  $self->{'bootstrap'} = $bootstrap if defined($bootstrap);
  
  $self->{'chart_props'} = {
    "title"=>{
      "text"=>"Default Chart Title",
      "style"=>"{font-size:20px; font-family:Verdana; text-align:center;}"
    },
    "x_axis"=>{
      "min"=>     undef,
      "max"=>     undef,
      "labels"=> ["a","b","c","d","e"]
    },
    "y_axis"=>{
      "min"=>     0,
      "max"=>     "a",
      "colour"=>  "#d09090",
    }
  };
  $self->{'elements'} = [];
  
  return $self;
}

sub get_element() {
  my ($self, $element_name) = @_;
  
  my $e=undef;
  eval("\$e = ${element_name}->new();");
  if ( defined($e) ) {
    return $e;
  } 
}

sub add_element() {
  my ($self, $element) = @_;
  if ( $element->{'use_extremes'} == 1 ) {
  	$self->use_extremes();
  }
  push(@{$self->{'elements'}}, $element);
}

sub use_extremes {
  my ($self) = @_;

	$self->{'chart_props'}->{'x_axis'}->{'min'} = 'a';
	$self->{'chart_props'}->{'x_axis'}->{'max'} = 'a';
	$self->{'chart_props'}->{'y_axis'}->{'min'} = 'a';
	$self->{'chart_props'}->{'y_axis'}->{'max'} = 'a';
}

sub render_chart_data() {
  my ($self) = @_;

  my $tmp = ''; #$self->get_page_bootstrap();

  my $ext = $self->get_auto_extremes();
  
  if ($self->{'chart_props'}->{'y_axis'}->{'max'} =~ /a/) {
    $self->{'chart_props'}->{'y_axis'}->{'max'} = main::smoother($ext->{'y_max'});
  }

  if ($self->{'chart_props'}->{'x_axis'}->{'max'} =~ /a/) {
    $self->{'chart_props'}->{'x_axis'}->{'max'} = $ext->{'x_max'};
  }

  if ($self->{'chart_props'}->{'y_axis'}->{'min'} =~ /a/) {
    $self->{'chart_props'}->{'y_axis'}->{'min'} = $ext->{'y_min'};
  }

  if ($self->{'chart_props'}->{'x_axis'}->{'min'} =~ /a/) {
    $self->{'chart_props'}->{'x_axis'}->{'min'} = $ext->{'x_min'};
  }

  
  $tmp .= "{";
  $tmp .= main::to_json($self->{'chart_props'});
  if ( @{$self->{'elements'}} > 0 ) {
    $tmp .= "\n".'"elements" : [';
    for my $s ( @{$self->{'elements'}} ) {
      $tmp .= $s->to_json() . ',';  
    }  
    $tmp =~ s/,$//g;
    $tmp .= ']';
  }
  $tmp =~ s/,$//g;
  $tmp .= "\n}";

  return $tmp;
}


sub render_swf {
  my ($self, $width, $height, $data_url) = @_;

  my $html = '';
  
  if ( $self->{'data_load_type'} eq 'inline_js' ) {
    if ($self->{'bootstrap'} == 0 ) {
      $html.='<script type="text/javascript" src="swfobject.js"></script>';
      $self->{'bootstrap'} = 1;
    }
    $html .= qq^
    <div id="my_chart"></div>
    <script type="text/javascript">
      var so = new SWFObject("open-flash-chart.swf", "ofc", "$width", "$height", "9", "#FFFFFF");
      so.addVariable("data-file", "$data_url");
      so.addParam("allowScriptAccess", "always" );//"sameDomain");
      so.write("my_chart");
    </script>
    ^;
  } else {
    $html .= qq^
    <object
      classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
      codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0"
      width="$width"
      height="$height"
      id="graph_2"
      align="middle">
    <param name="allowScriptAccess" value="sameDomain" />
    <param name="movie" value="open-flash-chart.swf?width=$width&height=$height&data=$data_url"/>
    <param name="quality" value="high" />
    <param name="bgcolor" value="#FFFFFF" />
    <embed
      src="open-flash-chart.swf?width=$width&height=$height&data=$data_url"
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
  }

  return $html;
}

#
# control how the auto max works
#
# @param $smooth_rounding an int argument.
#   1 or 0: rounds the y_max to the nearest 10, 50, 100, 200, or 500
# @param $head_room an decimal argument.
#   defines how much extra y scale you want above your highest data point
#   defaults to 0.1 (or 10%) extra space at the top of a chart
sub get_auto_extremes() {
  my ($self, $smooth_rounding, $head_room) = @_;
  $smooth_rounding = 1 if !defined($smooth_rounding);
  $head_room = 0.1 if !defined($head_room);
  
  my $extremes = {'x_max' => undef, 'x_min' => undef, 'y_max' => undef, 'y_min' => undef, 'other' => undef};
    
  for my $e ( @{$self->{'elements'}} ) {

    $extremes->{'x_max'} = $e->{'extremes'}->{'x_max'} if !defined($extremes->{'x_max'});
    if ( $e->{'extremes'}->{'x_max'} > $extremes->{'x_max'} ) {
        $extremes->{'x_max'} = $e->{'extremes'}->{'x_max'};
    }

    $extremes->{'y_max'} = $e->{'extremes'}->{'y_max'} if !defined($extremes->{'y_max'});
    if ( $e->{'extremes'}->{'y_max'} > $extremes->{'y_max'} ) {
        $extremes->{'y_max'} = $e->{'extremes'}->{'y_max'};
    }

    $extremes->{'x_min'} = $e->{'extremes'}->{'x_min'} if !defined($extremes->{'x_min'});
    if ( $e->{'extremes'}->{'x_min'} < $extremes->{'x_min'} ) {
        $extremes->{'x_min'} = $e->{'extremes'}->{'x_min'};
    }

    $extremes->{'y_min'} = $e->{'extremes'}->{'y_min'} if !defined($extremes->{'y_min'});
    if ( $e->{'extremes'}->{'y_min'} < $extremes->{'y_min'} ) {
        $extremes->{'y_min'} = $e->{'extremes'}->{'y_min'};
    }

  }
 
  return $extremes;
}












#"area_hollow",
#"bar",
#"bar_3d",
#"bar_fade",
#"bar_glass",
#"bar_sketch",
#"bar_stack",
#"filled_bar",
#"hbar",
#"line",
#"line_dot",
#"line_hollow",
#"pie",
#"scatter",

#############################
sub _____ELEMENTS_____(){}
#############################
package element;
use Carp qw(cluck);

our $AUTOLOAD;
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};

	$self->{'extremes'} = {};
  $self->{'element_props'} =  {
    'type'      => '',
    'values'    => [1.5,1.69,1.88,2.06,2.21],
  };
  return bless $self, $class;
}

sub set_values {
  my ($self, $values_arg) = @_;
  $self->{'element_props'}->{'values'} = $values_arg if defined($values_arg);
  $self->set_extremes();
}

sub set_extremes {
  my ($self) = @_;
  my $extremes = {'x_max' => undef, 'x_min' => undef, 'y_max' => undef, 'y_min' => undef, 'other' => undef};
  for ( @{$self->{'element_props'}->{'values'}} ) {
    if ( ref($_) eq 'HASH' || ref($_) eq 'ARRAY' ) {
      return $extremes;
    }
    $extremes->{'y_max'} = $_ if !defined($extremes->{'y_max'});
    if ( $_ > $extremes->{'y_max'} ) {
      $extremes->{'y_max'} = $_;
    }
    $extremes->{'y_min'} = $_ if !defined($extremes->{'y_min'});
    if ( $_ < $extremes->{'y_min'} ) {
      $extremes->{'y_min'} = $_;
    }
  }
  $self->{'extremes'} = $extremes;
}

sub to_json() {
  my ($self) = @_;
  my $json = main::to_json($self->{'element_props'});
  $json =~ s/,$//g;
  return '{' . $json . '}';
}
sub AUTOLOAD {
	my $self = shift;
	my $type = ref($self) or warn "$self is not an object";

	my $name = $AUTOLOAD;
	$name =~ s/.*://;   # strip fully-qualified portion
	
	if ( $name eq 'values' ) {
	  $self->{'element_props'}->{'values'} = [];
	  cluck "You need to call set_values() instead of plain values().";
	  return undef;
	}
	
	$name =~ s/^set_//; # strip set_
	$name =~ s/^get_//; # strip get_

	unless (exists $self->{'element_props'}->{$name} ) {
	  cluck "'$name' is not a valid property in class $type";
	  return undef;
	}

	if (@_) {
	  return $self->{'element_props'}->{$name} = shift;
	} else {
    return $self->{'element_props'}->{$name};
	}
}
sub DESTROY {  }


package bar_and_line_base;
our @ISA = qw(element);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'colour'} = main::random_color();
  $self->{'element_props'}->{'text'} = 'text';
  $self->{'element_props'}->{'font-size'} = 10;
  return $self;
}





#
#
# LINE TYPES
#
#
package line;
our @ISA = qw(bar_and_line_base);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  $self->{'element_props'}->{'width'} = 2;
  return $self;
}
package line_dot;
our @ISA = qw(line);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  $self->{'element_props'}->{'dot-size'} = 6;
  return $self;
}
package line_hollow;
our @ISA = qw(line);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  $self->{'element_props'}->{'dot-size'} = 8;
  return $self;
}


#
#
# BAR TYPES
#
#
package bar;
our @ISA = qw(bar_and_line_base);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  $self->{'element_props'}->{'alpha'} = 0.5;
  return $self;
}

package bar_3d;
our @ISA = qw(bar);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  return $self;
}

package bar_fade;
our @ISA = qw(bar);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  return $self;
}

package bar_glass;
our @ISA = qw(bar);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  return $self;
}

package bar_sketch;
our @ISA = qw(bar);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  return $self;
}

package bar_outline;
our @ISA = qw(bar);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = 'filled_bar';
  $self->{'element_props'}->{'outline-colour'} = main::random_color();
  return $self;
}

package bar_stack;
our @ISA = qw(bar);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  $self->{'element_props'}->{'text'} = __PACKAGE__ . ' ' . $self->{'element_props'}->{'text'};
  $self->{'element_props'}->{'values'} = [
                    [{"val"=>1},{"val"=>3}],
                    [{"val"=>1},{"val"=>1},{"val"=>2.5}],
                    [{"val"=>5},{"val"=>5},{"val"=>2},{"val"=>2},{"val"=>2,"colour"=>main::random_color()},{"val"=>2},{"val"=>2}]
                   ];
  
  return $self;
}

#stackbar must override set_extremes() because of nested value list
sub set_extremes {
  my ($self) = @_;
  my $extremes = {'x_max' => undef, 'x_min' => undef, 'y_max' => undef, 'y_min' => undef, 'other' => undef};
  for my $v ( @{$self->{'element_props'}->{'values'}} ) {
    my $bar_ext = {'x_max' => undef, 'x_min' => undef, 'y_max' => undef, 'y_min' => undef, 'other' => undef};
    if (ref($v) eq 'ARRAY') {
      for ( @$v ) {
        next if !defined($_->{'val'});
        if ( !defined($bar_ext->{'y_max'}) ) {
          $bar_ext->{'y_max'} = $_->{'val'} ;
        } else {
          $bar_ext->{'y_max'} += $_->{'val'};
        }
      }
    }
    if ( $bar_ext->{'y_max'} > $extremes->{'y_max'} ) {
      $extremes->{'y_max'} = $bar_ext->{'y_max'};
    }
  }
  $self->{'extremes'} = $extremes;
}


package pie;
our @ISA = qw(element);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  $self->{'element_props'}->{'alpha'} = 0.5;
  $self->{'element_props'}->{'colours'} = [main::random_color(), main::random_color(), main::random_color(), main::random_color(), main::random_color()];
  $self->{'element_props'}->{'border'} = 2;
  $self->{'element_props'}->{'animate'} = 1;
  $self->{'element_props'}->{'start-angle'} = 0;	#not working?
  
  $self->{'element_props'}->{'values'} = [ {'value'=>rand(255), 'text'=>'linux'}, {'value'=>rand(255), 'text'=>'windows'}, {'value'=>rand(255), 'text'=>'vax'}, {'value'=>rand(255), 'text'=>'NexT'}, {'value'=>rand(255), 'text'=>'solaris'}];

  return $self;
}


package scatter;
our @ISA = qw(element);
sub new() {
  my ($proto) = @_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  bless $self, $class;
  $self = $self->SUPER::new();
  $self->{'use_extremes'} = 1;	# scatter needs x-y min-maxes to print
  $self->{'element_props'}->{'type'} = __PACKAGE__;
  $self->{'element_props'}->{'values'} = [
    {"x"=>-5,  "y"=>-5 },
    {"x"=>0,   "y"=>0  },
    {"x"=>5,   "y"=>5,  "dot-size"=>20},
    {"x"=>5,   "y"=>-5, "dot-size"=>5},
    {"x"=>-5,  "y"=>5,  "dot-size"=>5},
    {"x"=>0.5, "y"=>1,  "dot-size"=>15}
  ];

  return $self;
}
sub set_extremes {
  my ($self) = @_;
  my $extremes = {'x_max' => undef, 'x_min' => undef, 'y_max' => undef, 'y_min' => undef, 'other' => undef};
  for ( @{$self->{'element_props'}->{'values'}} ) {
    $extremes->{'y_max'} = $_->{'y'} if !defined($extremes->{'y_max'});
    if ( $_->{'y'} > $extremes->{'y_max'} ) {
      $extremes->{'y_max'} = $_->{'y'};
    }
    $extremes->{'y_min'} = $_->{'y'} if !defined($extremes->{'y_min'});
    if ( $_->{'y'} < $extremes->{'y_min'} ) {
      $extremes->{'y_min'} = $_->{'y'};
    }

    $extremes->{'x_max'} = $_->{'x'} if !defined($extremes->{'x_max'});
    if ( $_->{'x'} > $extremes->{'x_max'} ) {
      $extremes->{'x_max'} = $_->{'x'};
    }
    $extremes->{'x_min'} = $_->{'x'} if !defined($extremes->{'x_min'});
    if ( $_->{'x'} < $extremes->{'x_min'} ) {
      $extremes->{'x_min'} = $_->{'x'};
    }

  }
  $self->{'extremes'} = $extremes;
}




#
#
# GENERAL HELPERS
#
#
package main;
sub to_json {
  my ($data_structure, $name) = @_;

  my $tmp='';
  
  if ( defined($name) && $name ne '' ) {
  	$name =~ s/\"/\'/gi;
    $tmp.= "\n\"$name\" : ";
  }
  
  if ( ref $data_structure eq 'ARRAY' ) {
    $tmp.= "[";
    for (@$data_structure) {
      $tmp.= to_json($_,'');
    }
    $tmp =~ s/,$//g;
    $tmp.= "]";
  } elsif ( ref $data_structure eq 'HASH' ) {
    $tmp.= "{" if defined($name);
    for (keys %{$data_structure}) {
      $tmp.= to_json($data_structure->{$_}, $_ || '');
    }
    $tmp =~ s/,$//g;
    $tmp.= "}" if defined($name);
  
  } else {
  	
  	if ( !defined($data_structure) ) {
  		return;
  	}
  	
    if ( $data_structure =~ /^-{0,1}[\d.]+$/ ) {
      #number
      $tmp.= $data_structure;
    } else {
      #not number
      $data_structure =~ s/\"/\'/gi;
      $tmp.= "\"$data_structure\"";
    }
  } 
  
  return $tmp.',';
}

sub random_color {
  my @hex;
  for (my $i = 0; $i < 64; $i++) {
    my ($rand,$x);
    for ($x = 0; $x < 3; $x++) {
      $rand = rand(255);
      $hex[$x] = sprintf ("%x", $rand);
      if ($rand < 9) {
        $hex[$x] = "0" . $hex[$x];
      }
      if ($rand > 9 && $rand < 16) {
        $hex[$x] = "0" . $hex[$x];
      }
    }
  }
  return "\#" . $hex[0] . $hex[1] . $hex[2];
}

# URL-encode string
sub url_escape {
    my($toencode) = @_;
    $toencode=~s/([^a-zA-Z0-9_\-. ])/uc sprintf("%%%02x",ord($1))/eg;
    $toencode =~ tr/ /+/;    # spaces become pluses
    return $toencode;
}


# round the number up a bit to a nice round number
# also changes number to an int
sub smoother {
	my $number = shift;
	my $n = $number;
  
 	if ( $n < 100 ) { $n = $n + (-$n % 10) }
 	elsif ( $n < 500 ) { $n = $n + (-$n % 50) }
 	elsif ( $n < 1000 ) { $n = $n + (-$n % 100) }
 	elsif ( $n < 10000 ) { $n = $n + (-$n % 200) }
 	else { $n = $n + (-$n % 500) }
  $n = int($n);
  
	return $n;
}

1;
