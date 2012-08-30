package templates;
use Dancer ':syntax';
use strict;
use warnings;

get qr{/index(\.html?)?}			=> sub { forward '/'; 				};
get qr{/2[nN][dD]page(\.html?)?} 	=> sub { redirect '/overview' 301; 	};
get '/geo' 							=> sub { send_file '/geo.html';		};

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

get '/overview' => sub {
	return template 'overview', {
		Page => 'overview',
		Highlight => {
						Highlevel => 1,
						Lowlevel => 1,
						Danger => 0,
						Newsfeeds => 0,
						Settings => 0
						}
		} ;