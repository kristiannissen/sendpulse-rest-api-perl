package SendPulse::RestApi;

use strict;
use warnings;
use 5.10.0;
use Carp qw(carp croak); # https://perldoc.perl.org/Carp.html
use HTTP::Request::Common qw(GET POST);
use LWP;
use JSON;
use MIME::Base64;
use Log::Log4perl qw(:easy);
use Data::Dumper;

Log::Log4perl->easy_init($DEBUG);

sub new {
    my ($class, %args) = @_;

    my $this = bless {
        grant_type => $args{'grant_type'} //= 'client_credentials',
        client_id => $args{'client_id'},
        client_secret => $args{'client_secret'},
        token => '',
        expires_in => 0,
        token_type => 'Bearer',
        ua => undef
    }, $class;

    $this->{ua} = LWP::UserAgent->new unless $this->{ua};

    return $this;
}
# Post request method
# Get request method
sub make_get_request {
    my ($this, $header, $url, @params) = @_;

    my $req = GET $url, @params;
    $req->header($header);

    my $res = $this->{ua}->request($req);

    return ($res->code, decode_json($res->content));
}

1;
