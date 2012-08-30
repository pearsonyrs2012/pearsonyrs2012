package templates;
use Dancer ':syntax';
use strict;
use warnings;

get '/' => sub {
	return template 'index', {
		Javascripts => '<!-- <script type="text/javascript" src="javascripts/soundmanager/script/soundmanager2.js"></script> !-->', 
		Page => 'index',
		Highlight => {
						Highlevel => 0,
						Lowlevel => 0,
						Danger => 0,
						Newsfeeds => 0,
						Settings => 0
						}
		} ;
};

get '/geo' => sub {
    send_file '/geo.html';
};