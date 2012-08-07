use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'lib/parse.pl',
  VERSION      => '1.0',
  AUTHOR       => 'Tycho Bickerstaff <work.tycho@gmail.com>',
  EXE_FILES    => ['lib/parse.pl'],
  PREREQ_PM    => {'Dancer' => '1.3098', 'LWP::UserAgent' => '6.03'},
  test         => {TESTS => 't/*.t'}
);