package SendPulse::RestApi;

use strict;
use warnings;
use 5.10.0;
use Carp qw(carp croak); # https://perldoc.perl.org/Carp.html

sub new {
    my $type = shift;
    my %param = @_;
    my $this = {
        grant_type => $param{'grant_type'} //= 'client_credentials',
        client_id => $param{'client_id'},
        client_secret => $param{'client_secret'},
        token => '',
        expires_in => 3600,
        token_type => 'Bearer'
    };

    bless $this, $type;
    $this->{token} = $this->requestToken() unless $this->{token};

    return $this;
}
# Request Authorization token
sub requestToken {
    my $self = @_;
    return "the super token";
}

sub sendEmail {
    my ($self, %email_data) = @_;
}

1;
