<%@ Language="PerlScript"%>
<html><head><title>Test OpenFlashCharts</title></head><body><h1>Test OpenFlashCharts</h1>
<% 

# For this test you must have an iis webserver with the perlscript dll installed as a language.
# Also you'll need the open-flash-chart.swf file and the open_flash_chart.pm files together with this one
#

use strict; 
our ($Server, $Request, $Response);
use lib $Server->mappath('.');
use open_flash_chart;

if ( $Request->QueryString("data")->Item == 1 ) {
  my $g = graph->new();
  $g->title( '2008 Hours Wasted Programming By Month', '{font-size: 20px;}' );


  my $bar = bar_outline->new(50, '#9933CC', '#8010A0');
  $bar->key('Java', 10);
  my $data = [];
  for( my $i=0; $i<12; $i++ ) {
    $bar->add(int(rand(3600)), undef);
  }
  push(@{$g->{data_sets}}, $bar);
 
  
  $bar = bar_outline->new(50, '#639F45', '#000000');
  $bar->key('Perl', 10);
  my $data = [];
  for( my $i=0; $i<12; $i++ ) {
    $bar->add(int(rand(2100)), undef);
  }
  push(@{$g->{data_sets}}, $bar);  
  
  
  my $line = line_hollow->new(6, 10, '#000000', 'Happiness', 14, 1);
  # $width, $colour, $text, $size, $circles
  #$line->key('Happiness', 10);
  my $data = [];
  for( my $i=0; $i<12; $i++ ) {
    $line->add(1000 + int(rand(1000)), undef);
  }
  push(@{$g->{data_sets}}, $line);
  
  
  

	$g->set_x_legend( 'Bar Outline Chart', 14, '#000000' );

	$g->set_x_labels( ['Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec'] );
	$g->set_y_min( 0 );

	$g->y_label_steps( 10 );
	$g->set_y_legend( 'Open Flash Chart', 12, '0x736AFF' );

	$Response->write($g->render());
} elsif ( $Request->QueryString("data")->Item == 2 ) {
	#
	my @pie_data;

	for( my $i=0; $i<5; $i++ ) {
		push ( @pie_data, rand(5) );
	}

  my $g = graph->new();
  $g->pie(60,'#505050','{font-size: 15px; color: #000000;}');
	$g->title( 'Open Flash Chart - Pie Test', '{font-size: 15px; color: #800000}' );

	$g->pie_values( \@pie_data, ['777', 'MD-11', '737', '747-400', 'Airbus'], [] );
  $g->pie_slice_colours( ['#ff0000','#ff6600','#ff9900','#ffcc00','#ffff00']);
	$Response->write($g->render());
} else {
  my $width = '100%';
  my $height = 600;
 	$Response->write('<div style="border: 1px solid #784016;">');
  $Response->write( graph::swf_object( $width, $height, "test_bar.asp?data=1" ));
  $Response->write("</div>");

 	$Response->write('<div style="margin-top: 20px; border: 1px solid #784016;">');
  $Response->write( graph::swf_object( $width, $height, "test_bar.asp?data=2" ));
  $Response->write("</div>");
  
}

%>
</body>
</html>