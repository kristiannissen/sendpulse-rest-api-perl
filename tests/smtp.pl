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

my $api = SendPulse::RestApi->new(
        client_secret => $client_secret,
        client_id => $client_id
    );

## TODO test make_get_request works
my ($code, $response) = $api->make_get_request(
    "https://api.sendpulse.com/smtp/emails/total",
    [],
    []
);
ok ($code eq 400, "Test bad request code");
ok (exists($response->{'error'}), "Test bad request response");

## TODO test that the request_token works
($code, $response) = $api->request_access_token();

ok ($code eq 200, "Test getting a request token");

## TODO test total emails sent
# my ($code, $response) = $api->get_total_emails_sent();
# ok ($code eq 200, "Test getting total emails sent");

## Done testing
done_testing(plan());
