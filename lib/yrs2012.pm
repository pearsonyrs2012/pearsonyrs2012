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
warn 'got params: ', param('lat'),',',param('long'),"\n";
my $crossover = 3;
my $filepath = 'http://www.fixmystreet.com/rss/l/'.param('lat').','.param('long').'/2';#get file
#fixmystreeturl: www.fixmystreet.com/rss/l/:lat,:long/:dist
my $response = getfile($filepath);
return to_json $response if defined($response->{error});
my @lines = split("\n",$response->{content});
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
	$item{presentation_name} = $category;
	$item{level} = $categories{$category} > $crossover ? "1": "0";
	push @overview, \%item;
}
	my $item = pizza(param('lat'),param('long'));
	$item->{level} = $item->{level} > $crossover ? "1": "0";
	push @overview, $item;
	return to_json \@overview;

};

sub pizza {
	my ($lat,$long) = @_;
	my $url = 'https://maps.googleapis.com/maps/api/place/search/json?location='.$lat.','.$long.'&radius=2000&types=food&sensor=true&key=AIzaSyDdTCCT8WlzCIzqbmfWsTlWGZ6N5UFQ_Lg&keyword=pizza';
	my $json = getfile($url);
	my $hash = from_json($json->{content});
	warn "got google hash";
	my $level = length(@{$hash->{results}});
	return {name => 'pizza', presentation_name => 'Pizza', level => $level } ;
}
   
    


sub getfile {
my ($url) = @_;
warn "getting file $url \n";
my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
my $response = $ua->get($url);
return {error => "unable to download"} if not $response->is_success;
my $content = $response->content;
return {error => "invalid url $url"} unless defined $content;
return {content => $content};
warn "got file $url \n";
}

true;
