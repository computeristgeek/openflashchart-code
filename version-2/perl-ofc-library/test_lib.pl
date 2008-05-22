#!C:/perl/bin/perl -w

use open_flash_chart;


my $g = chart->new();
  
my $bar = bar_stack->new();
$g->add_element($bar);



print $g->render_chart_data();
