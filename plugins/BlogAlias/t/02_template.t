use strict;
use FindBin;
use lib $FindBin::Bin;

use MTPath;
use Test::More;

use MT::Plugins::Test::Object;
use MT::Plugins::Test::Template;

test_common_website(
    as_superuser => 1,
    test => sub {
        my ( $website, $blog, $user, $password ) = @_;

        $website->alias('website');
        $website->save;

        $blog->alias('blog');
        $blog->save;

        subtest 'mt:BlogAlias in website context' => sub {
            test_template(
                stash => { blog => $website },
                template => q{<mt:BlogAlias>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $website->alias, 'mt:BlogAlias in website context';
                }
            );
        };

        subtest 'mt:BlogAlias in blog context' => sub {
            test_template(
                stash => { blog => $blog },
                template => q{<mt:BlogAlias>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $blog->alias, 'mt:BlogAlias in blog context';
                }
            );
        };

        subtest '~blog in website context' => sub {
            test_template(
                stash => { blog => $website },
                template => q{<mt:MultiBlog include_blogs="~blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $blog->name, '~blog in website context';
                }
            );
        };

        subtest '~blog in blog context' => sub {
            test_template(
                stash => { blog => $blog },
                template => q{<mt:MultiBlog include_blogs="~blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $blog->name, '~blog in blog context';
                }
            );
        };

        subtest '~blog without context' => sub {
            test_template(
                stash => {},
                template => q{<mt:MultiBlog include_blogs="~blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result}, '~blog without context';
                    ok $args{error}, '~blog without context';
                    note $args{error};
                }
            );
        };

        subtest '~/website in website context' => sub {
            test_template(
                stash => { blog => $website },
                template => q{<mt:MultiBlog include_blogs="~/website"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $website->name, '~/website in website context';
                }
            );
        };

        subtest '~/website in blog context' => sub {
            test_template(
                stash => { blog => $blog },
                template => q{<mt:MultiBlog include_blogs="~/website"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $website->name, '~/website in blog context';
                }
            );
        };

        subtest '~website without context' => sub {
            test_template(
                stash => {},
                template => q{<mt:MultiBlog include_blogs="~website"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $website->name, '~website without context';
                }
            );
        };

        subtest '~not_found in website context' => sub {
            test_template(
                stash => { blog => $website },
                template => q{<mt:MultiBlog include_blogs="~not_found"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result}, '~not_found in website context';
                    ok $args{error}, '~not_found in website context';
                    note $args{error};
                }
            );
        };

        subtest '~not_found in blog context' => sub {
            test_template(
                stash => { blog => $blog },
                template => q{<mt:MultiBlog include_blogs="~not_found"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result}, '~not_found in blog context';
                    ok $args{error}, '~not_found in blog context';
                    note $args{error};
                }
            );
        };

        subtest '~not_found without context' => sub {
            test_template(
                stash => {},
                template => q{<mt:MultiBlog include_blogs="~not_found"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result}, '~not_found without context';
                    ok $args{error}, '~not_found without context';
                    note $args{error};
                }
            );
        };

        subtest '~/website/blog in website context' => sub {
            test_template(
                stash => { blog => $website },
                template => q{<mt:MultiBlog include_blogs="~/website/blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $blog->name, '~/website/blog in website context';
                }
            );
        };

        subtest '~/website/blog in blog context' => sub {
            test_template(
                stash => { blog => $blog },
                template => q{<mt:MultiBlog include_blogs="~/website/blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $blog->name, '~/website/blog in blog context';
                }
            );
        };

        subtest '~/website/blog without context' => sub {
            test_template(
                stash => {},
                template => q{<mt:MultiBlog include_blogs="~/website/blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    is $args{result}, $blog->name, '~/website/blog without context';
                }
            );
        };

        subtest '~/website/not_found in website context' => sub {
            test_template(
                stash => { blog => $website },
                template => q{<mt:MultiBlog include_blogs="~/website/not_found"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result}, '~/website/not_found in website context';
                    ok $args{error}, '~/website/not_found in website context';
                    note $args{error};
                }
            );
        };

        subtest '~/website/not_found in blog context' => sub {
            test_template(
                stash => { blog => $blog },
                template => q{<mt:MultiBlog include_blogs="~/website/not_found"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result}, '~/website/not_found in blog context';
                    ok $args{error}, '~/website/not_found in blog context';
                    note $args{error};
                }
            );
        };

        subtest '~/website/not_found without context' => sub {
            test_template(
                stash => {},
                template => q{<mt:MultiBlog include_blogs="~/website/not_found"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result}, '~/website/not_found without context';
                    ok $args{error}, '~/website/not_found without context';
                    note $args{error};
                }
            );
        };

        subtest '~/not_found/blog in website context' => sub {
            test_template(
                stash => { blog => $website },
                template => q{<mt:MultiBlog include_blogs="~/not_found/blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result}, '~/not_found/blog in website context';
                    ok $args{error}, '~/not_found/blog in website context';
                    note $args{error};
                }
            );
        };

        subtest '~/not_found/blog in blog context' => sub {
            test_template(
                stash => { blog => $blog },
                template => q{<mt:MultiBlog include_blogs="~/not_found/blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result}, '~/not_found/blog in blog context';
                    ok $args{error}, '~/not_found/blog in blog context';
                    note $args{error};
                }
            );
        };

        subtest '~/not_found/blog without context' => sub {
            test_template(
                stash => {},
                template => q{<mt:MultiBlog include_blogs="~/not_found/blog"><mt:BlogName></mt:MultiBlog>},
                test => sub {
                    my %args = @_;
                    ok !$args{result}, '~/not_found/blog without context';
                    ok $args{error}, '~/not_found/blog without context';
                    note $args{error};
                }
            );
        };
    }
);

done_testing;