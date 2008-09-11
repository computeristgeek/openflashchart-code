<%@ Language="PerlScript"%>
<% 

# For this test you must have an iis webserver with the perlscript dll installed as a language.
# Also you'll need the open-flash-chart.swf file and the open_flash_chart.pm files together with this one
#

use strict; 
our ($Server, $Request, $Response);
use lib $Server->mappath('.');
use open_flash_chart qw(random_color);

my $g = chart->new();
  
my $e = $g->get_element('bar_stack');

my $colors = get_random_colors(5);
$e->set_values([
  [{"val"=>rand(20),"colour"=>$colors->[0]},{"val"=>rand(40),"colour"=>$colors->[1]}],
  [{"val"=>rand(20),"colour"=>$colors->[0]},{"val"=>rand(20),"colour"=>$colors->[1]},{"val"=>rand(20),"colour"=>$colors->[2]}],
  [{"val"=>rand(10),"colour"=>$colors->[0]},{"val"=>rand(20),"colour"=>$colors->[1]},{"val"=>rand(30),"colour"=>$colors->[2]}],
  [{"val"=>rand(20),"colour"=>$colors->[0]},{"val"=>rand(20),"colour"=>$colors->[1]},{"val"=>rand(20),"colour"=>$colors->[2]}],
  [{"val"=> rand(5),"colour"=>$colors->[0]},{"val"=>rand(10),"colour"=>$colors->[1]},{"val"=> rand(5),"colour"=>$colors->[2]},{"val"=>rand(20),"colour"=>$colors->[3]},{"val"=>rand(5),"colour"=>$colors->[4]}]
 ]);  

$g->add_element($e);

%>
<html>
  <head>
    <title>OFC Stack Bar Test</title>
  </head>
  <body>
    <h1>OFC Stack Bar Test</h1>
<%
  $Response->write($g->render_swf(600, 400));
%>
<!--#INCLUDE FILE = "list_all_tests.inc"-->
</body>
</html>