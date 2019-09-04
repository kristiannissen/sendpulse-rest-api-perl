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
# Get request method
sub make_get_request {
    my ($this, $header, $url, @params) = @_;

    my $req = GET $url, @params;
    $req->header($header);

    my $res = $this->{ua}->request($req);

    return ($res->code, decode_json($res->content));
}
## Post request method
sub make_post_request {
    my ($this, $header, $url, @params) = @_;

    my $req = POST $url, @params;
    $req->header($header);

    my $res = $this->{ua}->request($req);

    return ($res->code, decode_json($res->content));
}
## Request access token
sub request_access_token {
    my ($this) = @_;

    my ($code, $res) = $this->make_post_request(
        {},
        "https://api.sendpulse.com/oauth/access_token",
        ["grant_type" => $this->{grant_type},
            "client_id" => $this->{client_id},
            "client_secret" => $this->{client_secret}
        ]
    );
    ## Check the status code
    return ($code, $res) if $code ne 200;

    $this->{token} = $res->{access_token};
    $this->{token_type} = $res->{token_type};
    $this->{expires} = $res->{expires};

    return ($code, {'message' => 'OK'});
}

1;
