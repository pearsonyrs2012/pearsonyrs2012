package yrs2012;
use Dancer ':syntax';
use strict;
use warnings;
use templates;
use api;

our $VERSION = '0.1';

set layout => 'main';
set template => 'template_toolkit';

# get '/info' => sub {
# return to_json ({layout => setting('layout'), 'template engine' => setting('template') });
# };

true;
