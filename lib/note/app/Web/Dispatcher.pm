package note::app::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

use JSON 2 qw/decode_json/;

any '/' => sub {
    my ($c) = @_;
    return $c->render('index.tx');
};

get '/notes' => sub {
    my ($c) = @_;
    my @entries = $c->db->search( 'notes', {}, { order_by => 'id DESC' } );

    my @res = map { { id => $_->id, note => $_->note, is_todo => $_->is_todo,
        is_done => $_->is_done  } } @entries;

    return $c->render_json( \@res );
};

put '/notes' => sub {
    my ($c) = @_;

    # WANT: clean content
    my $params = decode_json $c->req->content;
    $c->db->insert('notes' => $params);

    return $c->create_response(200,
        ['Content-Type' => 'text/plain'], 'OK');
};

post '/notes/:id' => sub {
    my ($c, $args) = @_;
    my $note_id = $args->{id};
    my $params = decode_json $c->req->content;

    return $c->create_response(404,
        ['Content-Type' => 'text/plain'], 'Wrong Note ID')
        unless $c->db->single( 'notes', { id => $note_id } );

    # clone $params, delete id key
    my %update;
    $update{$_} = $params->{$_} foreach keys %$params;
    delete $update{id};

    $c->db->update( 'notes', \%update, { id => $note_id } );
    return $c->create_response(200,
        ['Content-Type' => 'text/plain'], 'OK');
};

delete_ '/notes/:id' => sub {
    my ($c, $args) = @_;
    my $note_id = $args->{id};

    return $c->create_response(404,
        ['Content-Type' => 'text/plain'], 'Wrong Note ID')
        unless $c->db->single( 'notes', { id => $note_id } );

    $c->db->delete( 'notes', { id => $note_id } );

    return $c->create_response(200,
        ['Content-Type' => 'text/plain'], 'OK');
};

1;
