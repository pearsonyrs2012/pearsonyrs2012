use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'yrs2012',
    AUTHOR              => q{Tycho Bickerstaff <work.tycho@gmail.com>},
    VERSION_FROM        => 'lib/yrs2012.pm',
    ABSTRACT            => 'YOUR APPLICATION ABSTRACT',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'YAML'       => 0,
        'JSON'       => 0,
        'Dancer'     => 1.3098,
		'LWP::UserAgent' => 6.04,
		'LWP::Protocol::https' => 0
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'yrs2012-*' },
);
