package SendPulse::SMTP;

use strict;
use warnings;
use 5.10.0;
use HTTP::Request;
use LWP;
use JSON;
use Encode qw(encode_utf8);
use MIME::Base64;
use Log::Log4perl qw(:easy);
use Data::Dumper;

Log::Log4perl->easy_init($DEBUG);

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {
        _client_id => undef,
        _client_secret => undef,
        _access_token => undef,
        _grant_type => 'client_credentials',
        _token_type => 'Bearer',
        _expires_in => 3600
    };

    bless ($self, $class);
    return $self;
}
# Getter/Setter
sub client_secret {
    my $self = shift;

    $self->{_client_secret} = shift if @_;
    return $self->{_client_secret};
}
sub client_id {
    my $self = shift;

    $self->{_client_id} = shift if @_;
    return $self->{_client_id};
}
# Get access token
sub get_access_token {
    my $self = shift;

    my ($code, $content) = $self->_request({
        method => 'POST',
        url => 'https://api.sendpulse.com/oauth/access_token',
        data => [grant_type => 'client_credentials',
            client_secret => $self->{_client_secret},
            client_id => $self->{_client_id}
        ]
    });

    # TODO: Error handling
    # $self->{_access_token} = $content->{access_token};
    # $self->{_token_type} = $content->{token_type};

    return $self->{_access_token};
}
# Retrieving total amount of sent emails
sub total_emails_sent {
    my $self = shift;

    my ($code, $content) = $self->_request({
        method => 'GET',
        url => 'https://api.sendpulse.com/smtp/emails/total',
        header => [Authorization => "Bearer $self->{_access_token}"]
    });
    # DEBUG Dumper($content);
}
# Request
sub _request {
    my ($self, $args) = @_;

    my $data = exists($args->{data}) ? $args->{data} : '';
    my $header = exists($args->{header}) ? $args->{header} : [];

    # DEBUG Dumper([$data, scalar @$header]);
    my $req = HTTP::Request->new(uc($args->{method}), $args->{url}, $header, $data);
    my $ua = LWP::UserAgent->new;
    my $res = $ua->request($req);

    DEBUG Dumper($res->content);
    return ($res->code, $res->content);
}
# Print class state
sub print {
    my $self = shift;
    while ((my $key, my $val) = each %$self) {
        print "$key => $val\n";
    }
}

1;
