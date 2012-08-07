use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'app.pl',
  VERSION      => '1.0',
  AUTHOR       => 'Tycho Bickerstaff <work.tycho@gmail.com>',
  EXE_FILES    => ['lib/main.pl'],
  PREREQ_PM    => {'Dancer' => '1.0'},
  test         => {TESTS => 't/*.t'}
);