package api;
use Dancer ':syntax';
use strict;
use warnings;
use datasets::accidents;
use datasets::generalsubs;
use filerequests;

get '/api/settings/colour/:colour/' => sub {
	my $cookie = cookie 'settings';
	my $settings = from_json $cookie if defined($cookie);
	$settings->{backcolour} = param('colour');
	cookie 'settings' => to_json($settings), expires => '1 week';
    return to_json($settings);    

};

get '/api/settings/' => sub {
	my $cookie = cookie 'settings';
	return $cookie if defined($cookie);
	my $settings = { backcolour => '#FFFFFF' , cookies => 0};
    return to_json($settings);    
};

get '/api/settings/cookies/:value/' => sub {
	my $cookie = cookie 'settings';
	my $settings = from_json $cookie if defined($cookie);
	$settings = { backcolour => '#FFFFFF' , cookies => 0} if not defined($cookie);
	$settings->{cookies} = param('value');
	warn 'param:' . param('value');
	if (param('value') eq '0') {
	warn 'deleting cookie';
	cookie ('settings' => '', expires => 'Thu, Jan 01 1970 00:00:00 UTC');
	return to_json($settings);
	}
	cookie 'settings' => to_json($settings), expires => '1 week';
    return to_json($settings);    

};

get '/api/cats/:lat/:long/' => sub {
    my $filepath = 'http://www.fixmystreet.com/rss/l/'.param('lat').','.param('long').'/2';#get file
    #fixmystreeturl: www.fixmystreet.com/rss/l/:lat,:long/:dist
    my $response = filerequests::getfile($filepath);
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
        $item{name} =~ s/ //g;
        $item{presentation_name} = $category;
        $item{level} = $categories{$category};
        push @overview, \%item;
    }
    my $item = datasets::generalsubs::pizza(param('lat'),param('long'));
    return to_json $item if defined $item->{error};
    push @overview, $item;
    $item = datasets::accidents::query(param('lat'),param('long'));
    push @overview, $item;
	content_type 'application/json';
    to_json \%categories;

};

get '/api/home/:lat/:long/' => sub {
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
        $item{name} =~ s/ //g;
        $item{presentation_name} = $category;
        $item{level} = $categories{$category};
        push @overview, \%item;
    }
    my $item = datasets::generalsubs::pizza(param('lat'),param('long'));
    return to_json $item if defined $item->{error};
    push @overview, $item;
    $item = datasets::accidents::query(param('lat'),param('long'));
	return to_json $item if defined $item->{error};
    push @overview, $item;
	$item = datasets::generalsubs::police(param('lat'),param('long'));
    return to_json $item if defined $item->{error};
    push @overview, $item;
	my $bigest = $overview[1];
	my $secondbigist = $overview[2];
	my $lowist = $overview[0];
	for $item (@overview) {
		if ($item->{level} >= $bigest->{level}) {
			$secondbigist = $bigest;
			$bigest = $item;
		} elsif ($item->{level} < $lowist->{level}) {
			$lowist = $item;
		}
	}
	content_type 'application/json';
    to_json {bigest => $bigest, secondbigist => $secondbigist, lowist => $lowist};
};

get '/api/overview/:lat/:long/' => sub {
    warn 'got params: ', param('lat'),',',param('long'),"\n";
    my $crossover = 3;
    my $filepath = 'http://www.fixmystreet.com/rss/l/'.param('lat').','.param('long').'/2';#get file
    #fixmystreeturl: www.fixmystreet.com/rss/l/:lat,:long/:dist
    my $response = filerequests::getfile($filepath);
    return to_json $response if defined($response->{error});
    my @lines = split("\n",$response->{content});
    my %categories;
    my $line;
    while(defined($line =shift(@lines))) {
        next unless $line =~ /<category>([^<]*)<\/category>/;
        my $category = $1;
        $categories{$category}++;
		if ($category eq "Dumped rubbish" || $category eq "Refuse collection" || $category eq "Litter bin") {
		$categories{'Rubbish'}++;
		}
    }
    my @overview;
    my $category;
    for $category (keys %categories) {
        my %item;
        $item{name} = lc($category);
        $item{name} =~ s/ //g;
        $item{presentation_name} = $category;
        $item{level} = ($categories{$category} > $crossover) ? "1": "0";
        push @overview, \%item;

    }
    my $item = datasets::generalsubs::pizza(param('lat'),param('long'));
    return to_json $item if defined $item->{error};
	$item->{rawlevel} = $item->{level};
    $item->{level} = ($item->{level} > $crossover) ? "1": "0";
    push @overview, $item;
    $item = datasets::accidents::query(param('lat'),param('long'));
    return to_json $item if defined $item->{error};
    $item->{level} = ($item->{level} > $crossover) ? "1": "0";
    push @overview, $item;
	$item = datasets::generalsubs::police(param('lat'),param('long'));
    return to_json $item if defined $item->{error};
    $item->{level} = ($item->{level} > $crossover) ? "1": "0";
    push @overview, $item;
	content_type 'application/json';
    return to_json \@overview;

};

get '/api/map/accidents/:lat/:long/' => sub {
	my ($lat,$long) = (param('lat'),param('long'));
	return to_json(datasets::accidents::getpoints($lat,$long)) ;
	};