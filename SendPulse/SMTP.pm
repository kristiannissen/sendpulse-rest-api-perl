package SendPulse::SMTP;

use strict;
use warnings;
use 5.10.0;
use HTTP::Request::Common;
use LWP;
use JSON;
use MIME::Base64;
use Log::Log4perl qw(:easy);
use Data::Dumper;

Log::Log4perl->easy_init($DEBUG);

sub new {
    my $class = shift;
    my $self = { @_ };
    bless $self, $class;
}
# Print class state
sub print {
    my $self = shift;
    while ((my $key, my $val) = each %$self) {
        print "$key => $val\n";
    }
}

1;
