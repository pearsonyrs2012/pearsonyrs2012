#!/usr/bin/env perl
use strict;
use warnings;
use LWP::UserAgent;
use Dancer ":syntax";
#use Data::Dumper;
get '/:lat/:long/' => sub {
my $filepath = 'http://www.fixmystreet.com/rss/l/'.param('lat').','.param('long').'/2';#get file
#fixmystreeturl: www.fixmystreet.com/rss/l/:lat,:long/:dist
my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
my $response = $ua->get($filepath);
return "" if not $response->is_success;
my $content = $response->content;
return "invalid url $filepath" unless defined $content;
my @lines = split("\n",$content);
my %categorys;
my $line;
while(defined($line =shift(@lines))) {
	next unless $line =~ /<category>([^<]*)<\/category>/;
	my $category = $1;
	$categorys{$category}++;
}

to_json \%categorys;
};
dance;
