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
                "client_id" => $client_id,
                "client_secret" => $client_secret,
                "grant_type" => "client_credentials"
        ])} "Test Authorized";

# Test Authorization token
# Pass is wrong secret
$api->client_secret("HelloKitty");
dies_ok {$api->request_token()} "Wrong Request Authorization token";

# Change to corret secret
$api->client_secret($client_secret);
lives_ok {$api->request_token()} "Correct Request Authorization token";

# Test send_emails

my %email_data = (
    "html" => "Hello Kitty in rich html",
    "text" => "Hello Kitty in plain text",
    "subject" => "Hello from the Kitty",
    "from" => {
        "name" => "Kitty",
        "email" => 'formand@espegaarden.dk'
    },
    "to" => [
        {"email" => 'kristian.nissen@gmail.com',},
        {"email" => 'kn@unisport.dk'}
    ]
);

ok $api->send_emails(%email_data) eq 1, "Email data succes";

# Done testing
done_testing();
