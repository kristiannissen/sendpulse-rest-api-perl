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
use Test::Exception;

use Data::Dumper;

use SendPulse::RestApi;

# Accept id and secret
my ($client_id, $client_secret) = @ARGV;

my $api = SendPulse::RestApi->new(
        client_secret => $client_secret,
        client_id => $client_id
    );

# Property assigning
ok ($api->client_id eq $client_id, "Assign client id");

ok ($api->client_secret eq $client_secret, "Assign client secret");


# Test wrong credentials
dies_ok {$api->make_request("https://api.sendpulse.com/oauth/access_token", [])} "Test Unauthorized";

# Test correct credentials
lives_ok {$api->make_request("https://api.sendpulse.com/oauth/access_token", [
                "client_id" => "",
                "client_secret" => ""
        ])} "Test Authorized";

# Test Authorization token
dies_ok {$api->request_token()} "Request Authorization token";

# Done testing
done_testing();
