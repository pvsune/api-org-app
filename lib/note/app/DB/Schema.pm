package note::app::DB::Schema;
use strict;
use warnings;
use utf8;

use Teng::Schema::Declare;

base_row_class 'note::app::DB::Row';

table {
    name 'notes';
    pk 'id';
    columns qw(id note is_todo is_done);
};

1;
