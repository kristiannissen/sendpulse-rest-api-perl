package SendPulse::RestApi;

use strict;
use warnings;
use 5.10.0;
use Carp qw(carp croak); # https://perldoc.perl.org/Carp.html

sub new {
    my ($class, %args) = @_;
    my $this = bless {
        grant_type => $args{'grant_type'} //= 'client_credentials',
        client_id => $args{'client_id'},
        client_secret => $args{'client_secret'},
        token => '',
        expires_in => 3600,
        token_type => 'Bearer'
    }, $class;

    $this->{token} = $this->request_token() unless $this->{token};

    return $this;
}
# Request Authorization token
# If SendPulse throws an error pass that using croak
sub request_token {
    my $this = @_;
    return "Hello Token";
}
# Send email to list of recipients
sub send_email {
    my ($self, %email_data) = @_;
}

1;
