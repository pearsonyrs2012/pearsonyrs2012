use strict;
use warnings;
use Dancer;
use Data::Dumper;
get '/:lat,:long' => sub {
my $filepath = '51.4971,-0.1382.13827'; #get file
#fixmystreeturl: www.fixmystreet.com/rss/l/:lat,:long/:dist
open(my $file, $filepath);
my %categorys;
while(<$file>) {
	next unless /<category>([^<]*)<\/category>/;
	my $category = $1;
	$categorys{$category}++;
}
Dumper \%categorys;
};
dance;
