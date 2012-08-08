package yrs2012;
use Dancer ':syntax';
use LWP::UserAgent;
our $VERSION = '0.1';

get '/' => sub {
	send_file '/HomepageWithIcons.html';
};
get '/geo' => sub {
    send_file '/geo.html';
};

get '/api/cats/:lat/:long/' => sub {
my $filepath = 'http://www.fixmystreet.com/rss/l/'.param('lat').','.param('long').'/2';#get file
#fixmystreeturl: www.fixmystreet.com/rss/l/:lat,:long/:dist
my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
my $response = $ua->get($filepath);
return to_json({error => "unable to download"}) if not $response->is_success;
my $content = $response->content;
return to_json({error => "invalid url $filepath"}) unless defined $content;
my @lines = split("\n",$content);
my %categories;
my $line;
while(defined($line =shift(@lines))) {
	next unless $line =~ /<category>([^<]*)<\/category>/;
	my $category = $1;
	$categories{$category}++;
}

to_json \%categories;

};


get '/api/overview/:lat/:long/' => sub {
my $crossover = 3;
my $filepath = 'http://www.fixmystreet.com/rss/l/'.param('lat').','.param('long').'/2';#get file
#fixmystreeturl: www.fixmystreet.com/rss/l/:lat,:long/:dist
my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
my $response = $ua->get($filepath);
return to_json({error => "unable to download"}) if not $response->is_success;
my $content = $response->content;
return to_json({error => "invalid url $filepath"}) unless defined $content;
my @lines = split("\n",$content);
my %categories;
my $line;
while(defined($line =shift(@lines))) {
	next unless $line =~ /<category>([^<]*)<\/category>/;
	my $category = $1;
	$categories{$category}++;
}
my @overview;
my $category;
for $category (keys %categories) {
	my %item;
	$item{name} = lc($category);
	$item{pressentaionname} = $category;
	$item{level} = $categories{$category} > $crossover ? "1": "0";
	push @overview, \%item;
}

to_json \@overview;

};

get '/api/pizzzzzzzza' => sub {
    my $url ="https://maps.googleapis.com/maps/api/place/search/json?location=51.5,0.1&radius=2000&types=food&sensor=true&key=AIzaSyDdTCCT8WlzCIzqbmfWsTlWGZ6N5UFQ_Lg&keyword=pizza";

    # TODO This is for you to edit Tycho!
};

true;
