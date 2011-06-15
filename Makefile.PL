#!/usr/bin/env perl
use strict;
use warnings;

use inc::Module::Install;

all_from 'lib/Catalyst/Lite.pm';

requires 'Catalyst';
auto_install;
WriteAll;

