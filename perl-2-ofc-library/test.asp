<%@ Language="PerlScript"%>
<html><head><title>Test Chart</title></head><body><h1>Test Chart</h1>
<% 

# For this test you must have an iis webserver with the perlscript dll installed as a language.
# Also you'll need the open-flash-chart.swf file and the open_flash_chart.pm files together with this one
#

use strict; 
our ($Server, $Request, $Response);
use lib $Server->mappath('.');
use open_flash_chart;

if ( $Request->QueryString("data")->Item == 1 ) {
	#
	# NOTE: how we are filling 3 arrays full of data,
	#       one for each bar on the graph
	#
	my @data_1;
	my @data_2;
	my @data_3;

	for( my $i=0; $i<12; $i++ ) {
		push ( @data_1, rand(10) );
		push ( @data_2, rand(20) );
		push ( @data_3, rand(2000) );
	}

  my $g = graph->new();

	$g->title( 'Open Flash Chart - Testing 123', '{font-size: 15px; color: #800000}' );

	$g->set_data( \@data_1 );
	$g->bar( 50, '0x0066CC', 'Me', 10 );

	$g->set_data( \@data_2 );
	$g->bar( 50, '0x9933CC', 'You', 10 );

	$g->set_data( \@data_3 );
	$g->bar( 50, '0x639F45', 'Them', 10 );


	$g->set_x_labels( ['Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec'] );
	#$g->set_y_max( 10 );
	$g->set_y_min( 0 );

	$g->y_label_steps( 1 );
	$g->set_y_legend( 'Open Flash Chart', 12, '0x736AFF' );

	$Response->write($g->render());



} else {
  my $width = 600;
  my $height = 600;
  $Response->write( graph::swf_object( $width, $height, "test.asp?data=1" ));
}

%>
</body>
</html>