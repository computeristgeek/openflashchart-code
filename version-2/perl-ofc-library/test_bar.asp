<%@ Language="PerlScript"%>
<% 

# For this test you must have an iis webserver with the perlscript dll installed as a language.
# Also you'll need the open-flash-chart.swf file and the open_flash_chart.pm files together with this one
# and swfobject.js, json/json2.js if you use in-line js (default).

use strict; 
our ($Server, $Request, $Response);
use lib $Server->mappath('.');
use open_flash_chart;

my $g = chart->new();

my $e = $g->get_element('bar');
my $data = [];
for( my $i=0; $i<5; $i++ ) {
	push ( @$data, rand(20) );
}
$e->set_values($data);
$g->add_element($e);

$e = $g->get_element('bar_filled');
my $data = [];
for( my $i=0; $i<5; $i++ ) {
	push ( @$data, rand(40) );
}
$e->set_values($data);
$g->add_element($e);  


my $g2 = chart->new();
my $e2 = $g->get_element('bar_3d');
my $data2 = [];
for( my $i=0; $i<5; $i++ ) {
	push ( @$data2, rand(20) );
}
$e2->set_values($data2);
$g2->add_element($e2);

$e2 = $g2->get_element('bar_glass');
my $data2 = [];
for( my $i=0; $i<5; $i++ ) {
	push ( @$data2, rand(40) );
}
$e2->set_values($data2);
$g2->add_element($e2);  

%>
<html>
  <head>
    <title>OFC Bar Test</title>
  </head>
  <body>
    <h1>OFC Bar Test</h1>
<%
    $Response->write($g->render_swf(600, 400));
    $Response->write('<br>');
    $Response->write($g2->render_swf(600, 200));
%>
<!--#INCLUDE FILE = "list_all_tests.inc"-->

</body>
</html>