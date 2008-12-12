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
my $y_axis = $g->get_axis('y_axis');

my $e = $g->get_element('line');

my $data = [];
for( my $i=0; $i<5; $i++ ) {
	push ( @$data, rand(20) );
}
$e->set_values($data, 0);
$y_axis->add_element($e);

$e = $g->get_element('line_dot');
my $data = [];
for( my $i=0; $i<5; $i++ ) {
	push ( @$data, rand(30) );
}
$e->set_values($data, 0);
$y_axis->add_element($e);


$e = $g->get_element('line_hollow');
my $data = [];
for( my $i=0; $i<5; $i++ ) {
	push ( @$data, rand(40) );
}
$e->set_values($data, 0);
$y_axis->add_element($e);

%>
<html>
  <head>
    <title>OFC Line Test</title>
  </head>
  <body>
    <h1>OFC Line Test</h1>
<%
  $Response->write($g->render_swf({'width'=>600, 'height'=>400}));
%>
<!--#INCLUDE FILE = "list_all_tests.inc"-->
</body>
</html>