
use strict;


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


sub add_element() {
  my ($self, $element) = @_;
  push(@{$self->{'elements'}}, $element);
}


sub render_chart_data() {
  my ($self) = @_;

  my $tmp = ''; #$self->get_page_bootstrap();
  
  if ($self->{'chart_props'}->{'y_axis'}->{'max'} =~ /a/) {
    $self->{'chart_props'}->{'y_axis'}->{'max'} = $self->get_auto_y_max();
  } else {
    $self->{'chart_props'}->{'y_axis'}->{'max'} = 100;
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
# control how the auto y_max works
#
# @param $smooth_rounding an int argument.
#   1 or 0: rounds the y_max to the nearest 10, 50, 100, 200, or 500
# @param $head_room an decimal argument.
#   defines how much extra y scale you want above your highest data point
#   defaults to 0.1 (or 10%) extra space at the top of a chart
sub get_auto_y_max() {
  my ($self, $smooth_rounding, $head_room) = @_;
  $smooth_rounding = 1 if !defined($smooth_rounding);
  $head_room = 0.1 if !defined($head_room);
  my $max = undef;
    
  for my $e ( @{$self->{'elements'}} ) {
    my $e_max = $e->get_max_value();
    $max = $e_max if !defined($max);
    if ( $e_max > $max ) {
        $max = $e_max;
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
  
  return $max;
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

  $self->{'element_props'} =  {
    'type'      => '',
    'values'    => [1.5,1.69,1.88,2.06,2.21],
  };
  return bless $self, $class;
}

sub get_max_value {
  my ($self) = @_;
  my $max = undef;
  for ( @{$self->{'element_props'}->{'values'}} ) {
    $max = $_ if !defined($max);
    if ( $_ > $max ) {
      $max = $_;
    }
  }
  return $max || 10;  
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

#stackbar must override get_max_value() because of nested value list
sub get_max_value {
  my ($self) = @_;
  my $max;
  for my $v ( @{$self->{'element_props'}->{'values'}} ) {
    my $bar_max;
    if (ref($v) eq 'ARRAY') {
      for ( @$v ) {
        next if !defined($_->{'val'});
        if ( !defined($bar_max) ) {
          $bar_max = $_->{'val'} ;
        } else {
          $bar_max += $_->{'val'};
        }
        }
      }
      if ( $bar_max > $max ) {
        $max = $bar_max;
      }
   }
  return $max;
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
    if ( $data_structure =~ /^[\d.]+$/ ) {
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

1;
