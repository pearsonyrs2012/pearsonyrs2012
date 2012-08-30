package datasets::generalsubs;
use strict;
use warnings;
use filerequests;
sub pizza {
	my ($lat,$long) = @_;
	my $url = 'https://maps.googleapis.com/maps/api/place/search/json?location='.$lat.','.$long.'&radius=2000&types=food&sensor=true&key=AIzaSyDdTCCT8WlzCIzqbmfWsTlWGZ6N5UFQ_Lg&keyword=pizza';
	my $json = filerequests::getfile($url);
	return $json if defined($json->{error});
	#warn "got json:$json->{content}";
	my $hash = from_json($json->{content});
	warn "got google hash";
	my $level = @{$hash->{results}};
	return {name => 'pizza', presentation_name => 'Pizza', level => $level / 5, results => $hash->{results} } ;
}

sub police {
	my ($lat,$long) = @_;
	my $url = "http://policeapi2.rkh.co.uk/api/crimes-at-location?date=2012-02&lat=$lat&lng=$long";
	my $json = filerequests::getfileauth($url);
	return $json if defined($json->{error});
	#warn "got json:$json->{content}";
	my $array = from_json($json->{content});
	warn "got police";
	my $level = @{$array};
	return {name => 'crime', presentation_name => 'Crime', level => $level} ;
}

1;