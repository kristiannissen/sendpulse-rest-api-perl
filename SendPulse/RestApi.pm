package SendPulse::RestApi;

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
    my ($class, $args) = @_;
    my $self = {
        _client_secret => $args->{client_secret} || '',
        _client_id => $args->{client_id} || '',
        _token => '',
        _token_type => '',
        _grant_type => 'client_credentials'
    };
    bless $self, $class;
    return $self;
}
# Getter/Setter methods
sub set_client_secret {
    my ($self, $client_secret) = @_;
    $self->{_client_secret} = $client_secret;
}
sub get_client_secret {
    my $self = shift;
    return $self->{_client_secret};
}
sub set_client_id {
    my ($self, $client_id) = @_;
    $self->{_client_id} = $client_id;
}
sub get_client_id {
    my $self = shift;
    return $self->{_client_id};
}
# Get the request token
sub get_request_token {
    my $self = shift;

    my ($code, $resp) = $self->_post_request("https://api.sendpulse.com/oauth/access_token",
        [grant_type => $self->{_grant_type},
            client_id => $self->{_client_id},
            client_secret => $self->{_client_secret}]
    );
    return ($code, $resp) if exists($resp->{error});
    
    $self->{_token} = $resp->{access_token};
    $self->{_token_type} = $resp->{token_type};

    return $self->{_token};;
}
sub get_total_emails_sent {
    my $self = shift;

    my ($code, $res) = $self->_get_request("https://api.sendpulse.com/smtp/emails/total",
        [Authorization => "Bearer $self->{_token}"]
    );
    DEBUG Dumper($res);
}
# Get request
sub _get_request {
    my ($self, $url, $header, $params) = @_;
    use HTTP::Request::Common;
    use LWP;

    # my $ua = LWP::UserAgent->new;
    # my $req = HTTP::Request::Common::GET($url, ($params ? $params : []));
    # $req->header(Authorization => "Bearer $self->{_token}");
    # my $res = $ua->request($req);

    # return ($res->code, $res);
}
# Post request
sub _post_request {
    my ($self, $url, $params) = @_;

    use HTTP::Request::Common;
    use LWP;

    my $ua = LWP::UserAgent->new;
    my $req = HTTP::Request::Common::POST($url, $params);
    my $res = $ua->request($req);

    return ($res->code, decode_json($res->content));
}
1;
