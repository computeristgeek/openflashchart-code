#!C:/perl/bin/perl -w

use open_flash_chart;


my $g = chart->new();
my $e = $g->get_element('bar');
$g->add_element($e);

print STDERR $g->render_chart_data();
print STDERR "\n\n\n";
print STDERR $g->render_swf();
print STDERR $g->render_swf();


my $g1 = chart->new();
my $e = $g1->get_element('bar');
$g1->add_element($e);

print STDERR $g1->render_chart_data();
print STDERR "\n\n\n";
print STDERR $g1->render_swf();
print STDERR $g1->render_swf();
