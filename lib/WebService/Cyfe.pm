package WebService::Cyfe;

use strict;
our $VERSION = '0.01';

use Carp;
use HTTP::Request::Common;
use LWP::UserAgent;
use JSON;
use Data::Printer;

sub new {
    my ( $class, %args ) = @_;

    my %self;
    $self{api_endpoint} = $args{api_endpoint}
      or croak "api_endpoint is required.";
    $self{ua} = LWP::UserAgent->new( agent => __PACKAGE__ . "/$VERSION", );

    $self{debug} = $args{debug} || 0;

    my $self = bless \%self, $class;

    return $self;
}

sub push {
    my ( $self, $send ) = @_;

    my $js = JSON->new;
    $js->canonical(1);
    my $data = $js->encode($send);

    my $req = HTTP::Request->new( POST => $self->{api_endpoint} );
    $req->content($data);
    my $res = $self->{ua}->request($req);
    $self->_parse_response($res);
}

sub _parse_response {
    my ( $self, $res ) = @_;
    p $res if $self->{debug};
    $res->is_success or croak "Request failed: " . $res->status_line;
}

1;

__END__

=head1 NAME

WebService::Cyfe - Push API for Cyfe

=head1 SYNOPSIS

    use WebService::Cyfe;

    my $cyfe = WebService::Cyfe->new( api_endpoint => 'https://...');
    
    $pkg->push(
        {
            'data' => [ { 'Date' => '20140504', 'Users' => 30 } ],
            'onduplicate' => { 'Users' => 'replace' },
            'type'        => { 'Users' => 'line' },
        }
    );

=head1 DESCRIPTION

Simple perl module for use push API, that allows you to push data into your dashboards from your own code.

=head1 AUTHOR

Thiago Rondon E<lt>tbr@cpan.orgE<gt>

=head1 LICENSE
 
This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
  
=head1 SEE ALSO

L<http://www.cyfe.com/api>

=cut

