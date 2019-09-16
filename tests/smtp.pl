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

use SendPulse::SMTP;

# Accept id and secret
my ($client_id, $client_secret, $sender, $receiver) = @ARGV;

# Test class
my $smtp = SendPulse::SMTP->new();
isa_ok (ref($smtp), 'SendPulse::SMTP', 'Class setup');

# Test empty attributes
ok ($smtp->client_secret eq '', 'Empty attribute');

# Test setting attribute
$smtp->client_secret($client_secret);
ok ($smtp->client_secret eq $client_secret, 'Setter/Getter test');

# Test access token
$smtp->client_id($client_id);
like ($smtp->get_access_token, qr/\w+/, 'Test access token');

# Test total emails sent
# like ($smtp->total_emails_sent, qr/\d+/, 'Test total emails sent');

# We are done testing
done_testing(plan());
