use strict;
use warnings;
use Test::More;


use note::app;
use note::app::Web;
use note::app::Web::View;
use note::app::Web::ViewFunctions;

use note::app::DB::Schema;
use note::app::Web::Dispatcher;


pass "All modules can load.";

done_testing;
