use FindBin;
use lib $FindBin::Bin;

use MTPath;
use Test::More;

use_ok 'MT::Blog::Alias';
use_ok 'MT::Blog::Alias::CMS';

done_testing;