#!/usr/bin/perl

use 5.10.0;
use strict;
use warnings;
use diagnostics;
use Carp qw(carp croak);

use FindBin qw($Bin);
use lib "$Bin/../";

use Test::More;
use Test::Output;

use Data::Dumper;

use SendPulse::RestApi;

# Accept id and secret
my ($client_id, $client_secret) = @ARGV;

my $api = SendPulse::RestApi->new(
        client_secret => $client_secret,
        client_id => $client_id
    );

# dies_ok{$api->request_token()} "API authentication error";

# Test if no or empty data is passed
my %email_data = ();

$api->send_emails(%email_data);

%email_data = (
    "html" => "<p>Hello Kitty</p>"
);

ok($api->send_emails(%email_data) eq "hello", "Testing send emails");

# Done testing
done_testing();
