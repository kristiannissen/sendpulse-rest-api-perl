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

# Property assigning
ok ($api->client_id eq $client_id, "Assign client id");

ok ($api->client_secret eq $client_secret, "Assign client secret");

# Test wrong credentials
my $error = $api->make_request("https://api.sendpulse.com/oauth/access_token", []);

ok ($error->{error_code} eq 1, "Test Unauthorized");

# Test correct credentials
my $success = $api->make_request("https://api.sendpulse.com/oauth/access_token", [
                "client_id" => $client_id,
                "client_secret" => $client_secret,
                "grant_type" => "client_credentials"
        ]);

ok ($success->{http_status_code} eq "200", "Test Authorized");

# Test Authorization token
# Pass is wrong secret
$api->client_secret("HelloKitty");

ok ($api->request_token() eq 0, "Wrong Request Authorization token");

# Change to corret secret
$api->client_secret($client_secret);

ok ($api->request_token() eq 1, "Correct Request Authorization token");

# Test send_emails

my %email_data = (
    "html" => "Hello Kitty in html",
    "text" => "Hello Kitty in plain text",
    "subject" => "Hello from the Kitty",
    "from" => {
        "name" => "Hello Kitty",
        "email" => $sender
    },
    "to" => [
        {"email" => $receiver}
    ]
);

my ($result, $mails_sent) = $api->send_emails(%email_data);
ok ($result eq 1, "Email was sent");
ok ($mails_sent gt 0, "Sent more than 0 emails");

# Test number of emails send
ok($api->total_emails_sent() gt 0, "Number of emails sent is higher than 0");

# Done testing
done_testing(plan());
