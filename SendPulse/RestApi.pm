package SendPulse::RestApi;

use strict;
use warnings;
use 5.10.0;
use Carp qw(carp croak); # https://perldoc.perl.org/Carp.html
use HTTP::Request::Common qw(GET POST);
use LWP;
use JSON;
use MIME::Base64;

use Data::Dumper;

sub new {
    my ($class, %args) = @_;

    my $this = bless {
        grant_type => $args{'grant_type'} //= 'client_credentials',
        client_id => $args{'client_id'},
        client_secret => $args{'client_secret'},
        token => '',
        expires_in => 3600,
        token_type => 'Bearer',
        ua => undef
    }, $class;

    $this->{ua} = LWP::UserAgent->new unless $this->{ua};

    return $this;
}
# Make request to the API endpoint
# this->make_request(URL, []);
sub make_request {
    my ($this, $url, @params) = @_;

    my $request = POST $url, @params;
    my $response = $this->{ua}->request($request);

    carp($response->message) unless $response->is_success;

    # Return decoded json content
    decode_json($response->content);
}

# Request Authorization token
sub request_token {
    my ($this) = @_;

    my $json_auth = decode_json($this->make_request("https://api.sendpulse.com/oauth/access_token", [
        "grant_type" => $this->{grant_type},
        "client_id" => $this->{client_id},
        "client_secret" => $this->{client_secret}
    ]));

    if ($json_auth->{error}) {
        carp("Something went wrong! ". $json_auth->{error_description});
    } else {
        $this->{token} = $json_auth->{access_token};
        $this->{token_type} = $json_auth->{token_type};
        $this->{expires} = $json_auth->{expires_in};
    }
}
# Send email to list of recipients
sub send_emails {
    my ($this, %email_data) = @_;

    carp "No email data passed" unless %email_data;

    my $request = POST "https://api.sendpulse.com/smtp/emails", [
        "email" => encode_json(\%email_data)
    ];
    my $token_header = $this->{token_type} ." ". $this->{token};
    $request->header("Authorization", $token_header);

    my $response = $this->{ua}->request($request);
    my $json_content = decode_json($response->content);

    croak($json_content->{error_description}) if $json_content->{error};

    return $json_content->{result};
}

1;
