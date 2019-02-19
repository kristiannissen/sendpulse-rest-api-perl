#!/usr/bin/perl

use 5.10.0;
use strict;
use warnings;
use diagnostics;

use FindBin qw($Bin);
use lib "$Bin/../";

# use Test::More;
# use Test::Output;

use Data::Dumper;

use SendPulse::RestApi;

my $api = SendPulse::RestApi->new(
        client_secret => "kitty",
        client_id => "Hello"
    );

say Dumper($api);
