package yrs2012;
use Dancer ':syntax';
use LWP::UserAgent;
our $VERSION = '0.1';

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
	my $settings = { backcolour => '#FFFFFF'};
	cookie 'settings' => to_json($settings), expires => '1 week';
    return to_json($settings);    
}

get '/' => sub {
	send_file '/index.html';
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
    my $item = pizza(param('lat'),param('long'));
    return to_json $item if defined $item->{error};
    push @overview, $item;
    $item = accident(param('lat'),param('long'));
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
    my $item = pizza(param('lat'),param('long'));
    return to_json $item if defined $item->{error};
    push @overview, $item;
    $item = accident(param('lat'),param('long'));
    push @overview, $item;
	my $bigest;
	my $secondbigist;
	my $lowist = @overview[0];
	for $item (@overview) {
		if ($item->{level} > $bigest->{level}) {
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
        $item{name} =~ s/ //g;
        $item{presentation_name} = $category;
        $item{level} = ($categories{$category} > $crossover) ? "1": "0";
        push @overview, \%item;
    }
    my $item = pizza(param('lat'),param('long'));
    return to_json $item if defined $item->{error};
	$item->{rawlevel} = $item->{level};
    $item->{level} = ($item->{level} > $crossover) ? "1": "0";
    push @overview, $item;
    $item = accident(param('lat'),param('long'));
    return to_json $item if defined $item->{error};
    $item->{level} = ($item->{level} > $crossover) ? "1": "0";
    push @overview, $item;
	content_type 'application/json';
    return to_json \@overview;

};

sub pizza {
	my ($lat,$long) = @_;
	my $url = 'https://maps.googleapis.com/maps/api/place/search/json?location='.$lat.','.$long.'&radius=2000&types=food&sensor=true&key=AIzaSyDdTCCT8WlzCIzqbmfWsTlWGZ6N5UFQ_Lg&keyword=pizza';
	my $json = getfile($url);
	return $json if defined($json->{error});
	#warn "got json:$json->{content}";
	my $hash = from_json($json->{content});
	warn "got google hash";
	my $level = @{$hash->{results}};
	return {name => 'pizza', presentation_name => 'Pizza', level => $level, results => $hash->{results} } ;
}

sub accident {
	my ($lat,$long) = @_;
	my $filepath = '/app/public/data/fatalaccidentdata.csv';
	
	open(my $file,$filepath) || (warn "could not open accidentdata.csv: $!" && send_error( {error => "could not get accedent data", code => $!},500));
	my $line;
	my @data;
	while($line = <$file>) {
	my @feilds = split(',',$line);
	shift @feilds;
	push @data,\@feilds;
	}
	#return \@data;
	shift @data;
	my $item;
	my $count = 0;
	for $item (@data) {
		if ($lat + 0.01 <$item->[3] && $item->[3] > $lat - 0.01) {
			if ($lat + 0.01 <$item->[2] && $item->[2] > $lat - 0.01) {
			 $count++;
		}
		}
	}
	return {name => 'accidents', presentation_name => 'Accidents', level => $count } ;
}
   

sub getfile {
    my ($url) = @_;
    warn "getting file $url \n";
    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    $ua->env_proxy;
    my $response = $ua->get($url);
    warn "failed to download file" && send_error ({error => "unable to download:".$response->status_line},500) if not $response->is_success;
    my $content = $response->content;
    warn "invalid url $url" && return send_error ({error => "invalid url $url"},500) unless defined $content;
    warn "got file $url \n";
    return {content => $content};

}

true;
