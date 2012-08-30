package filerequests;
use strict;
use warnings;
use Dancer ':syntax';
use LWP::UserAgent;

sub getfile {
    my ($url) = @_;
    warn "getting file $url \n";
    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    $ua->env_proxy;
    my $response = $ua->get($url);
    warn "failed to download file" && send_error (to_json ({error => "unable to download:".$response->status_line}),512) if not $response->is_success;
    my $content = $response->content;
    warn "invalid url $url" && return send_error (to_json ({error => "invalid url $url"}),512) unless defined $content;
    warn "got file $url \n";
    return {content => $content};

}

sub getfileauth {
    my ($url) = @_;
    warn "getting file $url \n";
		return {content => to_json([])};
	my $ua = LWP::UserAgent->new(
        agent => 'curl/7.21.4 (universal-apple-darwin11.0) libcurl/7.21.4 OpenSSL/0.9.8r zlib/1.2.5'
    );
	$ua->credentials(
  'policeapi2.rkh.co.uk:80',
  '',
  'surot85' => '521b5e3021fe8dfd510a7db6ac662f2a'
);
    $ua->timeout(10);
    $ua->env_proxy;
    my $response = $ua->get($url);
    warn "failed to download file" && send_error (to_json({error => "unable to download:".$response->status_line}),512) if not $response->is_success;
    my $content = $response->content;
    warn "invalid url $url" && return send_error (to_json({error => "invalid url $url"}),512) unless defined $content;
    warn "got file $url \n";
    return {content => $content};

}

1;