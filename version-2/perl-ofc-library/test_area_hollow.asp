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
$g->{'chart_props'}->{'tooltip'} = {'text'=>'Hollow Tip #val#<br>I See...'};


my $e = $g->get_element('area_hollow');
my $data = [];
for( my $i=0; $i<5; $i++ ) {
	push ( @$data, rand(20) );
}
$e->set_values($data);
$g->add_element($e);

my $f = $g->get_element('area_hollow');
$data = [];
for( my $i=0; $i<5; $i++ ) {
	push ( @$data, rand(40) );
}
$f->set_values($data);
$g->add_element($f);

%>
<html>
  <head>
    <title>OFC Area Hollow Test</title>
  </head>
  <body>
    <h1>OFC Area Hollow Test</h1>
<%
    $Response->write($g->render_swf(600, 400, '?data=1&'.time()));
%>
<!--#INCLUDE FILE = "list_all_tests.inc"-->

</body>
</html>