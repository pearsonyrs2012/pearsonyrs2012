use strict;
use warnings;
use Data::Dumper;
my $filepath = 'fatalaccidentdata.origin.csv';
open(my $file,$filepath);
my $line;
my @data;
while($line = <$file>) {
	my @feilds = split(',',$line);
	shift @feilds;
	push @data,\@feilds;
}
	print Dumper \@data;