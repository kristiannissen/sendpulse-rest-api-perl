#!/usr/bin/perl

use 5.10.0;
use strict;
use warnings;
use diagnostics;
use Carp qw(carp croak);

use FindBin qw($Bin);
use lib "$Bin/../";

use Test::More;

use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($DEBUG);

use Data::Dumper;

use SendPulse::RestApi;

# Accept id and secret
my ($client_id, $client_secret, $sender, $receiver) = @ARGV;

# Test class
my $api = SendPulse::RestApi->new();
isa_ok (ref($api), 'SendPulse::RestApi', 'Class setup');

# Test getters/setters
$api->set_client_secret($client_secret);
ok ($api->get_client_secret eq $client_secret, 'Changing client secret');

$api->set_client_id($client_id);
ok ($api->get_client_id eq $client_id, 'Changing client id');

# Test getting a request token
like ($api->get_request_token, qr/\S{0,}/, 'Test token');

# We are done testing
done_testing(plan());
