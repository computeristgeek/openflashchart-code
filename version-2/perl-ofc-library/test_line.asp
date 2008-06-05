<%@ Language="PerlScript"%>
<% 

# For this test you must have an iis webserver with the perlscript dll installed as a language.
# Also you'll need the open-flash-chart.swf file and the open_flash_chart.pm files together with this one
#

use strict; 
our ($Server, $Request, $Response);
use lib $Server->mappath('.');
use open_flash_chart;

my $g = chart->new();

if ( $Request->QueryString("data")->Item == 1 ) {

  my $line = line->new();
  my $data = [];
	for( my $i=0; $i<5; $i++ ) {
		push ( @$data, rand(20) );
	}
  $line->values($data);
  $g->add_element($line);
  
  $line = line_dot->new();
  my $data = [];
	for( my $i=0; $i<5; $i++ ) {
		push ( @$data, rand(30) );
	}
  $line->values($data);
  $g->add_element($line);


  $line = line_hollow->new();
  my $data = [];
	for( my $i=0; $i<5; $i++ ) {
		push ( @$data, rand(40) );
	}
  $line->values($data);
  $g->add_element($line);
  
  
	$Response->write($g->render_chart_data());
  $Response->exit();

} else {
  
%>
<html>
  <head>
    <title>OFC Line Test</title>
  </head>
  <body>
    <h1>OFC Line Test</h1>
<%
  $Response->write($g->render_swf(600, 400, 'http://mets-outbounddev.web.boeing.com/portal/page/charts/test/test_line.asp?data=1'));
%>
<!--#INCLUDE FILE = "list_all_tests.inc"-->
</body>
</html>
<%  
}
%>
